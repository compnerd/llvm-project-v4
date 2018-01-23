//===- SymbolTable.cpp ----------------------------------------------------===//
//
//                             The LLVM Linker
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "SymbolTable.h"

#include "Config.h"
#include "InputChunks.h"
#include "WriterUtils.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/Memory.h"

#include <unordered_set>

#define DEBUG_TYPE "lld"

using namespace llvm;
using namespace llvm::wasm;
using namespace lld;
using namespace lld::wasm;

SymbolTable *lld::wasm::Symtab;

void SymbolTable::addFile(InputFile *File) {
  log("Processing: " + toString(File));
  File->parse();

  if (auto *F = dyn_cast<ObjFile>(File))
    ObjectFiles.push_back(F);
}

void SymbolTable::reportRemainingUndefines() {
  std::unordered_set<Symbol *> Undefs;
  for (Symbol *Sym : SymVector) {
    if (Sym->isUndefined() && !Sym->isWeak() &&
        Config->AllowUndefinedSymbols.count(Sym->getName()) == 0) {
      Undefs.insert(Sym);
    }
  }

  if (Undefs.empty())
    return;

  for (ObjFile *File : ObjectFiles)
    for (Symbol *Sym : File->getSymbols())
      if (Undefs.count(Sym))
        error(toString(File) + ": undefined symbol: " + toString(*Sym));

  for (Symbol *Sym : Undefs)
    if (!Sym->getFile())
      error("undefined symbol: " + toString(*Sym));
}

Symbol *SymbolTable::find(StringRef Name) {
  auto It = SymMap.find(CachedHashStringRef(Name));
  if (It == SymMap.end())
    return nullptr;
  return It->second;
}

std::pair<Symbol *, bool> SymbolTable::insert(StringRef Name) {
  Symbol *&Sym = SymMap[CachedHashStringRef(Name)];
  if (Sym)
    return {Sym, false};
  Sym = make<Symbol>(Name, false);
  SymVector.emplace_back(Sym);
  return {Sym, true};
}

void SymbolTable::reportDuplicate(Symbol *Existing, InputFile *NewFile) {
  error("duplicate symbol: " + toString(*Existing) + "\n>>> defined in " +
        toString(Existing->getFile()) + "\n>>> defined in " +
        toString(NewFile));
}

// Check the type of new symbol matches that of the symbol is replacing.
// For functions this can also involve verifying that the signatures match.
static void checkSymbolTypes(const Symbol &Existing, const InputFile &F,
                             Symbol::Kind Kind, const WasmSignature *NewSig) {
  if (Existing.isLazy())
    return;

  bool NewIsFunction = Kind == Symbol::Kind::UndefinedFunctionKind ||
                       Kind == Symbol::Kind::DefinedFunctionKind;

  // First check the symbol types match (i.e. either both are function
  // symbols or both are data symbols).
  if (Existing.isFunction() != NewIsFunction) {
    error("symbol type mismatch: " + Existing.getName() + "\n>>> defined as " +
          (Existing.isFunction() ? "Function" : "Global") + " in " +
          toString(Existing.getFile()) + "\n>>> defined as " +
          (NewIsFunction ? "Function" : "Global") + " in " + F.getName());
    return;
  }

  // For function symbols, optionally check the function signature matches too.
  if (!NewIsFunction || !Config->CheckSignatures)
    return;
  // Skip the signature check if the existing function has no signature (e.g.
  // if it is an undefined symbol generated by --undefined command line flag).
  if (!Existing.hasFunctionType())
    return;

  DEBUG(dbgs() << "checkSymbolTypes: " << Existing.getName() << "\n");
  assert(NewSig);

  const WasmSignature &OldSig = Existing.getFunctionType();
  if (*NewSig == OldSig)
    return;

  error("function signature mismatch: " + Existing.getName() +
        "\n>>> defined as " + toString(OldSig) + " in " +
        toString(Existing.getFile()) + "\n>>> defined as " + toString(*NewSig) +
        " in " + F.getName());
}

Symbol *SymbolTable::addDefinedFunction(StringRef Name,
                                        const WasmSignature *Type,
                                        uint32_t Flags) {
  DEBUG(dbgs() << "addDefinedFunction: " << Name << "\n");
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Symbol::DefinedFunctionKind, nullptr, Flags);
    S->setFunctionType(Type);
  } else if (!S->isFunction()) {
    error("symbol type mismatch: " + Name);
  } else if (!S->isDefined()) {
    DEBUG(dbgs() << "resolving existing undefined function: " << Name << "\n");
    S->update(Symbol::DefinedFunctionKind, nullptr, Flags);
  }
  return S;
}

