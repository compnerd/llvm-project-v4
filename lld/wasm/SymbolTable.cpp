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
#include "WriterUtils.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/Memory.h"

#include <unordered_set>

#define DEBUG_TYPE "lld"

using namespace llvm;
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
  for (auto &I : SymMap) {
    Symbol *Sym = I.second;
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
  return {Sym, true};
}

void SymbolTable::reportDuplicate(Symbol *Existing, InputFile *NewFile) {
  error("duplicate symbol: " + toString(*Existing) + "\n>>> defined in " +
        toString(Existing->getFile()) + "\n>>> defined in " +
        toString(NewFile));
}

// Get the signature for a given function symbol, either by looking
// it up in function sections (for defined functions), of the imports section
// (for imported functions).
static const WasmSignature *getFunctionSig(const ObjFile &Obj,
                                           const WasmSymbol &Sym) {
  DEBUG(dbgs() << "getFunctionSig: " << Sym.Name << "\n");
  const WasmObjectFile *WasmObj = Obj.getWasmObj();
  uint32_t FunctionType;
  if (Obj.isImportedFunction(Sym.ElementIndex)) {
    const WasmImport &Import = WasmObj->imports()[Sym.ImportIndex];
    FunctionType = Import.SigIndex;
  } else {
    uint32_t FuntionIndex = Sym.ElementIndex - Obj.NumFunctionImports();
    FunctionType = WasmObj->functionTypes()[FuntionIndex];
  }
  return &WasmObj->types()[FunctionType];
}

// Check the type of new symbol matches that of the symbol is replacing.
// For functions this can also involve verifying that the signatures match.
static void checkSymbolTypes(const Symbol &Existing, const InputFile &F,
                             const WasmSymbol &New,
                             const WasmSignature *NewSig) {
  if (Existing.isLazy())
    return;

  bool NewIsFunction = New.Type == WasmSymbol::SymbolType::FUNCTION_EXPORT ||
                       New.Type == WasmSymbol::SymbolType::FUNCTION_IMPORT;

  // First check the symbol types match (i.e. either both are function
  // symbols or both are data symbols).
  if (Existing.isFunction() != NewIsFunction) {
    error("symbol type mismatch: " + New.Name + "\n>>> defined as " +
          (Existing.isFunction() ? "Function" : "Global") + " in " +
          toString(Existing.getFile()) + "\n>>> defined as " +
          (NewIsFunction ? "Function" : "Global") + " in " + F.getName());
    return;
  }

  // For function symbols, optionally check the function signature matches too.
  if (!NewIsFunction || !Config->CheckSignatures)
    return;

  DEBUG(dbgs() << "checkSymbolTypes: " << New.Name << "\n");
  assert(NewSig);

  const WasmSignature &OldSig = Existing.getFunctionType();
  if (*NewSig == OldSig)
    return;

  error("function signature mismatch: " + New.Name + "\n>>> defined as " +
        toString(OldSig) + " in " + toString(Existing.getFile()) +
        "\n>>> defined as " + toString(*NewSig) + " in " + F.getName());
}

Symbol *SymbolTable::addDefinedGlobal(StringRef Name) {
  DEBUG(dbgs() << "addDefinedGlobal: " << Name << "\n");
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted)
    S->update(Symbol::DefinedGlobalKind);
  else if (!S->isGlobal())
    error("symbol type mismatch: " + Name);
  return S;
}

Symbol *SymbolTable::addDefined(InputFile *F, const WasmSymbol *Sym,
                                const InputSegment *Segment) {
  DEBUG(dbgs() << "addDefined: " << Sym->Name << "\n");
  Symbol *S;
  bool WasInserted;
  Symbol::Kind Kind = Symbol::DefinedFunctionKind;
  const WasmSignature *NewSig = nullptr;
  if (Sym->Type == WasmSymbol::SymbolType::GLOBAL_EXPORT)
    Kind = Symbol::DefinedGlobalKind;
  else
    NewSig = getFunctionSig(*cast<ObjFile>(F), *Sym);

  std::tie(S, WasInserted) = insert(Sym->Name);
  if (WasInserted) {
    S->update(Kind, F, Sym, Segment, NewSig);
  } else if (S->isLazy()) {
    // The existing symbol is lazy. Replace it without checking types since
    // lazy symbols don't have any type information.
    DEBUG(dbgs() << "replacing existing lazy symbol: " << Sym->Name << "\n");
    S->update(Kind, F, Sym, Segment, NewSig);
  } else if (!S->isDefined()) {
    // The existing symbol table entry is undefined. The new symbol replaces
    // it, after checking the type matches
    DEBUG(dbgs() << "resolving existing undefined symbol: " << Sym->Name
                 << "\n");
    checkSymbolTypes(*S, *F, *Sym, NewSig);
    S->update(Kind, F, Sym, Segment, NewSig);
  } else if (Sym->isWeak()) {
    // the new symbol is weak we can ignore it
    DEBUG(dbgs() << "existing symbol takes precedence\n");
  } else if (S->isWeak()) {
    // the new symbol is not weak and the existing symbol is, so we replace
    // it
    DEBUG(dbgs() << "replacing existing weak symbol\n");
    checkSymbolTypes(*S, *F, *Sym, NewSig);
    S->update(Kind, F, Sym, Segment, NewSig);
  } else {
    // neither symbol is week. They conflict.
    reportDuplicate(S, F);
  }
  return S;
}

Symbol *SymbolTable::addUndefinedFunction(StringRef Name,
                                          const WasmSignature *Type) {
  Symbol *S;
  bool WasInserted;
  std::tie(S, WasInserted) = insert(Name);
  if (WasInserted) {
    S->update(Symbol::UndefinedFunctionKind, nullptr, nullptr, nullptr, Type);
  } else if (!S->isFunction()) {
    error("symbol type mismatch: " + Name);
  }
  return S;
}

Symbol *SymbolTable::addUndefined(InputFile *F, const WasmSymbol *Sym) {
  DEBUG(dbgs() << "addUndefined: " << Sym->Name << "\n");
  Symbol *S;
  bool WasInserted;
  Symbol::Kind Kind = Symbol::UndefinedFunctionKind;
  const WasmSignature *NewSig = nullptr;
  if (Sym->Type == WasmSymbol::SymbolType::GLOBAL_IMPORT)
    Kind = Symbol::UndefinedGlobalKind;
  else
    NewSig = getFunctionSig(*cast<ObjFile>(F), *Sym);
  std::tie(S, WasInserted) = insert(Sym->Name);
  if (WasInserted) {
    S->update(Kind, F, Sym, nullptr, NewSig);
  } else if (S->isLazy()) {
    DEBUG(dbgs() << "resolved by existing lazy\n");
    auto *AF = cast<ArchiveFile>(S->getFile());
    AF->addMember(&S->getArchiveSymbol());
  } else if (S->isDefined()) {
    DEBUG(dbgs() << "resolved by existing\n");
    checkSymbolTypes(*S, *F, *Sym, NewSig);
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
