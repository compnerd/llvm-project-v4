//===-- SwiftOptional.cpp ---------------------------------------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "SwiftOptional.h"
#include "lldb/DataFormatters/DataVisualization.h"
#include "lldb/DataFormatters/TypeSummary.h"
#include "lldb/DataFormatters/ValueObjectPrinter.h"

using namespace lldb;
using namespace lldb_private;
using namespace lldb_private::formatters;
using namespace lldb_private::formatters::swift;

std::string
lldb_private::formatters::swift::SwiftOptionalSummaryProvider::GetDescription ()
{
    StreamString sstr;
    sstr.Printf ("`%s `%s%s%s%s%s%s%s", "Swift.Optional summary provider",
                 Cascades() ? "" : " (not cascading)",
                 " (may show children)",
                 !DoesPrintValue(nullptr) ? " (hide value)" : "",
                 IsOneLiner() ? " (one-line printout)" : "",
                 SkipsPointers() ? " (skip pointers)" : "",
                 SkipsReferences() ? " (skip references)" : "",
                 HideNames(nullptr) ? " (hide member names)" : "");
    return sstr.GetString();
}

// if this ValueObject is an Optional<T> with the Some(T) case selected,
// retrieve the value of the Some case..
static ValueObject*
ExtractSomeIfAny (ValueObject *optional,
                  lldb::DynamicValueType dynamic_value = lldb::eNoDynamicValues,
                  bool synthetic_value = false)
{
    if (!optional)
        return nullptr;
    
    static ConstString g_Some("Some");
    static ConstString g_None("None");
    
    ValueObjectSP non_synth_valobj = optional->GetNonSyntheticValue();
    if (!non_synth_valobj)
        return nullptr;
    
    ConstString value(non_synth_valobj->GetValueAsCString());
    
    if (!value || value == g_None)
        return nullptr;
    
    ValueObjectSP value_sp(non_synth_valobj->GetChildMemberWithName(g_Some, true));
    if (!value_sp)
        return nullptr;
    
    if (dynamic_value != lldb::eNoDynamicValues)
    {
        ValueObjectSP dyn_value_sp = value_sp->GetDynamicValue(dynamic_value);
        if (dyn_value_sp)
            value_sp = dyn_value_sp;
    }
    
    if (synthetic_value && value_sp->HasSyntheticValue())
        value_sp = value_sp->GetSyntheticValue();
    
    return value_sp.get();
}

static bool
SwiftOptional_SummaryProvider_Impl (ValueObject& valobj,
                                    Stream& stream,
                                    const TypeSummaryOptions& options)
{
    static ConstString g_Some("Some");
    static ConstString g_None("None");
    
    ValueObjectSP non_synth_valobj = valobj.GetNonSyntheticValue();
    if (!non_synth_valobj)
        return false;
    
    ConstString value(non_synth_valobj->GetValueAsCString());
    
    if (!value)
        return false;
    
    if (value == g_None)
    {
        stream.Printf("nil");
        return true;
    }
    
    ValueObjectSP value_sp(non_synth_valobj->GetChildMemberWithName(g_Some, true));
    if (!value_sp)
        return false;
    
    value_sp = value_sp->GetQualifiedRepresentationIfAvailable(lldb::eDynamicDontRunTarget, true);
    if (!value_sp)
        return false;
    
    const char* value_summary = value_sp->GetSummaryAsCString();
    
    if (value_summary)
        stream.Printf("%s",value_summary);
    else if (lldb_private::DataVisualization::ShouldPrintAsOneLiner(*value_sp.get()))
    {
        TypeSummaryImpl::Flags oneliner_flags;
        oneliner_flags.SetHideItemNames(false).SetCascades(true).SetDontShowChildren(false).SetDontShowValue(false).SetShowMembersOneLiner(true).SetSkipPointers(false).SetSkipReferences(false);
        StringSummaryFormat oneliner(oneliner_flags, "");
        std::string buffer;
        oneliner.FormatObject(value_sp.get(), buffer, options);
        stream.Printf("%s",buffer.c_str());
    }
    
    return true;
}

