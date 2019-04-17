//===- SyntheticSection.h ---------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Synthetic sections represent chunks of linker-created data. If you
// need to create a chunk of data that to be included in some section
// in the result, you probably want to create that as a synthetic section.
//
// Synthetic sections are designed as input sections as opposed to
// output sections because we want to allow them to be manipulated
// using linker scripts just like other input sections from regular
// files.
//
//===----------------------------------------------------------------------===//

#ifndef LLD_ELF_SYNTHETIC_SECTION_H
#define LLD_ELF_SYNTHETIC_SECTION_H

#include "DWARF.h"
#include "EhFrame.h"
#include "InputSection.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/MC/StringTableBuilder.h"
#include "llvm/Support/Endian.h"
#include <functional>

namespace lld {
namespace elf {
class Defined;

class SyntheticSection : public InputSection {
public:
  SyntheticSection(uint64_t Flags, uint32_t Type, uint32_t Alignment,
                   StringRef Name)
      : InputSection(nullptr, Flags, Type, Alignment, {}, Name,
                     InputSectionBase::Synthetic) {
    this->Live = true;
  }

  virtual ~SyntheticSection() = default;
  virtual void writeTo(uint8_t *Buf) = 0;
  virtual size_t getSize() const = 0;
  virtual void finalizeContents() {}
  // If the section has the SHF_ALLOC flag and the size may be changed if
  // thunks are added, update the section size.
  virtual bool updateAllocSize() { return false; }
  virtual bool isNeeded() const { return true; }

  static bool classof(const SectionBase *D) {
    return D->kind() == InputSectionBase::Synthetic;
  }
};

struct CieRecord {
  EhSectionPiece *Cie = nullptr;
  std::vector<EhSectionPiece *> Fdes;
};

// Section for .eh_frame.
class EhFrameSection final : public SyntheticSection {
public:
  EhFrameSection();
  void writeTo(uint8_t *Buf) override;
  void finalizeContents() override;
  bool isNeeded() const override { return !Sections.empty(); }
  size_t getSize() const override { return Size; }

  template <class ELFT> void addSection(InputSectionBase *S);

  std::vector<EhInputSection *> Sections;
  size_t NumFdes = 0;

  struct FdeData {
    uint32_t PcRel;
    uint32_t FdeVARel;
  };

  std::vector<FdeData> getFdeData() const;
  ArrayRef<CieRecord *> getCieRecords() const { return CieRecords; }

private:
  // This is used only when parsing EhInputSection. We keep it here to avoid
  // allocating one for each EhInputSection.
  llvm::DenseMap<size_t, CieRecord *> OffsetToCie;

  uint64_t Size = 0;

  template <class ELFT, class RelTy>
  void addSectionAux(EhInputSection *S, llvm::ArrayRef<RelTy> Rels);

  template <class ELFT, class RelTy>
  CieRecord *addCie(EhSectionPiece &Piece, ArrayRef<RelTy> Rels);

  template <class ELFT, class RelTy>
  bool isFdeLive(EhSectionPiece &Piece, ArrayRef<RelTy> Rels);

  uint64_t getFdePc(uint8_t *Buf, size_t Off, uint8_t Enc) const;

  std::vector<CieRecord *> CieRecords;

  // CIE records are uniquified by their contents and personality functions.
  llvm::DenseMap<std::pair<ArrayRef<uint8_t>, Symbol *>, CieRecord *> CieMap;
};

class GotSection : public SyntheticSection {
public:
  GotSection();
  size_t getSize() const override { return Size; }
  void finalizeContents() override;
  bool isNeeded() const override;
  void writeTo(uint8_t *Buf) override;

  void addEntry(Symbol &Sym);
  bool addDynTlsEntry(Symbol &Sym);
  bool addTlsIndex();
  uint64_t getGlobalDynAddr(const Symbol &B) const;
  uint64_t getGlobalDynOffset(const Symbol &B) const;

  uint64_t getTlsIndexVA() { return this->getVA() + TlsIndexOff; }
  uint32_t getTlsIndexOff() const { return TlsIndexOff; }

