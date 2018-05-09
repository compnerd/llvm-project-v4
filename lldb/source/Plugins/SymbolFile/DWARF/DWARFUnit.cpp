//===-- DWARFUnit.cpp -------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "DWARFUnit.h"

#include "Plugins/Language/ObjC/ObjCLanguage.h"
#include "lldb/Core/Module.h"
#include "lldb/Host/StringConvert.h"
#include "lldb/Symbol/CompileUnit.h"
#include "lldb/Symbol/LineTable.h"
#include "lldb/Symbol/ObjectFile.h"
#include "lldb/Utility/Timer.h"

#include "DWARFDIECollection.h"
#include "DWARFDebugAbbrev.h"
#include "DWARFDebugAranges.h"
#include "DWARFDebugInfo.h"
#include "LogChannelDWARF.h"
#include "SymbolFileDWARFDebugMap.h"
#include "SymbolFileDWARFDwo.h"

using namespace lldb;
using namespace lldb_private;
using namespace std;

extern int g_verbose;

DWARFUnit::DWARFUnit(SymbolFileDWARF *dwarf) : m_dwarf(dwarf) {}

DWARFUnit::~DWARFUnit() {}

//----------------------------------------------------------------------
// ParseCompileUnitDIEsIfNeeded
//
// Parses a compile unit and indexes its DIEs if it hasn't already been done.
//----------------------------------------------------------------------
size_t DWARFUnit::ExtractDIEsIfNeeded(bool cu_die_only) {
  size_t initial_die_array_size;
  auto already_parsed = [cu_die_only, &initial_die_array_size, this]() -> bool {
    initial_die_array_size = m_die_array.size();
    return (cu_die_only && initial_die_array_size > 0)
        || initial_die_array_size > 1;
  };
  {
    llvm::sys::ScopedReader lock(m_extractdies_mutex);
    if (already_parsed())
      return 0;
  }
  llvm::sys::ScopedWriter lock(m_extractdies_mutex);
  if (already_parsed())
    return 0;

  static Timer::Category func_cat(LLVM_PRETTY_FUNCTION);
  Timer scoped_timer(
      func_cat, "%8.8x: DWARFUnit::ExtractDIEsIfNeeded( cu_die_only = %i )",
      m_offset, cu_die_only);

  // Set the offset to that of the first DIE and calculate the start of the
  // next compilation unit header.
  lldb::offset_t offset = GetFirstDIEOffset();
  lldb::offset_t next_cu_offset = GetNextCompileUnitOffset();

  DWARFDebugInfoEntry die;
  // Keep a flat array of the DIE for binary lookup by DIE offset
  if (!cu_die_only) {
    Log *log(
        LogChannelDWARF::GetLogIfAny(DWARF_LOG_DEBUG_INFO | DWARF_LOG_LOOKUPS));
    if (log) {
      m_dwarf->GetObjectFile()->GetModule()->LogMessageVerboseBacktrace(
          log,
          "DWARFUnit::ExtractDIEsIfNeeded () for compile unit at "
          ".debug_info[0x%8.8x]",
          GetOffset());
    }
  }

  uint32_t depth = 0;
  // We are in our compile unit, parse starting at the offset we were told to
  // parse
  const DWARFDataExtractor &data = GetData();
  std::vector<uint32_t> die_index_stack;
  die_index_stack.reserve(32);
  die_index_stack.push_back(0);
  bool prev_die_had_children = false;
  DWARFFormValue::FixedFormSizes fixed_form_sizes =
      DWARFFormValue::GetFixedFormSizesForAddressSize(GetAddressByteSize(),
                                                      IsDWARF64());
  while (offset < next_cu_offset &&
         die.FastExtract(data, this, fixed_form_sizes, &offset)) {
    //        if (log)
    //            log->Printf("0x%8.8x: %*.*s%s%s",
    //                        die.GetOffset(),
    //                        depth * 2, depth * 2, "",
    //                        DW_TAG_value_to_name (die.Tag()),
    //                        die.HasChildren() ? " *" : "");

    const bool null_die = die.IsNULL();
    if (depth == 0) {
      if (initial_die_array_size == 0)
        AddUnitDIE(die);
      uint64_t base_addr = die.GetAttributeValueAsAddress(
          m_dwarf, this, DW_AT_low_pc, LLDB_INVALID_ADDRESS);
      if (base_addr == LLDB_INVALID_ADDRESS)
        base_addr =
            die.GetAttributeValueAsAddress(m_dwarf, this, DW_AT_entry_pc, 0);
      SetBaseAddress(base_addr);
      if (cu_die_only)
        return 1;
    } else {
      if (null_die) {
        if (prev_die_had_children) {
          // This will only happen if a DIE says is has children but all it
          // contains is a NULL tag. Since we are removing the NULL DIEs from
          // the list (saves up to 25% in C++ code), we need a way to let the
          // DIE know that it actually doesn't have children.
          if (!m_die_array.empty())
            m_die_array.back().SetEmptyChildren(true);
        }
      } else {
        die.SetParentIndex(m_die_array.size() - die_index_stack[depth - 1]);

        if (die_index_stack.back())
          m_die_array[die_index_stack.back()].SetSiblingIndex(
              m_die_array.size() - die_index_stack.back());

        // Only push the DIE if it isn't a NULL DIE
        m_die_array.push_back(die);
      }
    }

    if (null_die) {
      // NULL DIE.
      if (!die_index_stack.empty())
        die_index_stack.pop_back();

      if (depth > 0)
        --depth;
      if (depth == 0)
        break; // We are done with this compile unit!

      prev_die_had_children = false;
    } else {
      die_index_stack.back() = m_die_array.size() - 1;
      // Normal DIE
      const bool die_has_children = die.HasChildren();
      if (die_has_children) {
        die_index_stack.push_back(0);
        ++depth;
      }
      prev_die_had_children = die_has_children;
    }
  }

  // Give a little bit of info if we encounter corrupt DWARF (our offset should
  // always terminate at or before the start of the next compilation unit
  // header).
  if (offset > next_cu_offset) {
    m_dwarf->GetObjectFile()->GetModule()->ReportWarning(
        "DWARF compile unit extends beyond its bounds cu 0x%8.8x at "
        "0x%8.8" PRIx64 "\n",
        GetOffset(), offset);
  }

  // Since std::vector objects will double their size, we really need to make a
  // new array with the perfect size so we don't end up wasting space. So here
  // we copy and swap to make sure we don't have any extra memory taken up.

  if (m_die_array.size() < m_die_array.capacity()) {
    DWARFDebugInfoEntry::collection exact_size_die_array(m_die_array.begin(),
                                                         m_die_array.end());
    exact_size_die_array.swap(m_die_array);
  }
  Log *log(LogChannelDWARF::GetLogIfAll(DWARF_LOG_DEBUG_INFO));
  if (log && log->GetVerbose()) {
    StreamString strm;
    Dump(&strm);
    if (m_die_array.empty())
      strm.Printf("error: no DIE for compile unit");
    else
      m_die_array[0].Dump(m_dwarf, this, strm, UINT32_MAX);
    log->PutString(strm.GetString());
  }

  if (!m_dwo_symbol_file)
    return m_die_array.size();

  DWARFUnit *dwo_cu = m_dwo_symbol_file->GetCompileUnit();
  size_t dwo_die_count = dwo_cu->ExtractDIEsIfNeeded(cu_die_only);
  return m_die_array.size() + dwo_die_count -
         1; // We have 2 CU die, but we want to count it only as one
}

