//===----------------------------------------------------------------------===//
// Instruction Selector Subtarget Control
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// This file defines a pass used to change the subtarget for the
// Mips Instruction selector.
//
//===----------------------------------------------------------------------===//

#include "Mips.h"
#include "MipsTargetMachine.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mips-isel"

namespace {
  class MipsModuleDAGToDAGISel : public MachineFunctionPass {
  public:
    static char ID;

    MipsModuleDAGToDAGISel() : MachineFunctionPass(ID) {}

    // Pass Name
    StringRef getPassName() const override {
      return "MIPS DAG->DAG Pattern Instruction Selection";
    }

    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.addRequired<TargetPassConfig>();
      MachineFunctionPass::getAnalysisUsage(AU);
    }

    bool runOnMachineFunction(MachineFunction &MF) override;
  };

  char MipsModuleDAGToDAGISel::ID = 0;
}

bool MipsModuleDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
  DEBUG(errs() << "In MipsModuleDAGToDAGISel::runMachineFunction\n");
  auto &TPC = getAnalysis<TargetPassConfig>();
  auto &TM = TPC.getTM<MipsTargetMachine>();
  TM.resetSubtarget(&MF);
  return false;
}

llvm::FunctionPass *llvm::createMipsModuleISelDagPass() {
  return new MipsModuleDAGToDAGISel();
}