  // Flag to force GOT to be in output if we have relocations
  // that relies on its address.
  bool HasGotOffRel = false;

protected:
  size_t NumEntries = 0;
  uint32_t TlsIndexOff = -1;
  uint64_t Size = 0;
};

// .note.GNU-stack section.
class GnuStackSection : public SyntheticSection {
public:
  GnuStackSection()
      : SyntheticSection(0, llvm::ELF::SHT_PROGBITS, 1, ".note.GNU-stack") {}
  void writeTo(uint8_t *Buf) override {}
  size_t getSize() const override { return 0; }
};

// .note.gnu.build-id section.
class BuildIdSection : public SyntheticSection {
  // First 16 bytes are a header.
  static const unsigned HeaderSize = 16;

public:
  BuildIdSection();
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return HeaderSize + HashSize; }
  void writeBuildId(llvm::ArrayRef<uint8_t> Buf);

private:
  size_t HashSize;
  uint8_t *HashBuf;
};

// BssSection is used to reserve space for copy relocations and common symbols.
// We create three instances of this class for .bss, .bss.rel.ro and "COMMON",
// that are used for writable symbols, read-only symbols and common symbols,
// respectively.
class BssSection final : public SyntheticSection {
public:
  BssSection(StringRef Name, uint64_t Size, uint32_t Alignment);
  void writeTo(uint8_t *) override {
    llvm_unreachable("unexpected writeTo() call for SHT_NOBITS section");
  }
  bool isNeeded() const override { return Size != 0; }
  size_t getSize() const override { return Size; }

  static bool classof(const SectionBase *S) { return S->Bss; }
  uint64_t Size;
};

class MipsGotSection final : public SyntheticSection {
public:
  MipsGotSection();
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }
  bool updateAllocSize() override;
  void finalizeContents() override;
  bool isNeeded() const override;

  // Join separate GOTs built for each input file to generate
  // primary and optional multiple secondary GOTs.
  void build();

  void addEntry(InputFile &File, Symbol &Sym, int64_t Addend, RelExpr Expr);
  void addDynTlsEntry(InputFile &File, Symbol &Sym);
  void addTlsIndex(InputFile &File);

  uint64_t getPageEntryOffset(const InputFile *F, const Symbol &S,
                              int64_t Addend) const;
  uint64_t getSymEntryOffset(const InputFile *F, const Symbol &S,
                             int64_t Addend) const;
  uint64_t getGlobalDynOffset(const InputFile *F, const Symbol &S) const;
  uint64_t getTlsIndexOffset(const InputFile *F) const;

  // Returns the symbol which corresponds to the first entry of the global part
  // of GOT on MIPS platform. It is required to fill up MIPS-specific dynamic
  // table properties.
  // Returns nullptr if the global part is empty.
  const Symbol *getFirstGlobalEntry() const;

  // Returns the number of entries in the local part of GOT including
  // the number of reserved entries.
  unsigned getLocalEntriesNum() const;

  // Return _gp value for primary GOT (nullptr) or particular input file.
  uint64_t getGp(const InputFile *F = nullptr) const;

private:
  // MIPS GOT consists of three parts: local, global and tls. Each part
  // contains different types of entries. Here is a layout of GOT:
  // - Header entries                |
  // - Page entries                  |   Local part
  // - Local entries (16-bit access) |
  // - Local entries (32-bit access) |
  // - Normal global entries         ||  Global part
  // - Reloc-only global entries     ||
  // - TLS entries                   ||| TLS part
  //
  // Header:
  //   Two entries hold predefined value 0x0 and 0x80000000.
  // Page entries:
  //   These entries created by R_MIPS_GOT_PAGE relocation and R_MIPS_GOT16
  //   relocation against local symbols. They are initialized by higher 16-bit
  //   of the corresponding symbol's value. So each 64kb of address space
  //   requires a single GOT entry.
  // Local entries (16-bit access):
  //   These entries created by GOT relocations against global non-preemptible
  //   symbols so dynamic linker is not necessary to resolve the symbol's
  //   values. "16-bit access" means that corresponding relocations address
  //   GOT using 16-bit index. Each unique Symbol-Addend pair has its own
  //   GOT entry.
  // Local entries (32-bit access):
  //   These entries are the same as above but created by relocations which
  //   address GOT using 32-bit index (R_MIPS_GOT_HI16/LO16 etc).
  // Normal global entries:
  //   These entries created by GOT relocations against preemptible global
  //   symbols. They need to be initialized by dynamic linker and they ordered
  //   exactly as the corresponding entries in the dynamic symbols table.
  // Reloc-only global entries:
  //   These entries created for symbols that are referenced by dynamic
  //   relocations R_MIPS_REL32. These entries are not accessed with gp-relative
  //   addressing, but MIPS ABI requires that these entries be present in GOT.
  // TLS entries:
  //   Entries created by TLS relocations.
  //
  // If the sum of local, global and tls entries is less than 64K only single
  // got is enough. Otherwise, multi-got is created. Series of primary and
  // multiple secondary GOTs have the following layout:
  // - Primary GOT
  //     Header
  //     Local entries
  //     Global entries
  //     Relocation only entries
  //     TLS entries
  //
  // - Secondary GOT
  //     Local entries
  //     Global entries
  //     TLS entries
  // ...
  //
  // All GOT entries required by relocations from a single input file entirely
  // belong to either primary or one of secondary GOTs. To reference GOT entries
  // each GOT has its own _gp value points to the "middle" of the GOT.
  // In the code this value loaded to the register which is used for GOT access.
  //
  // MIPS 32 function's prologue:
  //   lui     v0,0x0
  //   0: R_MIPS_HI16  _gp_disp
  //   addiu   v0,v0,0
  //   4: R_MIPS_LO16  _gp_disp
  //
  // MIPS 64:
  //   lui     at,0x0
  //   14: R_MIPS_GPREL16  main
  //
  // Dynamic linker does not know anything about secondary GOTs and cannot
  // use a regular MIPS mechanism for GOT entries initialization. So we have
  // to use an approach accepted by other architectures and create dynamic
  // relocations R_MIPS_REL32 to initialize global entries (and local in case
  // of PIC code) in secondary GOTs. But ironically MIPS dynamic linker
  // requires GOT entries and correspondingly ordered dynamic symbol table
  // entries to deal with dynamic relocations. To handle this problem
  // relocation-only section in the primary GOT contains entries for all
  // symbols referenced in global parts of secondary GOTs. Although the sum
  // of local and normal global entries of the primary got should be less
  // than 64K, the size of the primary got (including relocation-only entries
  // can be greater than 64K, because parts of the primary got that overflow
  // the 64K limit are used only by the dynamic linker at dynamic link-time
  // and not by 16-bit gp-relative addressing at run-time.
  //
  // For complete multi-GOT description see the following link
  // https://dmz-portal.mips.com/wiki/MIPS_Multi_GOT