void DWARFUnit::AddUnitDIE(DWARFDebugInfoEntry &die) {
  assert(m_die_array.empty() && "Compile unit DIE already added");

  // The average bytes per DIE entry has been seen to be around 14-20 so lets
  // pre-reserve half of that since we are now stripping the NULL tags.
  
  // Only reserve the memory if we are adding children of the main compile unit
  // DIE. The compile unit DIE is always the first entry, so if our size is 1,
  // then we are adding the first compile unit child DIE and should reserve the
  // memory.
  m_die_array.reserve(GetDebugInfoSize() / 24);
  m_die_array.push_back(die);

  const DWARFDebugInfoEntry &cu_die = m_die_array.front();
  std::unique_ptr<SymbolFileDWARFDwo> dwo_symbol_file =
      m_dwarf->GetDwoSymbolFileForCompileUnit(*this, cu_die);
  if (!dwo_symbol_file)
    return;

  DWARFUnit *dwo_cu = dwo_symbol_file->GetCompileUnit();
  if (!dwo_cu)
    return; // Can't fetch the compile unit from the dwo file.

  DWARFDIE dwo_cu_die = dwo_cu->GetUnitDIEOnly();
  if (!dwo_cu_die.IsValid())
    return; // Can't fetch the compile unit DIE from the dwo file.

  uint64_t main_dwo_id =
      cu_die.GetAttributeValueAsUnsigned(m_dwarf, this, DW_AT_GNU_dwo_id, 0);
  uint64_t sub_dwo_id =
      dwo_cu_die.GetAttributeValueAsUnsigned(DW_AT_GNU_dwo_id, 0);
  if (main_dwo_id != sub_dwo_id)
    return; // The 2 dwo ID isn't match. Don't use the dwo file as it belongs to
  // a differectn compilation.

  m_dwo_symbol_file = std::move(dwo_symbol_file);

  dw_addr_t addr_base =
      cu_die.GetAttributeValueAsUnsigned(m_dwarf, this, DW_AT_GNU_addr_base, 0);
  dw_addr_t ranges_base = cu_die.GetAttributeValueAsUnsigned(
      m_dwarf, this, DW_AT_GNU_ranges_base, 0);
  dwo_cu->SetAddrBase(addr_base, ranges_base, m_offset);
}

