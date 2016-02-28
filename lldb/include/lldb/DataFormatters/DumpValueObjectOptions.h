//===-- DumpValueObjectOptions.h --------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef lldb_DumpValueObjectOptions_h_
#define lldb_DumpValueObjectOptions_h_

// C Includes
// C++ Includes
#include <string>

// Other libraries and framework includes
// Project includes
#include "lldb/lldb-private.h"
#include "lldb/lldb-public.h"

#include <functional>
#include <string>

namespace lldb_private {
    
class DumpValueObjectOptions
{
public:
    struct PointerDepth
    {
        enum class Mode
        {
            Always,
            Formatters,
            Default,
            Never
        } m_mode;
        uint32_t m_count;
        
        PointerDepth
        operator --() const
        {
            if (m_count > 0)
                return PointerDepth {m_mode,m_count-1};
            return PointerDepth {m_mode,m_count};
        }
        
        bool
        CanAllowExpansion () const;
        
        bool
        CanAllowExpansion (bool is_root,
                           TypeSummaryImpl* entry,
                           ValueObject *valobj,
                           const std::string& summary);
    };
    
    typedef std::function<bool(ConstString,
                               ConstString,
                               const DumpValueObjectOptions &,
                               Stream&)> DeclPrintingHelper;
    
    static const DumpValueObjectOptions
    DefaultOptions()
    {
        static DumpValueObjectOptions g_default_options;
        
        return g_default_options;
    }
    
    DumpValueObjectOptions();
    
    DumpValueObjectOptions (const DumpValueObjectOptions& rhs) = default;
    
    DumpValueObjectOptions (ValueObject& valobj);
    
    DumpValueObjectOptions&
    SetMaximumPointerDepth(PointerDepth depth = {PointerDepth::Mode::Never,0});
    
    DumpValueObjectOptions&
    SetMaximumDepth(uint32_t depth = 0);
    
    DumpValueObjectOptions&
    SetDeclPrintingHelper(DeclPrintingHelper helper);
    
    DumpValueObjectOptions&
    SetShowTypes(bool show = false);
    
    DumpValueObjectOptions&
    SetShowLocation(bool show = false);
    
    DumpValueObjectOptions&
    SetUseObjectiveC(bool use = false);
    
    DumpValueObjectOptions&
    SetShowSummary(bool show = true);
    
    DumpValueObjectOptions&
    SetUseDynamicType(lldb::DynamicValueType dyn = lldb::eNoDynamicValues);
    
    DumpValueObjectOptions&
    SetUseSyntheticValue(bool use_synthetic = true);
    
    DumpValueObjectOptions&
    SetScopeChecked(bool check = true);
    
    DumpValueObjectOptions&
    SetFlatOutput(bool flat = false);
    
    DumpValueObjectOptions&
    SetOmitSummaryDepth(uint32_t depth = 0);
    
    DumpValueObjectOptions&
    SetIgnoreCap(bool ignore = false);
    
    DumpValueObjectOptions&
    SetRawDisplay();
    
    DumpValueObjectOptions&
    SetFormat (lldb::Format format = lldb::eFormatDefault);
    
    DumpValueObjectOptions&
    SetSummary (lldb::TypeSummaryImplSP summary = lldb::TypeSummaryImplSP());
    
    DumpValueObjectOptions&
    SetRootValueObjectName(const char* name = nullptr);
    
    DumpValueObjectOptions&
    SetHideRootType (bool hide_root_type = false);
    
    DumpValueObjectOptions&
    SetHideName (bool hide_name = false);
    
    DumpValueObjectOptions&
    SetHideValue (bool hide_value = false);
    
    DumpValueObjectOptions&
    SetHidePointerValue (bool hide = false);
    
    DumpValueObjectOptions&
    SetVariableFormatDisplayLanguage (lldb::LanguageType lang = lldb::eLanguageTypeUnknown);
    
    DumpValueObjectOptions&
    SetRunValidator (bool run = true);
    
    DumpValueObjectOptions&
    SetUseTypeDisplayName (bool dis = false);

    DumpValueObjectOptions&
    SetAllowOnelinerMode (bool oneliner = false);    

    uint32_t m_max_depth = UINT32_MAX;
    lldb::DynamicValueType m_use_dynamic = lldb::eNoDynamicValues;
    uint32_t m_omit_summary_depth = 0;
    lldb::Format m_format = lldb::eFormatDefault;
    lldb::TypeSummaryImplSP m_summary_sp;
    std::string m_root_valobj_name;
    lldb::LanguageType m_varformat_language = lldb::eLanguageTypeUnknown;
    PointerDepth m_max_ptr_depth;
    DeclPrintingHelper m_decl_printing_helper;
    bool m_use_synthetic : 1;
    bool m_scope_already_checked : 1;
    bool m_flat_output : 1;
    bool m_ignore_cap : 1;
    bool m_show_types : 1;
    bool m_show_location : 1;
    bool m_use_objc : 1;
    bool m_hide_root_type : 1;
    bool m_hide_name : 1;
    bool m_hide_value : 1;
    bool m_run_validator : 1;
    bool m_use_type_display_name : 1;
    bool m_allow_oneliner_mode : 1;
    bool m_hide_pointer_value : 1;
};

} // namespace lldb_private

#endif // lldb_DumpValueObjectOptions_h_