  // Number of "Header" entries.
  static const unsigned HeaderEntriesNum = 2;

  uint64_t Size = 0;

  // Symbol and addend.
  using GotEntry = std::pair<Symbol *, int64_t>;

  struct FileGot {
    InputFile *File = nullptr;
    size_t StartIndex = 0;

    struct PageBlock {
      size_t FirstIndex;
      size_t Count;
      PageBlock() : FirstIndex(0), Count(0) {}
    };

    // Map output sections referenced by MIPS GOT relocations
    // to the description (index/count) "page" entries allocated
    // for this section.
    llvm::SmallMapVector<const OutputSection *, PageBlock, 16> PagesMap;
    // Maps from Symbol+Addend pair or just Symbol to the GOT entry index.
    llvm::MapVector<GotEntry, size_t> Local16;
    llvm::MapVector<GotEntry, size_t> Local32;
    llvm::MapVector<Symbol *, size_t> Global;
    llvm::MapVector<Symbol *, size_t> Relocs;
    llvm::MapVector<Symbol *, size_t> Tls;
    // Set of symbols referenced by dynamic TLS relocations.
    llvm::MapVector<Symbol *, size_t> DynTlsSymbols;

    // Total number of all entries.
    size_t getEntriesNum() const;
    // Number of "page" entries.
    size_t getPageEntriesNum() const;
    // Number of entries require 16-bit index to access.
    size_t getIndexedEntriesNum() const;
  };

  // Container of GOT created for each input file.
  // After building a final series of GOTs this container
  // holds primary and secondary GOT's.
  std::vector<FileGot> Gots;

  // Return (and create if necessary) `FileGot`.
  FileGot &getGot(InputFile &F);

  // Try to merge two GOTs. In case of success the `Dst` contains
  // result of merging and the function returns true. In case of
  // ovwerflow the `Dst` is unchanged and the function returns false.
  bool tryMergeGots(FileGot & Dst, FileGot & Src, bool IsPrimary);
};

class GotPltSection final : public SyntheticSection {
public:
  GotPltSection();
  void addEntry(Symbol &Sym);
  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;
  bool isNeeded() const override;

  // Flag to force GotPlt to be in output if we have relocations
  // that relies on its address.
  bool HasGotPltOffRel = false;

private:
  std::vector<const Symbol *> Entries;
};

// The IgotPltSection is a Got associated with the PltSection for GNU Ifunc
// Symbols that will be relocated by Target->IRelativeRel.
// On most Targets the IgotPltSection will immediately follow the GotPltSection
// on ARM the IgotPltSection will immediately follow the GotSection.
class IgotPltSection final : public SyntheticSection {
public:
  IgotPltSection();
  void addEntry(Symbol &Sym);
  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;
  bool isNeeded() const override { return !Entries.empty(); }

private:
  std::vector<const Symbol *> Entries;
};

class StringTableSection final : public SyntheticSection {
public:
  StringTableSection(StringRef Name, bool Dynamic);
  unsigned addString(StringRef S, bool HashIt = true);
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }
  bool isDynamic() const { return Dynamic; }

private:
  const bool Dynamic;

  uint64_t Size = 0;

  llvm::DenseMap<StringRef, unsigned> StringMap;
  std::vector<StringRef> Strings;
};