DWARFDIE DWARFUnit::LookupAddress(const dw_addr_t address) {
  if (DIE()) {
    const DWARFDebugAranges &func_aranges = GetFunctionAranges();

    // Re-check the aranges auto pointer contents in case it was created above
    if (!func_aranges.IsEmpty())
      return GetDIE(func_aranges.FindAddress(address));
  }
  return DWARFDIE();
}

size_t DWARFUnit::AppendDIEsWithTag(const dw_tag_t tag,
				    DWARFDIECollection &dies,
				    uint32_t depth) const {
  size_t old_size = dies.Size();
  DWARFDebugInfoEntry::const_iterator pos;
  DWARFDebugInfoEntry::const_iterator end = m_die_array.end();
  for (pos = m_die_array.begin(); pos != end; ++pos) {
    if (pos->Tag() == tag)
      dies.Append(DWARFDIE(this, &(*pos)));
  }

  // Return the number of DIEs added to the collection
  return dies.Size() - old_size;
}


lldb::user_id_t DWARFUnit::GetID() const {
  dw_offset_t local_id =
      m_base_obj_offset != DW_INVALID_OFFSET ? m_base_obj_offset : m_offset;
  if (m_dwarf)
    return DIERef(local_id, local_id).GetUID(m_dwarf);
  else
    return local_id;
}

dw_offset_t DWARFUnit::GetNextCompileUnitOffset() const {
  return m_offset + GetLengthByteSize() + GetLength();
}

size_t DWARFUnit::GetDebugInfoSize() const {
  return GetLengthByteSize() + GetLength() - GetHeaderByteSize();
}

const DWARFAbbreviationDeclarationSet *DWARFUnit::GetAbbreviations() const {
  return m_abbrevs;
}

dw_offset_t DWARFUnit::GetAbbrevOffset() const {
  return m_abbrevs ? m_abbrevs->GetOffset() : DW_INVALID_OFFSET;
}

void DWARFUnit::SetAddrBase(dw_addr_t addr_base,
                            dw_addr_t ranges_base,
                            dw_offset_t base_obj_offset) {
  m_addr_base = addr_base;
  m_ranges_base = ranges_base;
  m_base_obj_offset = base_obj_offset;
}

void DWARFUnit::ClearDIEs(bool keep_compile_unit_die) {
  if (m_die_array.size() > 1) {
    llvm::sys::ScopedWriter lock(m_extractdies_mutex);

    // std::vectors never get any smaller when resized to a smaller size, or
    // when clear() or erase() are called, the size will report that it is
    // smaller, but the memory allocated remains intact (call capacity() to see
    // this). So we need to create a temporary vector and swap the contents
    // which will cause just the internal pointers to be swapped so that when
    // "tmp_array" goes out of scope, it will destroy the contents.

    // Save at least the compile unit DIE
    DWARFDebugInfoEntry::collection tmp_array;
    m_die_array.swap(tmp_array);
    if (keep_compile_unit_die)
      m_die_array.push_back(tmp_array.front());
  }

  if (m_dwo_symbol_file)
    m_dwo_symbol_file->GetCompileUnit()->ClearDIEs(keep_compile_unit_die);
}

