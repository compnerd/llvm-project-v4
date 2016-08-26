//===-- CommandObjectArgs.cpp -----------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// C Includes
// C++ Includes
// Other libraries and framework includes
// Project includes
#include "CommandObjectArgs.h"
#include "lldb/Interpreter/Args.h"
#include "lldb/Core/Debugger.h"
#include "lldb/Core/Module.h"
#include "lldb/Core/Value.h"
#include "Plugins/ExpressionParser/Clang/ClangExpressionVariable.h"
#include "lldb/Host/Host.h"
#include "lldb/Interpreter/CommandInterpreter.h"
#include "lldb/Interpreter/CommandReturnObject.h"
#include "lldb/Symbol/ClangASTContext.h"
#include "lldb/Symbol/ObjectFile.h"
#include "lldb/Symbol/Variable.h"
#include "lldb/Target/ABI.h"
#include "lldb/Target/Process.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/Thread.h"
#include "lldb/Target/StackFrame.h"

using namespace lldb;
using namespace lldb_private;

// This command is a toy.  I'm just using it to have a way to construct the arguments to
// calling functions.
//

CommandObjectArgs::CommandOptions::CommandOptions (CommandInterpreter &interpreter) :
    Options()
{
    // Keep only one place to reset the values to their defaults
    OptionParsingStarting(nullptr);
}

CommandObjectArgs::CommandOptions::~CommandOptions() = default;

Error
CommandObjectArgs::CommandOptions::SetOptionValue(uint32_t option_idx,
                                                  const char *option_arg,
                                            ExecutionContext *execution_context)
{
    Error error;
    
    const int short_option = m_getopt_table[option_idx].val;
    error.SetErrorStringWithFormat("invalid short option character '%c'", short_option);
    
    return error;
}

void
CommandObjectArgs::CommandOptions::OptionParsingStarting(
                                            ExecutionContext *execution_context)
{
}

const OptionDefinition*
CommandObjectArgs::CommandOptions::GetDefinitions ()
{
    return g_option_table;
}

CommandObjectArgs::CommandObjectArgs (CommandInterpreter &interpreter) :
    CommandObjectParsed (interpreter,
                         "args",
                         "When stopped at the start of a function, reads function arguments of type (u?)int(8|16|32|64)_t, (void|char)*",
                         "args"),
    m_options (interpreter)
{
}

CommandObjectArgs::~CommandObjectArgs() = default;

Options *
CommandObjectArgs::GetOptions ()
{
    return &m_options;
}