class DynamicReloc {
public:
  DynamicReloc(RelType Type, const InputSectionBase *InputSec,
               uint64_t OffsetInSec, bool UseSymVA, Symbol *Sym, int64_t Addend)
      : Type(Type), Sym(Sym), InputSec(InputSec), OffsetInSec(OffsetInSec),
        UseSymVA(UseSymVA), Addend(Addend), OutputSec(nullptr) {}
  // This constructor records dynamic relocation settings used by MIPS
  // multi-GOT implementation. It's to relocate addresses of 64kb pages
  // lie inside the output section.
  DynamicReloc(RelType Type, const InputSectionBase *InputSec,
               uint64_t OffsetInSec, const OutputSection *OutputSec,
               int64_t Addend)
      : Type(Type), Sym(nullptr), InputSec(InputSec), OffsetInSec(OffsetInSec),
        UseSymVA(false), Addend(Addend), OutputSec(OutputSec) {}

  uint64_t getOffset() const;
  uint32_t getSymIndex() const;

  // Computes the addend of the dynamic relocation. Note that this is not the
  // same as the Addend member variable as it also includes the symbol address
  // if UseSymVA is true.
  int64_t computeAddend() const;

  RelType Type;

private:
  Symbol *Sym;
  const InputSectionBase *InputSec = nullptr;
  uint64_t OffsetInSec;
  // If this member is true, the dynamic relocation will not be against the
  // symbol but will instead be a relative relocation that simply adds the
  // load address. This means we need to write the symbol virtual address
  // plus the original addend as the final relocation addend.
  bool UseSymVA;
  int64_t Addend;
  const OutputSection *OutputSec;
};

template <class ELFT> class DynamicSection final : public SyntheticSection {
  using Elf_Dyn = typename ELFT::Dyn;
  using Elf_Rel = typename ELFT::Rel;
  using Elf_Rela = typename ELFT::Rela;
  using Elf_Relr = typename ELFT::Relr;
  using Elf_Shdr = typename ELFT::Shdr;
  using Elf_Sym = typename ELFT::Sym;

  // finalizeContents() fills this vector with the section contents.
  std::vector<std::pair<int32_t, std::function<uint64_t()>>> Entries;

public:
  DynamicSection();
  void finalizeContents() override;
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }

private:
  void add(int32_t Tag, std::function<uint64_t()> Fn);
  void addInt(int32_t Tag, uint64_t Val);
  void addInSec(int32_t Tag, InputSection *Sec);
  void addInSecRelative(int32_t Tag, InputSection *Sec);
  void addOutSec(int32_t Tag, OutputSection *Sec);
  void addSize(int32_t Tag, OutputSection *Sec);
  void addSym(int32_t Tag, Symbol *Sym);

  uint64_t Size = 0;
};

class RelocationBaseSection : public SyntheticSection {
public:
  RelocationBaseSection(StringRef Name, uint32_t Type, int32_t DynamicTag,
                        int32_t SizeDynamicTag);
  void addReloc(RelType DynType, InputSectionBase *IS, uint64_t OffsetInSec,
                Symbol *Sym);
  // Add a dynamic relocation that might need an addend. This takes care of
  // writing the addend to the output section if needed.
  void addReloc(RelType DynType, InputSectionBase *InputSec,
                uint64_t OffsetInSec, Symbol *Sym, int64_t Addend, RelExpr Expr,
                RelType Type);
  void addReloc(const DynamicReloc &Reloc);
  bool isNeeded() const override { return !Relocs.empty(); }
  size_t getSize() const override { return Relocs.size() * this->Entsize; }
  size_t getRelativeRelocCount() const { return NumRelativeRelocs; }
  void finalizeContents() override;
  int32_t DynamicTag, SizeDynamicTag;

protected:
  std::vector<DynamicReloc> Relocs;
  size_t NumRelativeRelocs = 0;
};

template <class ELFT>
class RelocationSection final : public RelocationBaseSection {
  using Elf_Rel = typename ELFT::Rel;
  using Elf_Rela = typename ELFT::Rela;

public:
  RelocationSection(StringRef Name, bool Sort);
  void writeTo(uint8_t *Buf) override;

private:
  bool Sort;
};

template <class ELFT>
class AndroidPackedRelocationSection final : public RelocationBaseSection {
  using Elf_Rel = typename ELFT::Rel;
  using Elf_Rela = typename ELFT::Rela;

public:
  AndroidPackedRelocationSection(StringRef Name);

  bool updateAllocSize() override;
  size_t getSize() const override { return RelocData.size(); }
  void writeTo(uint8_t *Buf) override {
    memcpy(Buf, RelocData.data(), RelocData.size());
  }

private:
  SmallVector<char, 0> RelocData;
};

struct RelativeReloc {
  uint64_t getOffset() const { return InputSec->getVA(OffsetInSec); }