void DWARFUnit::BuildAddressRangeTable(SymbolFileDWARF *dwarf,
                                       DWARFDebugAranges *debug_aranges) {
  // This function is usually called if there in no .debug_aranges section in
  // order to produce a compile unit level set of address ranges that is
  // accurate.

  size_t num_debug_aranges = debug_aranges->GetNumRanges();

  // First get the compile unit DIE only and check if it has a DW_AT_ranges
  const DWARFDebugInfoEntry *die = GetUnitDIEPtrOnly();

  const dw_offset_t cu_offset = GetOffset();
  if (die) {
    DWARFRangeList ranges;
    const size_t num_ranges =
        die->GetAttributeAddressRanges(dwarf, this, ranges, false);
    if (num_ranges > 0) {
      // This compile unit has DW_AT_ranges, assume this is correct if it is
      // present since clang no longer makes .debug_aranges by default and it
      // emits DW_AT_ranges for DW_TAG_compile_units. GCC also does this with
      // recent GCC builds.
      for (size_t i = 0; i < num_ranges; ++i) {
        const DWARFRangeList::Entry &range = ranges.GetEntryRef(i);
        debug_aranges->AppendRange(cu_offset, range.GetRangeBase(),
                                   range.GetRangeEnd());
      }

      return; // We got all of our ranges from the DW_AT_ranges attribute
    }
  }
  // We don't have a DW_AT_ranges attribute, so we need to parse the DWARF

  // If the DIEs weren't parsed, then we don't want all dies for all compile
  // units to stay loaded when they weren't needed. So we can end up parsing
  // the DWARF and then throwing them all away to keep memory usage down.
  const bool clear_dies = ExtractDIEsIfNeeded(false) > 1;

  die = DIEPtr();
  if (die)
    die->BuildAddressRangeTable(dwarf, this, debug_aranges);

  if (debug_aranges->GetNumRanges() == num_debug_aranges) {
    // We got nothing from the functions, maybe we have a line tables only
    // situation. Check the line tables and build the arange table from this.
    SymbolContext sc;
    sc.comp_unit = dwarf->GetCompUnitForDWARFCompUnit(this);
    if (sc.comp_unit) {
      SymbolFileDWARFDebugMap *debug_map_sym_file =
          m_dwarf->GetDebugMapSymfile();
      if (debug_map_sym_file == NULL) {
        LineTable *line_table = sc.comp_unit->GetLineTable();

        if (line_table) {
          LineTable::FileAddressRanges file_ranges;
          const bool append = true;
          const size_t num_ranges =
              line_table->GetContiguousFileAddressRanges(file_ranges, append);
          for (uint32_t idx = 0; idx < num_ranges; ++idx) {
            const LineTable::FileAddressRanges::Entry &range =
                file_ranges.GetEntryRef(idx);
            debug_aranges->AppendRange(cu_offset, range.GetRangeBase(),
                                       range.GetRangeEnd());
          }
        }
      } else
        debug_map_sym_file->AddOSOARanges(dwarf, debug_aranges);
    }
  }

  if (debug_aranges->GetNumRanges() == num_debug_aranges) {
    // We got nothing from the functions, maybe we have a line tables only
    // situation. Check the line tables and build the arange table from this.
    SymbolContext sc;
    sc.comp_unit = dwarf->GetCompUnitForDWARFCompUnit(this);
    if (sc.comp_unit) {
      LineTable *line_table = sc.comp_unit->GetLineTable();

      if (line_table) {
        LineTable::FileAddressRanges file_ranges;
        const bool append = true;
        const size_t num_ranges =
            line_table->GetContiguousFileAddressRanges(file_ranges, append);
        for (uint32_t idx = 0; idx < num_ranges; ++idx) {
          const LineTable::FileAddressRanges::Entry &range =
              file_ranges.GetEntryRef(idx);
          debug_aranges->AppendRange(GetOffset(), range.GetRangeBase(),
                                     range.GetRangeEnd());
        }
      }
    }
  }

  // Keep memory down by clearing DIEs if this generate function caused them to
  // be parsed
  if (clear_dies)
    ClearDIEs(true);
}

lldb::ByteOrder DWARFUnit::GetByteOrder() const {
  return m_dwarf->GetObjectFile()->GetByteOrder();
}

TypeSystem *DWARFUnit::GetTypeSystem() {
  if (m_dwarf)
    return m_dwarf->GetTypeSystemForLanguage(GetLanguageType());
  else
    return nullptr;
}

DWARFFormValue::FixedFormSizes DWARFUnit::GetFixedFormSizes() {
  return DWARFFormValue::GetFixedFormSizesForAddressSize(GetAddressByteSize(),
                                                         IsDWARF64());
}

void DWARFUnit::SetBaseAddress(dw_addr_t base_addr) { m_base_addr = base_addr; }

bool DWARFUnit::HasDIEsParsed() const { return m_die_array.size() > 1; }

//----------------------------------------------------------------------
// Compare function DWARFDebugAranges::Range structures
//----------------------------------------------------------------------
static bool CompareDIEOffset(const DWARFDebugInfoEntry &die,
                             const dw_offset_t die_offset) {
  return die.GetOffset() < die_offset;
}

//----------------------------------------------------------------------
// GetDIE()
//
// Get the DIE (Debug Information Entry) with the specified offset by first
// checking if the DIE is contained within this compile unit and grabbing the
// DIE from this compile unit. Otherwise we grab the DIE from the DWARF file.
//----------------------------------------------------------------------
DWARFDIE
DWARFUnit::GetDIE(dw_offset_t die_offset) {
  if (die_offset != DW_INVALID_OFFSET) {
    if (GetDwoSymbolFile())
      return GetDwoSymbolFile()->GetCompileUnit()->GetDIE(die_offset);

    if (ContainsDIEOffset(die_offset)) {
      ExtractDIEsIfNeeded(false);
      DWARFDebugInfoEntry::iterator end = m_die_array.end();
      DWARFDebugInfoEntry::iterator pos =
          lower_bound(m_die_array.begin(), end, die_offset, CompareDIEOffset);
      if (pos != end) {
        if (die_offset == (*pos).GetOffset())
          return DWARFDIE(this, &(*pos));
      }
    } else {
      // Don't specify the compile unit offset as we don't know it because the
      // DIE belongs to
      // a different compile unit in the same symbol file.
      return m_dwarf->DebugInfo()->GetDIEForDIEOffset(die_offset);
    }
  }
  return DWARFDIE(); // Not found
}

uint8_t DWARFUnit::GetAddressByteSize(const DWARFUnit *cu) {
  if (cu)
    return cu->GetAddressByteSize();
  return DWARFUnit::GetDefaultAddressSize();
}

