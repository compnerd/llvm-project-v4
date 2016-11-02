//===-- ExpressionOpts.h ----------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_RENDERSCRIPT_EXPROPTS_H
#define LLDB_RENDERSCRIPT_EXPROPTS_H

// C Includes
// C++ Includes
// Other libraries and framework includes
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

// Project includes
#include "lldb/Target/LanguageRuntime.h"
#include "lldb/Target/Process.h"
#include "lldb/lldb-private.h"

#include "RenderScriptRuntime.h"
#include "RenderScriptx86ABIFixups.h"

// RenderScriptRuntimeModulePass is a simple llvm::ModulesPass that is used
// during expression evaluation to apply
// RenderScript-specific fixes for expression evaluation.
// In particular this is used to make expression IR conformant with the ABI
// generated by the slang frontend. This
// ModulePass is executed in ClangExpressionParser::PrepareForExecution whenever
// an expression's DWARF language is
// eLanguageTypeExtRenderscript

class RenderScriptRuntimeModulePass : public llvm::ModulePass {
public:
  static char ID;
  RenderScriptRuntimeModulePass(const lldb_private::Process *process)
      : ModulePass(ID), m_process_ptr(process) {}

  bool runOnModule(llvm::Module &module);

private:
  const lldb_private::Process *m_process_ptr;
};

namespace lldb_private {
namespace lldb_renderscript {
struct RSIRPasses : public lldb_private::LLVMUserExpression::IRPasses {
  RSIRPasses(lldb_private::Process *process);

  ~RSIRPasses();
};
} // namespace lldb_renderscript
} // namespace lldb_private
#endif
