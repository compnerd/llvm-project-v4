//===-- OptionValuePathMappings.h -------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_OptionValuePathMappings_h_
#define liblldb_OptionValuePathMappings_h_

#include "lldb/Interpreter/OptionValue.h"
#include "lldb/Target/PathMappingList.h"

namespace lldb_private {

class OptionValuePathMappings : public OptionValue {
public:
  OptionValuePathMappings(bool notify_changes)
      : OptionValue(), m_path_mappings(), m_notify_changes(notify_changes) {}

  ~OptionValuePathMappings() override {}

  //---------------------------------------------------------------------
  // Virtual subclass pure virtual overrides
  //---------------------------------------------------------------------

  OptionValue::Type GetType() const override { return eTypePathMap; }

  void DumpValue(const ExecutionContext *exe_ctx, Stream &strm,
                 uint32_t dump_mask) override;

  Status
  SetValueFromString(llvm::StringRef value,
                     VarSetOperationType op = eVarSetOperationAssign) override;
  Status
  SetValueFromString(const char *,
                     VarSetOperationType = eVarSetOperationAssign) = delete;

  bool Clear() override {
    m_path_mappings.Clear(m_notify_changes);
    m_value_was_set = false;
    return true;
  }

  lldb::OptionValueSP DeepCopy() const override;

  bool IsAggregateValue() const override { return true; }

  //---------------------------------------------------------------------
  // Subclass specific functions
  //---------------------------------------------------------------------

  PathMappingList &GetCurrentValue() { return m_path_mappings; }

  const PathMappingList &GetCurrentValue() const { return m_path_mappings; }

protected:
  PathMappingList m_path_mappings;
  bool m_notify_changes;
};

} // namespace lldb_private

#endif // liblldb_OptionValuePathMappings_h_