  const InputSectionBase *InputSec;
  uint64_t OffsetInSec;
};

class RelrBaseSection : public SyntheticSection {
public:
  RelrBaseSection();
  bool isNeeded() const override { return !Relocs.empty(); }
  std::vector<RelativeReloc> Relocs;
};

// RelrSection is used to encode offsets for relative relocations.
// Proposal for adding SHT_RELR sections to generic-abi is here:
//   https://groups.google.com/forum/#!topic/generic-abi/bX460iggiKg
// For more details, see the comment in RelrSection::updateAllocSize().
template <class ELFT> class RelrSection final : public RelrBaseSection {
  using Elf_Relr = typename ELFT::Relr;

public:
  RelrSection();

  bool updateAllocSize() override;
  size_t getSize() const override { return RelrRelocs.size() * this->Entsize; }
  void writeTo(uint8_t *Buf) override {
    memcpy(Buf, RelrRelocs.data(), getSize());
  }

private:
  std::vector<Elf_Relr> RelrRelocs;
};

struct SymbolTableEntry {
  Symbol *Sym;
  size_t StrTabOffset;
};

class SymbolTableBaseSection : public SyntheticSection {
public:
  SymbolTableBaseSection(StringTableSection &StrTabSec);
  void finalizeContents() override;
  size_t getSize() const override { return getNumSymbols() * Entsize; }
  void addSymbol(Symbol *Sym);
  unsigned getNumSymbols() const { return Symbols.size() + 1; }
  size_t getSymbolIndex(Symbol *Sym);
  ArrayRef<SymbolTableEntry> getSymbols() const { return Symbols; }

protected:
  void sortSymTabSymbols();

  // A vector of symbols and their string table offsets.
  std::vector<SymbolTableEntry> Symbols;

  StringTableSection &StrTabSec;

  llvm::once_flag OnceFlag;
  llvm::DenseMap<Symbol *, size_t> SymbolIndexMap;
  llvm::DenseMap<OutputSection *, size_t> SectionIndexMap;
};

template <class ELFT>
class SymbolTableSection final : public SymbolTableBaseSection {
  using Elf_Sym = typename ELFT::Sym;

public:
  SymbolTableSection(StringTableSection &StrTabSec);
  void writeTo(uint8_t *Buf) override;
};

class SymtabShndxSection final : public SyntheticSection {
public:
  SymtabShndxSection();

  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override;
  bool isNeeded() const override;
  void finalizeContents() override;
};

// Outputs GNU Hash section. For detailed explanation see:
// https://blogs.oracle.com/ali/entry/gnu_hash_elf_sections
class GnuHashTableSection final : public SyntheticSection {
public:
  GnuHashTableSection();
  void finalizeContents() override;
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }

  // Adds symbols to the hash table.
  // Sorts the input to satisfy GNU hash section requirements.
  void addSymbols(std::vector<SymbolTableEntry> &Symbols);

private:
  // See the comment in writeBloomFilter.
  enum { Shift2 = 26 };

  void writeBloomFilter(uint8_t *Buf);
  void writeHashTable(uint8_t *Buf);

  struct Entry {
    Symbol *Sym;
    size_t StrTabOffset;
    uint32_t Hash;
    uint32_t BucketIdx;
  };

  std::vector<Entry> Symbols;
  size_t MaskWords;
  size_t NBuckets = 0;
  size_t Size = 0;
};

class HashTableSection final : public SyntheticSection {
public:
  HashTableSection();
  void finalizeContents() override;
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }

private:
  size_t Size = 0;
};

// The PltSection is used for both the Plt and Iplt. The former usually has a
// header as its first entry that is used at run-time to resolve lazy binding.
// The latter is used for GNU Ifunc symbols, that will be subject to a
// Target->IRelativeRel.
class PltSection : public SyntheticSection {
public:
  PltSection(bool IsIplt);
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override;
  bool isNeeded() const override { return !Entries.empty(); }
  void addSymbols();
  template <class ELFT> void addEntry(Symbol &Sym);

  size_t HeaderSize;

private:
  std::vector<const Symbol *> Entries;
  bool IsIplt;
};

class GdbIndexSection final : public SyntheticSection {
public:
  struct AddressEntry {
    InputSection *Section;
    uint64_t LowAddress;
    uint64_t HighAddress;
    uint32_t CuIndex;
  };

  struct CuEntry {
    uint64_t CuOffset;
    uint64_t CuLength;
  };

  struct NameAttrEntry {
    llvm::CachedHashStringRef Name;
    uint32_t CuIndexAndAttrs;
  };

  struct GdbChunk {
    InputSection *Sec;
    std::vector<AddressEntry> AddressAreas;
    std::vector<CuEntry> CompilationUnits;
  };

