//===- MipsLegalizerInfo.cpp ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsLegalizerInfo.h"
#include "MipsTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"

using namespace llvm;

MipsLegalizerInfo::MipsLegalizerInfo(const MipsSubtarget &ST) {
  using namespace TargetOpcode;

  const LLT s1 = LLT::scalar(1);
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);
  const LLT p0 = LLT::pointer(0, 32);

  getActionDefinitionsBuilder({G_ADD, G_SUB, G_MUL})
      .legalFor({s32})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_UADDO, G_UADDE, G_USUBO, G_USUBE, G_UMULO})
      .lowerFor({{s32, s1}});

  getActionDefinitionsBuilder(G_UMULH)
      .legalFor({s32})
      .maxScalar(0, s32);

  getActionDefinitionsBuilder({G_LOAD, G_STORE})
      .legalForTypesWithMemDesc({{s32, p0, 8, 8},
                                 {s32, p0, 16, 8},
                                 {s32, p0, 32, 8},
                                 {s64, p0, 64, 8},
                                 {p0, p0, 32, 8}})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_IMPLICIT_DEF)
      .legalFor({s32, s64});

  getActionDefinitionsBuilder(G_UNMERGE_VALUES)
     .legalFor({{s32, s64}});

  getActionDefinitionsBuilder(G_MERGE_VALUES)
     .legalFor({{s64, s32}});

  getActionDefinitionsBuilder({G_ZEXTLOAD, G_SEXTLOAD})
      .legalForTypesWithMemDesc({{s32, p0, 8, 8},
                                 {s32, p0, 16, 8}})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_ZEXT, G_SEXT})
      .legalIf([](const LegalityQuery &Query) { return false; })
      .maxScalar(0, s32);

  getActionDefinitionsBuilder(G_TRUNC)
      .legalIf([](const LegalityQuery &Query) { return false; })
      .maxScalar(1, s32);

  getActionDefinitionsBuilder(G_SELECT)
      .legalForCartesianProduct({p0, s32, s64}, {s32})
      .minScalar(0, s32)
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_BRCOND)
      .legalFor({s32})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_BRJT)
      .legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_BRINDIRECT)
      .legalFor({p0});

  getActionDefinitionsBuilder(G_PHI)
      .legalFor({p0, s32, s64})
      .minScalar(0, s32);

  getActionDefinitionsBuilder({G_AND, G_OR, G_XOR})
      .legalFor({s32})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_SDIV, G_SREM, G_UREM, G_UDIV})
      .legalFor({s32})
      .minScalar(0, s32)
      .libcallFor({s64});

  getActionDefinitionsBuilder({G_SHL, G_ASHR, G_LSHR})
      .legalFor({{s32, s32}})
      .clampScalar(1, s32, s32)
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder(G_ICMP)
      .legalForCartesianProduct({s32}, {s32, p0})
      .clampScalar(1, s32, s32)
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_CONSTANT)
      .legalFor({s32})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_GEP, G_INTTOPTR})
      .legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_PTRTOINT)
      .legalFor({{s32, p0}});

  getActionDefinitionsBuilder(G_FRAME_INDEX)
      .legalFor({p0});

  getActionDefinitionsBuilder({G_GLOBAL_VALUE, G_JUMP_TABLE})
      .legalFor({p0});

  getActionDefinitionsBuilder(G_DYN_STACKALLOC)
      .lowerFor({{p0, s32}});

  getActionDefinitionsBuilder(G_VASTART)
     .legalFor({p0});

  // FP instructions
  getActionDefinitionsBuilder(G_FCONSTANT)
      .legalFor({s32, s64});

  getActionDefinitionsBuilder({G_FADD, G_FSUB, G_FMUL, G_FDIV, G_FABS, G_FSQRT})
      .legalFor({s32, s64});

  getActionDefinitionsBuilder(G_FCMP)
      .legalFor({{s32, s32}, {s32, s64}})
      .minScalar(0, s32);

  getActionDefinitionsBuilder({G_FCEIL, G_FFLOOR})
      .libcallFor({s32, s64});

  getActionDefinitionsBuilder(G_FPEXT)
      .legalFor({{s64, s32}});

  getActionDefinitionsBuilder(G_FPTRUNC)
      .legalFor({{s32, s64}});

  // FP to int conversion instructions
  getActionDefinitionsBuilder(G_FPTOSI)
      .legalForCartesianProduct({s32}, {s64, s32})
      .libcallForCartesianProduct({s64}, {s64, s32})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_FPTOUI)
      .libcallForCartesianProduct({s64}, {s64, s32})
      .lowerForCartesianProduct({s32}, {s64, s32})
      .minScalar(0, s32);

  // Int to FP conversion instructions
  getActionDefinitionsBuilder(G_SITOFP)
      .legalForCartesianProduct({s64, s32}, {s32})
      .libcallForCartesianProduct({s64, s32}, {s64})
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_UITOFP)
      .libcallForCartesianProduct({s64, s32}, {s64})
      .customForCartesianProduct({s64, s32}, {s32})
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_SEXT_INREG).lower();

  computeTables();
  verify(*ST.getInstrInfo());
}