Symbol *SymbolTable::addDefinedGlobal(StringRef Name) {
  DEBUG(dbgs() << "addDefinedGlobal: " << Name << "\n");
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Symbol::DefinedGlobalKind);
  } else if (!S->isGlobal()) {
    error("symbol type mismatch: " + Name);
  } else {
    DEBUG(dbgs() << "resolving existing undefined global: " << Name << "\n");
    S->update(Symbol::DefinedGlobalKind);
  }
  return S;
}

Symbol *SymbolTable::addDefined(StringRef Name, Symbol::Kind Kind,
                                uint32_t Flags, InputFile *F,
                                const InputSegment *Segment,
                                InputFunction *Function, uint32_t Address) {
  DEBUG(dbgs() << "addDefined: " << Name << " addr:" << Address << "\n");
  Symbol *S;
  bool WasInserted;

  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Kind, F, Flags, Segment, Function, Address);
  } else if (S->isLazy()) {
    // The existing symbol is lazy. Replace it without checking types since
    // lazy symbols don't have any type information.
    DEBUG(dbgs() << "replacing existing lazy symbol: " << Name << "\n");
    S->update(Kind, F, Flags, Segment, Function, Address);
  } else if (!S->isDefined()) {
    // The existing symbol table entry is undefined. The new symbol replaces
    // it, after checking the type matches
    DEBUG(dbgs() << "resolving existing undefined symbol: " << Name << "\n");
    checkSymbolTypes(*S, *F, Kind, Function ? &Function->Signature : nullptr);
    S->update(Kind, F, Flags, Segment, Function, Address);
  } else if ((Flags & WASM_SYMBOL_BINDING_MASK) == WASM_SYMBOL_BINDING_WEAK) {
    // the new symbol is weak we can ignore it
    DEBUG(dbgs() << "existing symbol takes precedence\n");
  } else if (S->isWeak()) {
    // the new symbol is not weak and the existing symbol is, so we replace
    // it
    DEBUG(dbgs() << "replacing existing weak symbol\n");
    checkSymbolTypes(*S, *F, Kind, Function ? &Function->Signature : nullptr);
    S->update(Kind, F, Flags, Segment, Function, Address);
  } else {
    // neither symbol is week. They conflict.
    reportDuplicate(S, F);
  }
  return S;
}

Symbol *SymbolTable::addUndefinedFunction(StringRef Name,
                                          const WasmSignature *Type) {
  DEBUG(dbgs() << "addUndefinedFunction: " << Name << "\n");
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Symbol::UndefinedFunctionKind);
    S->setFunctionType(Type);
  } else if (!S->isFunction()) {
    error("symbol type mismatch: " + Name);
  }
  return S;
}

Symbol *SymbolTable::addUndefined(StringRef Name, Symbol::Kind Kind,
                                  uint32_t Flags, InputFile *F,
                                  const WasmSignature *Type) {
  DEBUG(dbgs() << "addUndefined: " << Name << "\n");
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Kind, F, Flags);
    if (Type)
      S->setFunctionType(Type);
  } else if (S->isLazy()) {
    DEBUG(dbgs() << "resolved by existing lazy\n");
    auto *AF = cast<ArchiveFile>(S->getFile());
    AF->addMember(&S->getArchiveSymbol());
  } else if (S->isDefined()) {
    DEBUG(dbgs() << "resolved by existing\n");
    checkSymbolTypes(*S, *F, Kind, Type);
  }
  return S;
}

void SymbolTable::addLazy(ArchiveFile *F, const Archive::Symbol *Sym) {
  DEBUG(dbgs() << "addLazy: " << Sym->getName() << "\n");
  StringRef Name = Sym->getName();
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Symbol::LazyKind, F);
    S->setArchiveSymbol(*Sym);
  } else if (S->isUndefined()) {
    // There is an existing undefined symbol.  The can load from the
    // archive.
    DEBUG(dbgs() << "replacing existing undefined\n");
    F->addMember(Sym);
  }
}

bool SymbolTable::addComdat(StringRef Name, ObjFile *F) {
  DEBUG(dbgs() << "addComdat: " << Name << "\n");
  ObjFile *&File = ComdatMap[CachedHashStringRef(Name)];
  if (File) {
    DEBUG(dbgs() << "COMDAT already defined\n");
    return false;
  }
  File = F;
  return true;
}

ObjFile *SymbolTable::findComdat(StringRef Name) const {
  auto It = ComdatMap.find(CachedHashStringRef(Name));
  return It == ComdatMap.end() ? nullptr : It->second;
}