  struct GdbSymbol {
    llvm::CachedHashStringRef Name;
    std::vector<uint32_t> CuVector;
    uint32_t NameOff;
    uint32_t CuVectorOff;
  };

  GdbIndexSection();
  template <typename ELFT> static GdbIndexSection *create();
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override { return Size; }
  bool isNeeded() const override;

private:
  struct GdbIndexHeader {
    llvm::support::ulittle32_t Version;
    llvm::support::ulittle32_t CuListOff;
    llvm::support::ulittle32_t CuTypesOff;
    llvm::support::ulittle32_t AddressAreaOff;
    llvm::support::ulittle32_t SymtabOff;
    llvm::support::ulittle32_t ConstantPoolOff;
  };

  void initOutputSize();
  size_t computeSymtabSize() const;

  // Each chunk contains information gathered from debug sections of a
  // single object file.
  std::vector<GdbChunk> Chunks;

  // A symbol table for this .gdb_index section.
  std::vector<GdbSymbol> Symbols;

  size_t Size;
};

// --eh-frame-hdr option tells linker to construct a header for all the
// .eh_frame sections. This header is placed to a section named .eh_frame_hdr
// and also to a PT_GNU_EH_FRAME segment.
// At runtime the unwinder then can find all the PT_GNU_EH_FRAME segments by
// calling dl_iterate_phdr.
// This section contains a lookup table for quick binary search of FDEs.
// Detailed info about internals can be found in Ian Lance Taylor's blog:
// http://www.airs.com/blog/archives/460 (".eh_frame")
// http://www.airs.com/blog/archives/462 (".eh_frame_hdr")
class EhFrameHeader final : public SyntheticSection {
public:
  EhFrameHeader();
  void write();
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override;
  bool isNeeded() const override;
};

// For more information about .gnu.version and .gnu.version_r see:
// https://www.akkadia.org/drepper/symbol-versioning

// The .gnu.version_d section which has a section type of SHT_GNU_verdef shall
// contain symbol version definitions. The number of entries in this section
// shall be contained in the DT_VERDEFNUM entry of the .dynamic section.
// The section shall contain an array of Elf_Verdef structures, optionally
// followed by an array of Elf_Verdaux structures.
class VersionDefinitionSection final : public SyntheticSection {
public:
  VersionDefinitionSection();
  void finalizeContents() override;
  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;

private:
  enum { EntrySize = 28 };
  void writeOne(uint8_t *Buf, uint32_t Index, StringRef Name, size_t NameOff);

  unsigned FileDefNameOff;
};

// The .gnu.version section specifies the required version of each symbol in the
// dynamic symbol table. It contains one Elf_Versym for each dynamic symbol
// table entry. An Elf_Versym is just a 16-bit integer that refers to a version
// identifier defined in the either .gnu.version_r or .gnu.version_d section.
// The values 0 and 1 are reserved. All other values are used for versions in
// the own object or in any of the dependencies.
class VersionTableSection final : public SyntheticSection {
public:
  VersionTableSection();
  void finalizeContents() override;
  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;
  bool isNeeded() const override;
};

// The .gnu.version_r section defines the version identifiers used by
// .gnu.version. It contains a linked list of Elf_Verneed data structures. Each
// Elf_Verneed specifies the version requirements for a single DSO, and contains
// a reference to a linked list of Elf_Vernaux data structures which define the
// mapping from version identifiers to version names.
template <class ELFT>
class VersionNeedSection final : public SyntheticSection {
  using Elf_Verneed = typename ELFT::Verneed;
  using Elf_Vernaux = typename ELFT::Vernaux;

  struct Vernaux {
    uint64_t Hash;
    uint32_t VerneedIndex;
    uint64_t NameStrTab;
  };

  struct Verneed {
    uint64_t NameStrTab;
    std::vector<Vernaux> Vernauxs;
  };

  std::vector<Verneed> Verneeds;

public:
  VersionNeedSection();
  void finalizeContents() override;
  void writeTo(uint8_t *Buf) override;
  size_t getSize() const override;
  bool isNeeded() const override;
};

// MergeSyntheticSection is a class that allows us to put mergeable sections
// with different attributes in a single output sections. To do that
// we put them into MergeSyntheticSection synthetic input sections which are
// attached to regular output sections.
class MergeSyntheticSection : public SyntheticSection {
public:
  void addSection(MergeInputSection *MS);
  std::vector<MergeInputSection *> Sections;

protected:
  MergeSyntheticSection(StringRef Name, uint32_t Type, uint64_t Flags,
                        uint32_t Alignment)
      : SyntheticSection(Flags, Type, Alignment, Name) {}
};