bool MipsLegalizerInfo::legalizeCustom(MachineInstr &MI,
                                       MachineRegisterInfo &MRI,
                                       MachineIRBuilder &MIRBuilder,
                                       GISelChangeObserver &Observer) const {

  using namespace TargetOpcode;

  MIRBuilder.setInstr(MI);
  const MipsSubtarget &STI =
      static_cast<const MipsSubtarget &>(MIRBuilder.getMF().getSubtarget());
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);

  switch (MI.getOpcode()) {
  case G_UITOFP: {
    Register Dst = MI.getOperand(0).getReg();
    Register Src = MI.getOperand(1).getReg();
    LLT DstTy = MRI.getType(Dst);
    LLT SrcTy = MRI.getType(Src);

    if (SrcTy != s32)
      return false;
    if (DstTy != s32 && DstTy != s64)
      return false;

    // Let 0xABCDEFGH be given unsigned in MI.getOperand(1). First let's convert
    // unsigned to double. Mantissa has 52 bits so we use following trick:
    // First make floating point bit mask 0x43300000ABCDEFGH.
    // Mask represents 2^52 * 0x1.00000ABCDEFGH i.e. 0x100000ABCDEFGH.0 .
    // Next, subtract  2^52 * 0x1.0000000000000 i.e. 0x10000000000000.0 from it.
    // Done. Trunc double to float if needed.

    MachineInstrBuilder Bitcast = MIRBuilder.buildInstr(
        STI.isFP64bit() ? Mips::BuildPairF64_64 : Mips::BuildPairF64, {s64},
        {Src, MIRBuilder.buildConstant(s32, UINT32_C(0x43300000))});
    Bitcast.constrainAllUses(MIRBuilder.getTII(), *STI.getRegisterInfo(),
                             *STI.getRegBankInfo());

    MachineInstrBuilder TwoP52FP = MIRBuilder.buildFConstant(
        s64, BitsToDouble(UINT64_C(0x4330000000000000)));

    if (DstTy == s64)
      MIRBuilder.buildFSub(Dst, Bitcast, TwoP52FP);
    else {
      MachineInstrBuilder ResF64 = MIRBuilder.buildFSub(s64, Bitcast, TwoP52FP);
      MIRBuilder.buildFPTrunc(Dst, ResF64);
    }

    MI.eraseFromParent();
    break;
  }
  default:
    return false;
  }

  return true;
}

bool MipsLegalizerInfo::legalizeIntrinsic(MachineInstr &MI,
                                          MachineRegisterInfo &MRI,
                                          MachineIRBuilder &MIRBuilder) const {
  const MipsSubtarget &ST =
      static_cast<const MipsSubtarget &>(MI.getMF()->getSubtarget());
  const MipsInstrInfo &TII = *ST.getInstrInfo();
  const MipsRegisterInfo &TRI = *ST.getRegisterInfo();
  const RegisterBankInfo &RBI = *ST.getRegBankInfo();
  MIRBuilder.setInstr(MI);

  switch (MI.getIntrinsicID()) {
  case Intrinsic::memcpy:
  case Intrinsic::memset:
  case Intrinsic::memmove:
    if (createMemLibcall(MIRBuilder, MRI, MI) ==
        LegalizerHelper::UnableToLegalize)
      return false;
    MI.eraseFromParent();
    return true;
  case Intrinsic::trap: {
    MachineInstr *Trap = MIRBuilder.buildInstr(Mips::TRAP);
    MI.eraseFromParent();
    return constrainSelectedInstRegOperands(*Trap, TII, TRI, RBI);
  }
  case Intrinsic::vacopy: {
    Register Tmp = MRI.createGenericVirtualRegister(LLT::pointer(0, 32));
    MachinePointerInfo MPO;
    MIRBuilder.buildLoad(Tmp, MI.getOperand(2),
                         *MI.getMF()->getMachineMemOperand(
                             MPO, MachineMemOperand::MOLoad, 4, 4));
    MIRBuilder.buildStore(Tmp, MI.getOperand(1),
                          *MI.getMF()->getMachineMemOperand(
                              MPO, MachineMemOperand::MOStore, 4, 4));
    MI.eraseFromParent();
    return true;
  }
  default:
    break;
  }
  return true;
}