bool
CommandObjectArgs::DoExecute (Args& args, CommandReturnObject &result)
{
    ConstString target_triple;

    Process *process = m_exe_ctx.GetProcessPtr();
    if (!process)
    {
        result.AppendError ("Args found no process.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    const ABI *abi = process->GetABI().get();
    if (!abi)
    {
        result.AppendError ("The current process has no ABI.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    const size_t num_args = args.GetArgumentCount ();
    size_t arg_index;
    
    if (!num_args)
    {
        result.AppendError ("args requires at least one argument");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    Thread *thread = m_exe_ctx.GetThreadPtr();
    
    if (!thread)
    {
        result.AppendError ("args found no thread.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
        
    lldb::StackFrameSP thread_cur_frame = thread->GetSelectedFrame ();
    if (!thread_cur_frame)
    {
        result.AppendError ("The current thread has no current frame.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    ModuleSP thread_module_sp (thread_cur_frame->GetFrameCodeAddress ().GetModule());
    if (!thread_module_sp)
    {
        result.AppendError ("The PC has no associated module.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }

    TypeSystem *type_system = thread_module_sp->GetTypeSystemForLanguage(eLanguageTypeC);
    if (type_system == nullptr)
    {
        result.AppendError ("Unable to create C type system.");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    ValueList value_list;
    
    for (arg_index = 0; arg_index < num_args; ++arg_index)
    {
        const char *arg_type_cstr = args.GetArgumentAtIndex(arg_index);
        Value value;
        value.SetValueType(Value::eValueTypeScalar);
        CompilerType compiler_type;
        
        char *int_pos;
        if ((int_pos = strstr (const_cast<char*>(arg_type_cstr), "int")))
        {
            Encoding encoding = eEncodingSint;
            
            int width = 0;
            
            if (int_pos > arg_type_cstr + 1)
            {
                result.AppendErrorWithFormat ("Invalid format: %s.\n", arg_type_cstr);
                result.SetStatus (eReturnStatusFailed);
                return false;
            }
            if (int_pos == arg_type_cstr + 1 && arg_type_cstr[0] != 'u')
            {
                result.AppendErrorWithFormat ("Invalid format: %s.\n", arg_type_cstr);
                result.SetStatus (eReturnStatusFailed);
                return false;
            }
            if (arg_type_cstr[0] == 'u')
            {
                encoding = eEncodingUint;
            }
            
            char *width_pos = int_pos + 3;
            
            if (!strcmp (width_pos, "8_t"))
                width = 8;
            else if (!strcmp (width_pos, "16_t"))
                width = 16;
            else if (!strcmp (width_pos, "32_t"))
                width = 32;
            else if (!strcmp (width_pos, "64_t"))
                width = 64;
            else
            {
                result.AppendErrorWithFormat ("Invalid format: %s.\n", arg_type_cstr);
                result.SetStatus (eReturnStatusFailed);
                return false;
            }
            compiler_type = type_system->GetBuiltinTypeForEncodingAndBitSize(encoding, width);
            
            if (!compiler_type.IsValid())
            {
                result.AppendErrorWithFormat ("Couldn't get Clang type for format %s (%s integer, width %d).\n",
                                             arg_type_cstr,
                                             (encoding == eEncodingSint ? "signed" : "unsigned"),
                                             width);
                
                result.SetStatus (eReturnStatusFailed);
                return false;
            }
        }
        else if (strchr (arg_type_cstr, '*'))
        {
            if (!strcmp (arg_type_cstr, "void*"))
                compiler_type = type_system->GetBasicTypeFromAST(eBasicTypeVoid).GetPointerType();
            else if (!strcmp (arg_type_cstr, "char*"))
                compiler_type = type_system->GetBasicTypeFromAST(eBasicTypeChar).GetPointerType();
            else
            {
                result.AppendErrorWithFormat ("Invalid format: %s.\n", arg_type_cstr);
                result.SetStatus (eReturnStatusFailed);
                return false;
            }
        }
        else 
        {
            result.AppendErrorWithFormat ("Invalid format: %s.\n", arg_type_cstr);
            result.SetStatus (eReturnStatusFailed);
            return false;
        }
                     
        value.SetCompilerType (compiler_type);
        value_list.PushValue(value);
    }
    
    if (!abi->GetArgumentValues (*thread, value_list))
    {
        result.AppendError ("Couldn't get argument values");
        result.SetStatus (eReturnStatusFailed);
        return false;
    }
    
    result.GetOutputStream ().Printf("Arguments : \n");

    for (arg_index = 0; arg_index < num_args; ++arg_index)
    {
        result.GetOutputStream ().Printf ("%" PRIu64 " (%s): ", (uint64_t)arg_index, args.GetArgumentAtIndex (arg_index));
        value_list.GetValueAtIndex (arg_index)->Dump (&result.GetOutputStream ());
        result.GetOutputStream ().Printf("\n");
    }
    
    return result.Succeeded();
}

OptionDefinition
CommandObjectArgs::CommandOptions::g_option_table[] =
{
    { LLDB_OPT_SET_1, false, "debug", 'g', OptionParser::eNoArgument, nullptr, nullptr, 0, eArgTypeNone, "Enable verbose debug logging of the expression parsing and evaluation."},
    { 0, false, nullptr, 0, 0, nullptr, nullptr, 0, eArgTypeNone, nullptr }
};
