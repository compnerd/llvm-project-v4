//===- AMDGPURegisterBankInfo -----------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H

#include "llvm/CodeGen/Register.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

#define GET_REGBANK_DECLARATIONS
#include "AMDGPUGenRegisterBank.inc"
#undef GET_REGBANK_DECLARATIONS

namespace llvm {

class LLT;
class MachineIRBuilder;
class SIRegisterInfo;
class TargetRegisterInfo;

/// This class provides the information for the target register banks.
class AMDGPUGenRegisterBankInfo : public RegisterBankInfo {

protected:

#define GET_TARGET_REGBANK_CLASS
#include "AMDGPUGenRegisterBank.inc"
};
class AMDGPURegisterBankInfo : public AMDGPUGenRegisterBankInfo {
  const SIRegisterInfo *TRI;

  void executeInWaterfallLoop(MachineInstr &MI,
                              MachineRegisterInfo &MRI,
                              ArrayRef<unsigned> OpIndices) const;

  void constrainOpWithReadfirstlane(MachineInstr &MI, MachineRegisterInfo &MRI,
                                    unsigned OpIdx) const;
  bool applyMappingWideLoad(MachineInstr &MI,
                            const AMDGPURegisterBankInfo::OperandsMapper &OpdMapper,
                            MachineRegisterInfo &MRI) const;

  /// See RegisterBankInfo::applyMapping.
  void applyMappingImpl(const OperandsMapper &OpdMapper) const override;

  const RegisterBankInfo::InstructionMapping &
  getInstrMappingForLoad(const MachineInstr &MI) const;

  unsigned getRegBankID(Register Reg, const MachineRegisterInfo &MRI,
                        const TargetRegisterInfo &TRI,
                        unsigned Default = AMDGPU::VGPRRegBankID) const;

  /// Split 64-bit value \p Reg into two 32-bit halves and populate them into \p
  /// Regs. This appropriately sets the regbank of the new registers.
  void split64BitValueForMapping(MachineIRBuilder &B,
                                 SmallVector<Register, 2> &Regs,
                                 LLT HalfTy,
                                 Register Reg) const;

  template <unsigned NumOps>
  struct OpRegBankEntry {
    int8_t RegBanks[NumOps];
    int16_t Cost;
  };

  template <unsigned NumOps>
  InstructionMappings
  addMappingFromTable(const MachineInstr &MI, const MachineRegisterInfo &MRI,
                      const std::array<unsigned, NumOps> RegSrcOpIdx,
                      ArrayRef<OpRegBankEntry<NumOps>> Table) const;

  RegisterBankInfo::InstructionMappings
  getInstrAlternativeMappingsIntrinsic(
      const MachineInstr &MI, const MachineRegisterInfo &MRI) const;

  RegisterBankInfo::InstructionMappings
  getInstrAlternativeMappingsIntrinsicWSideEffects(
      const MachineInstr &MI, const MachineRegisterInfo &MRI) const;

  bool isSALUMapping(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingSOP(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingVOP(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingAllVGPR(
    const MachineInstr &MI) const;
public:
  AMDGPURegisterBankInfo(const TargetRegisterInfo &TRI);

  unsigned copyCost(const RegisterBank &A, const RegisterBank &B,
                    unsigned Size) const override;

  unsigned getBreakDownCost(const ValueMapping &ValMapping,
                            const RegisterBank *CurBank = nullptr) const override;

  const RegisterBank &
  getRegBankFromRegClass(const TargetRegisterClass &RC) const override;

  InstructionMappings
  getInstrAlternativeMappings(const MachineInstr &MI) const override;

  const InstructionMapping &
  getInstrMapping(const MachineInstr &MI) const override;
};
} // End llvm namespace.
#endif