class MergeTailSection final : public MergeSyntheticSection {
public:
  MergeTailSection(StringRef Name, uint32_t Type, uint64_t Flags,
                   uint32_t Alignment);

  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;
  void finalizeContents() override;

private:
  llvm::StringTableBuilder Builder;
};

class MergeNoTailSection final : public MergeSyntheticSection {
public:
  MergeNoTailSection(StringRef Name, uint32_t Type, uint64_t Flags,
                     uint32_t Alignment)
      : MergeSyntheticSection(Name, Type, Flags, Alignment) {}

  size_t getSize() const override { return Size; }
  void writeTo(uint8_t *Buf) override;
  void finalizeContents() override;

private:
  // We use the most significant bits of a hash as a shard ID.
  // The reason why we don't want to use the least significant bits is
  // because DenseMap also uses lower bits to determine a bucket ID.
  // If we use lower bits, it significantly increases the probability of
  // hash collisons.
  size_t getShardId(uint32_t Hash) {
    return Hash >> (32 - llvm::countTrailingZeros(NumShards));
  }

  // Section size
  size_t Size;

  // String table contents
  constexpr static size_t NumShards = 32;
  std::vector<llvm::StringTableBuilder> Shards;
  size_t ShardOffsets[NumShards];
};

// .MIPS.abiflags section.
template <class ELFT>
class MipsAbiFlagsSection final : public SyntheticSection {
  using Elf_Mips_ABIFlags = llvm::object::Elf_Mips_ABIFlags<ELFT>;

public:
  static MipsAbiFlagsSection *create();

  MipsAbiFlagsSection(Elf_Mips_ABIFlags Flags);
  size_t getSize() const override { return sizeof(Elf_Mips_ABIFlags); }
  void writeTo(uint8_t *Buf) override;

private:
  Elf_Mips_ABIFlags Flags;
};

// .MIPS.options section.
template <class ELFT> class MipsOptionsSection final : public SyntheticSection {
  using Elf_Mips_Options = llvm::object::Elf_Mips_Options<ELFT>;
  using Elf_Mips_RegInfo = llvm::object::Elf_Mips_RegInfo<ELFT>;

public:
  static MipsOptionsSection *create();

  MipsOptionsSection(Elf_Mips_RegInfo Reginfo);
  void writeTo(uint8_t *Buf) override;

  size_t getSize() const override {
    return sizeof(Elf_Mips_Options) + sizeof(Elf_Mips_RegInfo);
  }

private:
  Elf_Mips_RegInfo Reginfo;
};

// MIPS .reginfo section.
template <class ELFT> class MipsReginfoSection final : public SyntheticSection {
  using Elf_Mips_RegInfo = llvm::object::Elf_Mips_RegInfo<ELFT>;

public:
  static MipsReginfoSection *create();

  MipsReginfoSection(Elf_Mips_RegInfo Reginfo);
  size_t getSize() const override { return sizeof(Elf_Mips_RegInfo); }
  void writeTo(uint8_t *Buf) override;

private:
  Elf_Mips_RegInfo Reginfo;
};

// This is a MIPS specific section to hold a space within the data segment
// of executable file which is pointed to by the DT_MIPS_RLD_MAP entry.
// See "Dynamic section" in Chapter 5 in the following document:
// ftp://www.linux-mips.org/pub/linux/mips/doc/ABI/mipsabi.pdf
class MipsRldMapSection : public SyntheticSection {
public:
  MipsRldMapSection();
  size_t getSize() const override { return Config->Wordsize; }
  void writeTo(uint8_t *Buf) override {}
};

// Representation of the combined .ARM.Exidx input sections. We process these
// as a SyntheticSection like .eh_frame as we need to merge duplicate entries
// and add terminating sentinel entries.
//
// The .ARM.exidx input sections after SHF_LINK_ORDER processing is done form
// a table that the unwinder can derive (Addresses are encoded as offsets from
// table):
// | Address of function | Unwind instructions for function |
// where the unwind instructions are either a small number of unwind or the
// special EXIDX_CANTUNWIND entry representing no unwinding information.
// When an exception is thrown from an address A, the unwinder searches the
// table for the closest table entry with Address of function <= A. This means
// that for two consecutive table entries:
// | A1 | U1 |
// | A2 | U2 |
// The range of addresses described by U1 is [A1, A2)
//
// There are two cases where we need a linker generated table entry to fixup
// the address ranges in the table
// Case 1:
// - A sentinel entry added with an address higher than all
// executable sections. This was needed to work around libunwind bug pr31091.
// - After address assignment we need to find the highest addressed executable
// section and use the limit of that section so that the unwinder never
// matches it.
// Case 2:
// - InputSections without a .ARM.exidx section (usually from Assembly)
// need a table entry so that they terminate the range of the previously
// function. This is pr40277.
//
// Instead of storing pointers to the .ARM.exidx InputSections from
// InputObjects, we store pointers to the executable sections that need
// .ARM.exidx sections. We can then use the dependentSections of these to
// either find the .ARM.exidx section or know that we need to generate one.
class ARMExidxSyntheticSection : public SyntheticSection {
public:
  ARMExidxSyntheticSection();

