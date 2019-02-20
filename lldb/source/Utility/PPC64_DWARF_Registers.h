//===-- PPC64_DWARF_Registers.h ---------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef utility_PPC64_DWARF_Registers_h_
#define utility_PPC64_DWARF_Registers_h_

#include "lldb/lldb-private.h"

namespace ppc64_dwarf {

enum {
  dwarf_r0_ppc64 = 0,
  dwarf_r1_ppc64,
  dwarf_r2_ppc64,
  dwarf_r3_ppc64,
  dwarf_r4_ppc64,
  dwarf_r5_ppc64,
  dwarf_r6_ppc64,
  dwarf_r7_ppc64,
  dwarf_r8_ppc64,
  dwarf_r9_ppc64,
  dwarf_r10_ppc64,
  dwarf_r11_ppc64,
  dwarf_r12_ppc64,
  dwarf_r13_ppc64,
  dwarf_r14_ppc64,
  dwarf_r15_ppc64,
  dwarf_r16_ppc64,
  dwarf_r17_ppc64,
  dwarf_r18_ppc64,
  dwarf_r19_ppc64,
  dwarf_r20_ppc64,
  dwarf_r21_ppc64,
  dwarf_r22_ppc64,
  dwarf_r23_ppc64,
  dwarf_r24_ppc64,
  dwarf_r25_ppc64,
  dwarf_r26_ppc64,
  dwarf_r27_ppc64,
  dwarf_r28_ppc64,
  dwarf_r29_ppc64,
  dwarf_r30_ppc64,
  dwarf_r31_ppc64,
  dwarf_f0_ppc64,
  dwarf_f1_ppc64,
  dwarf_f2_ppc64,
  dwarf_f3_ppc64,
  dwarf_f4_ppc64,
  dwarf_f5_ppc64,
  dwarf_f6_ppc64,
  dwarf_f7_ppc64,
  dwarf_f8_ppc64,
  dwarf_f9_ppc64,
  dwarf_f10_ppc64,
  dwarf_f11_ppc64,
  dwarf_f12_ppc64,
  dwarf_f13_ppc64,
  dwarf_f14_ppc64,
  dwarf_f15_ppc64,
  dwarf_f16_ppc64,
  dwarf_f17_ppc64,
  dwarf_f18_ppc64,
  dwarf_f19_ppc64,
  dwarf_f20_ppc64,
  dwarf_f21_ppc64,
  dwarf_f22_ppc64,
  dwarf_f23_ppc64,
  dwarf_f24_ppc64,
  dwarf_f25_ppc64,
  dwarf_f26_ppc64,
  dwarf_f27_ppc64,
  dwarf_f28_ppc64,
  dwarf_f29_ppc64,
  dwarf_f30_ppc64,
  dwarf_f31_ppc64,
  dwarf_cr_ppc64 = 64,
  dwarf_fpscr_ppc64,
  dwarf_msr_ppc64,
  dwarf_xer_ppc64 = 100,
  dwarf_lr_ppc64 = 108,
  dwarf_ctr_ppc64,
  dwarf_vscr_ppc64,
  dwarf_vrsave_ppc64 = 356,
  dwarf_pc_ppc64,
  dwarf_vr0_ppc64 = 1124,
  dwarf_vr1_ppc64,
  dwarf_vr2_ppc64,
  dwarf_vr3_ppc64,
  dwarf_vr4_ppc64,
  dwarf_vr5_ppc64,
  dwarf_vr6_ppc64,
  dwarf_vr7_ppc64,
  dwarf_vr8_ppc64,
  dwarf_vr9_ppc64,
  dwarf_vr10_ppc64,
  dwarf_vr11_ppc64,
  dwarf_vr12_ppc64,
  dwarf_vr13_ppc64,
  dwarf_vr14_ppc64,
  dwarf_vr15_ppc64,
  dwarf_vr16_ppc64,
  dwarf_vr17_ppc64,
  dwarf_vr18_ppc64,
  dwarf_vr19_ppc64,
  dwarf_vr20_ppc64,
  dwarf_vr21_ppc64,
  dwarf_vr22_ppc64,
  dwarf_vr23_ppc64,
  dwarf_vr24_ppc64,
  dwarf_vr25_ppc64,
  dwarf_vr26_ppc64,
  dwarf_vr27_ppc64,
  dwarf_vr28_ppc64,
  dwarf_vr29_ppc64,
  dwarf_vr30_ppc64,
  dwarf_vr31_ppc64,
};

} // namespace ppc64_dwarf

#endif // utility_PPC64_DWARF_Registers_h_