bool
lldb_private::formatters::swift::SwiftOptionalSummaryProvider::FormatObject (ValueObject *target_valobj_sp,
                                                                             std::string& dest,
                                                                             const TypeSummaryOptions& options)
{
    if (!target_valobj_sp)
        return false;
    
    StreamString stream;
    
    bool is_ok = SwiftOptional_SummaryProvider_Impl(*target_valobj_sp, stream, options);
    dest.assign(stream.GetString());
    
    return is_ok;
}

bool
lldb_private::formatters::swift::SwiftOptionalSummaryProvider::DoesPrintChildren (ValueObject* target_valobj) const
{
    if (!target_valobj)
        return false;
    
    ValueObject *some = ExtractSomeIfAny(target_valobj,target_valobj->GetDynamicValueType(),true);
    
    if (!some)
        return true;
    
    lldb_private::Flags some_flags(some->GetCompilerType().GetTypeInfo());
    
    if (some_flags.AllSet(eTypeIsSwift | eTypeInstanceIsPointer))
        return true;
    
    lldb::TypeSummaryImplSP summary_sp = some->GetSummaryFormat();
    
    if (!summary_sp)
    {
        if (lldb_private::DataVisualization::ShouldPrintAsOneLiner(*some))
            return false;
        else
            return (some->GetNumChildren() > 0);
    }
    else
        return (some->GetNumChildren() > 0) && (summary_sp->DoesPrintChildren(some));
}

bool
lldb_private::formatters::swift::SwiftOptionalSummaryProvider::DoesPrintValue (ValueObject* valobj) const
{
    return false;
}

lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::SwiftOptionalSyntheticFrontEnd (lldb::ValueObjectSP valobj_sp) :
SyntheticChildrenFrontEnd(*valobj_sp.get()),
m_is_none(false),
m_children(false),
m_some(nullptr)
{
}

bool
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::IsEmpty () const
{
    return (m_is_none == true || m_children == false || m_some == nullptr);
}

size_t
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::CalculateNumChildren ()
{
    if (IsEmpty())
        return 0;
    return m_some->GetNumChildren();
}

lldb::ValueObjectSP
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::GetChildAtIndex (size_t idx)
{
    if (IsEmpty())
        return nullptr;
    return m_some->GetChildAtIndex(idx, true);
}

bool
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::Update()
{
    m_some = nullptr;
    m_is_none = true;
    m_children = false;
    
    m_some = ExtractSomeIfAny(&m_backend,m_backend.GetDynamicValueType(),true);
    
    if (!m_some)
    {
        m_is_none = true;
        m_children = false;
        return false;
    }
    
    m_is_none = false;
    
    m_children = (m_some->GetNumChildren() > 0);
    
    return false;
}

bool
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::MightHaveChildren ()
{
    return IsEmpty() ? false : true;
}

size_t
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::GetIndexOfChildWithName (const ConstString &name)
{
    static ConstString g_Some("Some");
    
    if (IsEmpty())
        return UINT32_MAX;
    
    return m_some->GetIndexOfChildWithName(name);
}

lldb::ValueObjectSP
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEnd::GetSyntheticValue ()
{
    if (m_some && m_some->CanProvideValue())
        return m_some->GetSP();
    return nullptr;
}

SyntheticChildrenFrontEnd*
lldb_private::formatters::swift::SwiftOptionalSyntheticFrontEndCreator (CXXSyntheticChildren*, lldb::ValueObjectSP valobj_sp)
{
    if (!valobj_sp)
        return nullptr;
    return (new SwiftOptionalSyntheticFrontEnd(valobj_sp));
}

SyntheticChildrenFrontEnd*
lldb_private::formatters::swift::SwiftUncheckedOptionalSyntheticFrontEndCreator (CXXSyntheticChildren* cxx_synth, lldb::ValueObjectSP valobj_sp)
{
    if (!valobj_sp)
        return nullptr;
    return SwiftOptionalSyntheticFrontEndCreator(cxx_synth, valobj_sp);
}