bool DWARFUnit::IsDWARF64(const DWARFUnit *cu) {
  if (cu)
    return cu->IsDWARF64();
  return false;
}

uint8_t DWARFUnit::GetDefaultAddressSize() { return 4; }

void *DWARFUnit::GetUserData() const { return m_user_data; }

void DWARFUnit::SetUserData(void *d) {
  m_user_data = d;
  if (m_dwo_symbol_file)
    m_dwo_symbol_file->GetCompileUnit()->SetUserData(d);
}

bool DWARFUnit::Supports_DW_AT_APPLE_objc_complete_type() {
  if (GetProducer() == eProducerLLVMGCC)
    return false;
  return true;
}

bool DWARFUnit::DW_AT_decl_file_attributes_are_invalid() {
  // llvm-gcc makes completely invalid decl file attributes and won't ever be
  // fixed, so we need to know to ignore these.
  return GetProducer() == eProducerLLVMGCC;
}

bool DWARFUnit::Supports_unnamed_objc_bitfields() {
  if (GetProducer() == eProducerClang) {
    const uint32_t major_version = GetProducerVersionMajor();
    if (major_version > 425 ||
        (major_version == 425 && GetProducerVersionUpdate() >= 13))
      return true;
    else
      return false;
  }
  return true; // Assume all other compilers didn't have incorrect ObjC bitfield
               // info
}

SymbolFileDWARF *DWARFUnit::GetSymbolFileDWARF() const { return m_dwarf; }

void DWARFUnit::ParseProducerInfo() {
  m_producer_version_major = UINT32_MAX;
  m_producer_version_minor = UINT32_MAX;
  m_producer_version_update = UINT32_MAX;

  const DWARFDebugInfoEntry *die = GetUnitDIEPtrOnly();
  if (die) {

    const char *producer_cstr =
        die->GetAttributeValueAsString(m_dwarf, this, DW_AT_producer, NULL);
    if (producer_cstr) {
      RegularExpression llvm_gcc_regex(
          llvm::StringRef("^4\\.[012]\\.[01] \\(Based on Apple "
                          "Inc\\. build [0-9]+\\) \\(LLVM build "
                          "[\\.0-9]+\\)$"));
      if (llvm_gcc_regex.Execute(llvm::StringRef(producer_cstr))) {
        m_producer = eProducerLLVMGCC;
      } else if (strstr(producer_cstr, "clang")) {
        static RegularExpression g_clang_version_regex(
            llvm::StringRef("clang-([0-9]+)\\.([0-9]+)\\.([0-9]+)"));
        RegularExpression::Match regex_match(3);
        if (g_clang_version_regex.Execute(llvm::StringRef(producer_cstr),
                                          &regex_match)) {
          std::string str;
          if (regex_match.GetMatchAtIndex(producer_cstr, 1, str))
            m_producer_version_major =
                StringConvert::ToUInt32(str.c_str(), UINT32_MAX, 10);
          if (regex_match.GetMatchAtIndex(producer_cstr, 2, str))
            m_producer_version_minor =
                StringConvert::ToUInt32(str.c_str(), UINT32_MAX, 10);
          if (regex_match.GetMatchAtIndex(producer_cstr, 3, str))
            m_producer_version_update =
                StringConvert::ToUInt32(str.c_str(), UINT32_MAX, 10);
        }
        m_producer = eProducerClang;
      } else if (strstr(producer_cstr, "GNU"))
        m_producer = eProducerGCC;
    }
  }
  if (m_producer == eProducerInvalid)
    m_producer = eProcucerOther;
}

DWARFProducer DWARFUnit::GetProducer() {
  if (m_producer == eProducerInvalid)
    ParseProducerInfo();
  return m_producer;
}

uint32_t DWARFUnit::GetProducerVersionMajor() {
  if (m_producer_version_major == 0)
    ParseProducerInfo();
  return m_producer_version_major;
}

uint32_t DWARFUnit::GetProducerVersionMinor() {
  if (m_producer_version_minor == 0)
    ParseProducerInfo();
  return m_producer_version_minor;
}

uint32_t DWARFUnit::GetProducerVersionUpdate() {
  if (m_producer_version_update == 0)
    ParseProducerInfo();
  return m_producer_version_update;
}
LanguageType DWARFUnit::LanguageTypeFromDWARF(uint64_t val) {
  // Note: user languages between lo_user and hi_user must be handled
  // explicitly here.
  switch (val) {
  case DW_LANG_Mips_Assembler:
    return eLanguageTypeMipsAssembler;
  case DW_LANG_GOOGLE_RenderScript:
    return eLanguageTypeExtRenderScript;
  default:
    return static_cast<LanguageType>(val);
  }
}

LanguageType DWARFUnit::GetLanguageType() {
  if (m_language_type != eLanguageTypeUnknown)
    return m_language_type;

  const DWARFDebugInfoEntry *die = GetUnitDIEPtrOnly();
  if (die)
    m_language_type = LanguageTypeFromDWARF(
        die->GetAttributeValueAsUnsigned(m_dwarf, this, DW_AT_language, 0));
  return m_language_type;
}

