; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -o - %s | FileCheck %s
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -o - %s | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @vector_add_by_value(<4 x i32> %lhs, <4 x i32>%rhs) {
; CHECK-LABEL: vector_add_by_value:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    @APP
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    @NO_APP
; CHECK-NEXT:    bx lr
  %result = tail call <4 x i32> asm "vadd.i32 $0,$1,$2", "=t,t,t"(<4 x i32> %lhs, <4 x i32> %rhs)
  ret <4 x i32> %result
}

define void @vector_add_by_reference(<4 x i32>* %resultp, <4 x i32>* %lhsp, <4 x i32>* %rhsp) {
; CHECK-LABEL: vector_add_by_reference:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vldrw.u32 q1, [r2]
; CHECK-NEXT:    @APP
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    @NO_APP
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
  %lhs = load <4 x i32>, <4 x i32>* %lhsp, align 16
  %rhs = load <4 x i32>, <4 x i32>* %rhsp, align 16
  %result = tail call <4 x i32> asm "vadd.i32 $0,$1,$2", "=t,t,t"(<4 x i32> %lhs, <4 x i32> %rhs)
  store <4 x i32> %result, <4 x i32>* %resultp, align 16
  ret void
}
