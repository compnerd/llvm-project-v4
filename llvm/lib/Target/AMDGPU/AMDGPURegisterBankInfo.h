//===- AMDGPURegisterBankInfo -----------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H

#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

#define GET_REGBANK_DECLARATIONS
#include "AMDGPUGenRegisterBank.inc"
#undef GET_REGBANK_DECLARATIONS

namespace llvm {

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

  /// See RegisterBankInfo::applyMapping.
  void applyMappingImpl(const OperandsMapper &OpdMapper) const override;

  const RegisterBankInfo::InstructionMapping &
  getInstrMappingForLoad(const MachineInstr &MI) const;

  unsigned getRegBankID(unsigned Reg, const MachineRegisterInfo &MRI,
                        const TargetRegisterInfo &TRI,
                        unsigned Default = AMDGPU::VGPRRegBankID) const;

  bool isSALUMapping(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingSOP(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingVOP(const MachineInstr &MI) const;
public:
  AMDGPURegisterBankInfo(const TargetRegisterInfo &TRI);

  unsigned copyCost(const RegisterBank &A, const RegisterBank &B,
                    unsigned Size) const override;

  const RegisterBank &
  getRegBankFromRegClass(const TargetRegisterClass &RC) const override;

  InstructionMappings
  getInstrAlternativeMappings(const MachineInstr &MI) const override;

  const InstructionMapping &
  getInstrMapping(const MachineInstr &MI) const override;
};
} // End llvm namespace.
#endif