bool DWARFUnit::GetIsOptimized() {
  if (m_is_optimized == eLazyBoolCalculate) {
    const DWARFDebugInfoEntry *die = GetUnitDIEPtrOnly();
    if (die) {
      m_is_optimized = eLazyBoolNo;
      if (die->GetAttributeValueAsUnsigned(m_dwarf, this, DW_AT_APPLE_optimized,
                                           0) == 1) {
        m_is_optimized = eLazyBoolYes;
      }
    }
  }
  return m_is_optimized == eLazyBoolYes;
}

SymbolFileDWARFDwo *DWARFUnit::GetDwoSymbolFile() const {
  return m_dwo_symbol_file.get();
}

dw_offset_t DWARFUnit::GetBaseObjOffset() const { return m_base_obj_offset; }

void DWARFUnit::Index(NameToDIE &func_basenames, NameToDIE &func_fullnames,
                      NameToDIE &func_methods, NameToDIE &func_selectors,
                      NameToDIE &objc_class_selectors, NameToDIE &globals,
                      NameToDIE &types, NameToDIE &namespaces) {
  assert(!m_dwarf->GetBaseCompileUnit() &&
         "DWARFUnit associated with .dwo or .dwp "
         "should not be indexed directly");

  Log *log(LogChannelDWARF::GetLogIfAll(DWARF_LOG_LOOKUPS));

  if (log) {
    m_dwarf->GetObjectFile()->GetModule()->LogMessage(
        log, "DWARFUnit::Index() for compile unit at .debug_info[0x%8.8x]",
        GetOffset());
  }

  const LanguageType cu_language = GetLanguageType();
  DWARFFormValue::FixedFormSizes fixed_form_sizes =
      DWARFFormValue::GetFixedFormSizesForAddressSize(GetAddressByteSize(),
                                                      IsDWARF64());

  IndexPrivate(this, cu_language, fixed_form_sizes, GetOffset(), func_basenames,
               func_fullnames, func_methods, func_selectors,
               objc_class_selectors, globals, types, namespaces);

  SymbolFileDWARFDwo *dwo_symbol_file = GetDwoSymbolFile();
  if (dwo_symbol_file) {
    IndexPrivate(
        dwo_symbol_file->GetCompileUnit(), cu_language, fixed_form_sizes,
        GetOffset(), func_basenames, func_fullnames, func_methods,
        func_selectors, objc_class_selectors, globals, types, namespaces);
  }
}