  // Add an input section to the ARMExidxSyntheticSection. Returns whether the
  // section needs to be removed from the main input section list.
  bool addSection(InputSection *IS);

  size_t getSize() const override { return Size; }
  void writeTo(uint8_t *Buf) override;
  bool isNeeded() const override { return !Empty; }
  // Sort and remove duplicate entries.
  void finalizeContents() override;
  InputSection *getLinkOrderDep() const;

  static bool classof(const SectionBase *D);

  // Links to the ARMExidxSections so we can transfer the relocations once the
  // layout is known.
  std::vector<InputSection *> ExidxSections;

private:
  size_t Size;

  // Empty if ExecutableSections contains no dependent .ARM.exidx sections.
  bool Empty = true;

  // Instead of storing pointers to the .ARM.exidx InputSections from
  // InputObjects, we store pointers to the executable sections that need
  // .ARM.exidx sections. We can then use the dependentSections of these to
  // either find the .ARM.exidx section or know that we need to generate one.
  std::vector<InputSection *> ExecutableSections;

  // The executable InputSection with the highest address to use for the
  // sentinel. We store separately from ExecutableSections as merging of
  // duplicate entries may mean this InputSection is removed from
  // ExecutableSections.
  InputSection *Sentinel = nullptr;
};

// A container for one or more linker generated thunks. Instances of these
// thunks including ARM interworking and Mips LA25 PI to non-PI thunks.
class ThunkSection : public SyntheticSection {
public:
  // ThunkSection in OS, with desired OutSecOff of Off
  ThunkSection(OutputSection *OS, uint64_t Off);

  // Add a newly created Thunk to this container:
  // Thunk is given offset from start of this InputSection
  // Thunk defines a symbol in this InputSection that can be used as target
  // of a relocation
  void addThunk(Thunk *T);
  size_t getSize() const override { return Size; }
  void writeTo(uint8_t *Buf) override;
  InputSection *getTargetInputSection() const;
  bool assignOffsets();

private:
  std::vector<Thunk *> Thunks;
  size_t Size = 0;
};

// This section is used to store the addresses of functions that are called
// in range-extending thunks on PowerPC64. When producing position dependant
// code the addresses are link-time constants and the table is written out to
// the binary. When producing position-dependant code the table is allocated and
// filled in by the dynamic linker.
class PPC64LongBranchTargetSection final : public SyntheticSection {
public:
  PPC64LongBranchTargetSection();
  void addEntry(Symbol &Sym);
  size_t getSize() const override;
  void writeTo(uint8_t *Buf) override;
  bool isNeeded() const override;
  void finalizeContents() override { Finalized = true; }

private:
  std::vector<const Symbol *> Entries;
  bool Finalized = false;
};

InputSection *createInterpSection();
MergeInputSection *createCommentSection();
template <class ELFT> void splitSections();
void mergeSections();

Defined *addSyntheticLocal(StringRef Name, uint8_t Type, uint64_t Value,
                           uint64_t Size, InputSectionBase &Section);

void addVerneed(Symbol *SS);

// Linker generated sections which can be used as inputs.
struct InStruct {
  InputSection *ARMAttributes;
  ARMExidxSyntheticSection *ARMExidx;
  BssSection *Bss;
  BssSection *BssRelRo;
  BuildIdSection *BuildId;
  EhFrameHeader *EhFrameHdr;
  EhFrameSection *EhFrame;
  SyntheticSection *Dynamic;
  StringTableSection *DynStrTab;
  SymbolTableBaseSection *DynSymTab;
  GnuHashTableSection *GnuHashTab;
  HashTableSection *HashTab;
  GotSection *Got;
  GotPltSection *GotPlt;
  IgotPltSection *IgotPlt;
  PPC64LongBranchTargetSection *PPC64LongBranchTarget;
  MipsGotSection *MipsGot;
  MipsRldMapSection *MipsRldMap;
  PltSection *Plt;
  PltSection *Iplt;
  RelocationBaseSection *RelaDyn;
  RelrBaseSection *RelrDyn;
  RelocationBaseSection *RelaPlt;
  RelocationBaseSection *RelaIplt;
  StringTableSection *ShStrTab;
  StringTableSection *StrTab;
  SymbolTableBaseSection *SymTab;
  SymtabShndxSection *SymTabShndx;
  VersionDefinitionSection *VerDef;
  SyntheticSection *VerNeed;
  VersionTableSection *VerSym;
};

extern InStruct In;

} // namespace elf
} // namespace lld

#endif