void DWARFUnit::IndexPrivate(
    DWARFUnit *dwarf_cu, const LanguageType cu_language,
    const DWARFFormValue::FixedFormSizes &fixed_form_sizes,
    const dw_offset_t cu_offset, NameToDIE &func_basenames,
    NameToDIE &func_fullnames, NameToDIE &func_methods,
    NameToDIE &func_selectors, NameToDIE &objc_class_selectors,
    NameToDIE &globals, NameToDIE &types, NameToDIE &namespaces) {
  DWARFDebugInfoEntry::const_iterator pos;
  DWARFDebugInfoEntry::const_iterator begin = dwarf_cu->m_die_array.begin();
  DWARFDebugInfoEntry::const_iterator end = dwarf_cu->m_die_array.end();
  for (pos = begin; pos != end; ++pos) {
    const DWARFDebugInfoEntry &die = *pos;

    const dw_tag_t tag = die.Tag();

    switch (tag) {
    case DW_TAG_array_type:
    case DW_TAG_base_type:
    case DW_TAG_class_type:
    case DW_TAG_constant:
    case DW_TAG_enumeration_type:
    case DW_TAG_inlined_subroutine:
    case DW_TAG_namespace:
    case DW_TAG_string_type:
    case DW_TAG_structure_type:
    case DW_TAG_subprogram:
    case DW_TAG_subroutine_type:
    case DW_TAG_typedef:
    case DW_TAG_union_type:
    case DW_TAG_unspecified_type:
    case DW_TAG_variable:
      break;

    default:
      continue;
    }

    DWARFAttributes attributes;
    const char *name = NULL;
    const char *mangled_cstr = NULL;
    bool is_declaration = false;
    // bool is_artificial = false;
    bool has_address = false;
    bool has_location_or_const_value = false;
    bool is_global_or_static_variable = false;

    DWARFFormValue specification_die_form;
    const size_t num_attributes =
        die.GetAttributes(dwarf_cu, fixed_form_sizes, attributes);
    if (num_attributes > 0) {
      for (uint32_t i = 0; i < num_attributes; ++i) {
        dw_attr_t attr = attributes.AttributeAtIndex(i);
        DWARFFormValue form_value;
        switch (attr) {
        case DW_AT_name:
          if (attributes.ExtractFormValueAtIndex(i, form_value))
            name = form_value.AsCString();
          break;

        case DW_AT_declaration:
          if (attributes.ExtractFormValueAtIndex(i, form_value))
            is_declaration = form_value.Unsigned() != 0;
          break;

        //                case DW_AT_artificial:
        //                    if (attributes.ExtractFormValueAtIndex(i,
        //                    form_value))
        //                        is_artificial = form_value.Unsigned() != 0;
        //                    break;

        case DW_AT_MIPS_linkage_name:
        case DW_AT_linkage_name:
          if (attributes.ExtractFormValueAtIndex(i, form_value))
            mangled_cstr = form_value.AsCString();
          break;

        case DW_AT_low_pc:
        case DW_AT_high_pc:
        case DW_AT_ranges:
          has_address = true;
          break;

        case DW_AT_entry_pc:
          has_address = true;
          break;

        case DW_AT_location:
        case DW_AT_const_value:
          has_location_or_const_value = true;
          if (tag == DW_TAG_variable) {
            const DWARFDebugInfoEntry *parent_die = die.GetParent();
            while (parent_die != NULL) {
              switch (parent_die->Tag()) {
              case DW_TAG_subprogram:
              case DW_TAG_lexical_block:
              case DW_TAG_inlined_subroutine:
                // Even if this is a function level static, we don't add it. We
                // could theoretically add these if we wanted to by
                // introspecting into the DW_AT_location and seeing if the
                // location describes a hard coded address, but we don't want
                // the performance penalty of that right now.
                is_global_or_static_variable = false;
                // if (attributes.ExtractFormValueAtIndex(dwarf, i,
                //                                        form_value)) {
                //   // If we have valid block data, then we have location
                //   // expression bytesthat are fixed (not a location list).
                //   const uint8_t *block_data = form_value.BlockData();
                //   if (block_data) {
                //     uint32_t block_length = form_value.Unsigned();
                //     if (block_length == 1 +
                //     attributes.CompileUnitAtIndex(i)->GetAddressByteSize()) {
                //       if (block_data[0] == DW_OP_addr)
                //         add_die = true;
                //     }
                //   }
                // }
                parent_die = NULL; // Terminate the while loop.
                break;

              case DW_TAG_compile_unit:
              case DW_TAG_partial_unit:
                is_global_or_static_variable = true;
                parent_die = NULL; // Terminate the while loop.
                break;

              default:
                parent_die =
                    parent_die->GetParent(); // Keep going in the while loop.
                break;
              }
            }
          }
          break;

        case DW_AT_specification:
          if (attributes.ExtractFormValueAtIndex(i, form_value))
            specification_die_form = form_value;
          break;
        }
      }
    }

    switch (tag) {
    case DW_TAG_subprogram:
      if (has_address) {
        if (name) {
          ObjCLanguage::MethodName objc_method(name, true);
          if (objc_method.IsValid(true)) {
            ConstString objc_class_name_with_category(
                objc_method.GetClassNameWithCategory());
            ConstString objc_selector_name(objc_method.GetSelector());
            ConstString objc_fullname_no_category_name(
                objc_method.GetFullNameWithoutCategory(true));
            ConstString objc_class_name_no_category(objc_method.GetClassName());
            func_fullnames.Insert(ConstString(name),
                                  DIERef(cu_offset, die.GetOffset()));
            if (objc_class_name_with_category)
              objc_class_selectors.Insert(objc_class_name_with_category,
                                          DIERef(cu_offset, die.GetOffset()));
            if (objc_class_name_no_category &&
                objc_class_name_no_category != objc_class_name_with_category)
              objc_class_selectors.Insert(objc_class_name_no_category,
                                          DIERef(cu_offset, die.GetOffset()));
            if (objc_selector_name)
              func_selectors.Insert(objc_selector_name,
                                    DIERef(cu_offset, die.GetOffset()));
            if (objc_fullname_no_category_name)
              func_fullnames.Insert(objc_fullname_no_category_name,
                                    DIERef(cu_offset, die.GetOffset()));
          }
          // If we have a mangled name, then the DW_AT_name attribute is
          // usually the method name without the class or any parameters
          const DWARFDebugInfoEntry *parent = die.GetParent();
          bool is_method = false;
          if (parent) {
            dw_tag_t parent_tag = parent->Tag();
            if (parent_tag == DW_TAG_class_type ||
                parent_tag == DW_TAG_structure_type) {
              is_method = true;
            } else {
              if (specification_die_form.IsValid()) {
                DWARFDIE specification_die =
                    dwarf_cu->GetSymbolFileDWARF()->DebugInfo()->GetDIE(
                        DIERef(specification_die_form));
                if (specification_die.GetParent().IsStructOrClass())
                  is_method = true;
              }
            }
          }

          if (is_method)
            func_methods.Insert(ConstString(name),
                                DIERef(cu_offset, die.GetOffset()));
          else
            func_basenames.Insert(ConstString(name),
                                  DIERef(cu_offset, die.GetOffset()));

          if (!is_method && !mangled_cstr && !objc_method.IsValid(true))
            func_fullnames.Insert(ConstString(name),
                                  DIERef(cu_offset, die.GetOffset()));
        }
        if (mangled_cstr) {
          // Make sure our mangled name isn't the same string table entry as
          // our name. If it starts with '_', then it is ok, else compare the
          // string to make sure it isn't the same and we don't end up with
          // duplicate entries
          if (name && name != mangled_cstr &&
              ((mangled_cstr[0] == '_') ||
               (::strcmp(name, mangled_cstr) != 0))) {
            func_fullnames.Insert(ConstString(mangled_cstr),
                                  DIERef(cu_offset, die.GetOffset()));
          }
        }
      }
      break;

    case DW_TAG_inlined_subroutine:
      if (has_address) {
        if (name)
          func_basenames.Insert(ConstString(name),
                                DIERef(cu_offset, die.GetOffset()));
        if (mangled_cstr) {
          // Make sure our mangled name isn't the same string table entry as
          // our name. If it starts with '_', then it is ok, else compare the
          // string to make sure it isn't the same and we don't end up with
          // duplicate entries
          if (name && name != mangled_cstr &&
              ((mangled_cstr[0] == '_') ||
               (::strcmp(name, mangled_cstr) != 0))) {
            func_fullnames.Insert(ConstString(mangled_cstr),
                                  DIERef(cu_offset, die.GetOffset()));
          }
        } else
          func_fullnames.Insert(ConstString(name),
                                DIERef(cu_offset, die.GetOffset()));
      }
      break;

    case DW_TAG_array_type:
    case DW_TAG_base_type:
    case DW_TAG_class_type:
    case DW_TAG_constant:
    case DW_TAG_enumeration_type:
    case DW_TAG_string_type:
    case DW_TAG_structure_type:
    case DW_TAG_subroutine_type:
    case DW_TAG_typedef:
    case DW_TAG_union_type:
    case DW_TAG_unspecified_type:
      if (name && !is_declaration)
        types.Insert(ConstString(name), DIERef(cu_offset, die.GetOffset()));
      if (mangled_cstr && !is_declaration)
        types.Insert(ConstString(mangled_cstr),
                     DIERef(cu_offset, die.GetOffset()));
      break;

    case DW_TAG_namespace:
      if (name)
        namespaces.Insert(ConstString(name),
                          DIERef(cu_offset, die.GetOffset()));
      break;

    case DW_TAG_variable:
      if (name && has_location_or_const_value && is_global_or_static_variable) {
        globals.Insert(ConstString(name), DIERef(cu_offset, die.GetOffset()));
        // Be sure to include variables by their mangled and demangled names if
        // they have any since a variable can have a basename "i", a mangled
        // named "_ZN12_GLOBAL__N_11iE" and a demangled mangled name
        // "(anonymous namespace)::i"...

        // Make sure our mangled name isn't the same string table entry as our
        // name. If it starts with '_', then it is ok, else compare the string
        // to make sure it isn't the same and we don't end up with duplicate
        // entries
        if (mangled_cstr && name != mangled_cstr &&
            ((mangled_cstr[0] == '_') || (::strcmp(name, mangled_cstr) != 0))) {
          Mangled mangled(ConstString(mangled_cstr), true);
          globals.Insert(mangled.GetMangledName(),
                         DIERef(cu_offset, die.GetOffset()));
          ConstString demangled = mangled.GetDemangledName(cu_language);
          if (demangled)
            globals.Insert(demangled, DIERef(cu_offset, die.GetOffset()));
        }
      }
      break;

    default:
      continue;
    }
  }
}

const DWARFDebugAranges &DWARFUnit::GetFunctionAranges() {
  if (m_func_aranges_ap.get() == NULL) {
    m_func_aranges_ap.reset(new DWARFDebugAranges());
    Log *log(LogChannelDWARF::GetLogIfAll(DWARF_LOG_DEBUG_ARANGES));

    if (log) {
      m_dwarf->GetObjectFile()->GetModule()->LogMessage(
          log,
          "DWARFUnit::GetFunctionAranges() for compile unit at "
          ".debug_info[0x%8.8x]",
          GetOffset());
    }
    const DWARFDebugInfoEntry *die = DIEPtr();
    if (die)
      die->BuildFunctionAddressRangeTable(m_dwarf, this,
                                          m_func_aranges_ap.get());

    if (m_dwo_symbol_file) {
      DWARFUnit *dwo_cu = m_dwo_symbol_file->GetCompileUnit();
      const DWARFDebugInfoEntry *dwo_die = dwo_cu->DIEPtr();
      if (dwo_die)
        dwo_die->BuildFunctionAddressRangeTable(m_dwo_symbol_file.get(), dwo_cu,
                                                m_func_aranges_ap.get());
    }

    const bool minimize = false;
    m_func_aranges_ap->Sort(minimize);
  }
  return *m_func_aranges_ap.get();
}

