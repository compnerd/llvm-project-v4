; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-BE

define void @load_load_add_store(<4 x i32> *%src1, <4 x i32> *%src2) {
; CHECK-LABEL: load_load_add_store:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vadd.i32 q0, q1, q0
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x i32>, <4 x i32>* %src1, align 4
  %l2 = load <4 x i32>, <4 x i32>* %src2, align 4
  %a = add <4 x i32> %l1, %l2
  store <4 x i32> %a, <4 x i32>* %src1, align 4
  ret void
}

define void @load_load_add_store_align1(<4 x i32> *%src1, <4 x i32> *%src2) {
; CHECK-LE-LABEL: load_load_add_store_align1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vldrb.u8 q0, [r1]
; CHECK-LE-NEXT:    vldrb.u8 q1, [r0]
; CHECK-LE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-LE-NEXT:    vstrb.8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_load_add_store_align1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vldrb.u8 q0, [r1]
; CHECK-BE-NEXT:    vldrb.u8 q1, [r0]
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    vrev32.8 q1, q1
; CHECK-BE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    vstrb.8 q0, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %l1 = load <4 x i32>, <4 x i32>* %src1, align 1
  %l2 = load <4 x i32>, <4 x i32>* %src2, align 1
  %a = add <4 x i32> %l1, %l2
  store <4 x i32> %a, <4 x i32>* %src1, align 1
  ret void
}

define arm_aapcs_vfpcc void @load_arg_add_store(<4 x i32> *%src1, <4 x i32> %src2) {
; CHECK-LE-LABEL: load_arg_add_store:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0]
; CHECK-LE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-LE-NEXT:    vstrw.32 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_arg_add_store:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vldrw.u32 q0, [r0]
; CHECK-BE-NEXT:    vadd.i32 q0, q0, q1
; CHECK-BE-NEXT:    vstrw.32 q0, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %l1 = load <4 x i32>, <4 x i32>* %src1, align 4
  %a = add <4 x i32> %l1, %src2
  store <4 x i32> %a, <4 x i32>* %src1, align 4
  ret void
}

define <4 x i32> @add_soft(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LE-LABEL: add_soft:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    mov r0, sp
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0]
; CHECK-LE-NEXT:    vadd.i32 q0, q0, q1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: add_soft:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    mov r0, sp
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vldrw.u32 q0, [r0]
; CHECK-BE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bx lr
entry:
  %0 = add <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <4 x i32> @add_hard(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LE-LABEL: add_hard:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vadd.i32 q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: add_hard:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vadd.i32 q1, q1, q2
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %0 = add <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define <4 x i32> @call_soft(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LE-LABEL: call_soft:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    .pad #16
; CHECK-LE-NEXT:    sub sp, #16
; CHECK-LE-NEXT:    add.w r12, sp, #24
; CHECK-LE-NEXT:    vldrw.u32 q0, [r12]
; CHECK-LE-NEXT:    vstrw.32 q0, [sp]
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    vshr.u32 q0, q0, #1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bl add_soft
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    vshr.u32 q0, q0, #1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    add sp, #16
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: call_soft:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .pad #16
; CHECK-BE-NEXT:    sub sp, #16
; CHECK-BE-NEXT:    add.w r12, sp, #24
; CHECK-BE-NEXT:    vldrw.u32 q0, [r12]
; CHECK-BE-NEXT:    vstrw.32 q0, [sp]
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vshr.u32 q0, q1, #1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bl add_soft
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vshr.u32 q0, q1, #1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    add sp, #16
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %0 = lshr <4 x i32> %src1, <i32 1, i32 1, i32 1, i32 1>
  %1 = call <4 x i32> @add_soft(<4 x i32> %0, <4 x i32> %src2)
  %2 = lshr <4 x i32> %1, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <4 x i32> @call_hard(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LE-LABEL: call_hard:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    vshr.u32 q0, q0, #1
; CHECK-LE-NEXT:    bl add_hard
; CHECK-LE-NEXT:    vshr.u32 q0, q0, #1
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: call_hard:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    vshr.u32 q2, q2, #1
; CHECK-BE-NEXT:    vrev64.32 q0, q2
; CHECK-BE-NEXT:    bl add_hard
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vshr.u32 q1, q1, #1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %0 = lshr <4 x i32> %src1, <i32 1, i32 1, i32 1, i32 1>
  %1 = call arm_aapcs_vfpcc <4 x i32> @add_hard(<4 x i32> %0, <4 x i32> %src2)
  %2 = lshr <4 x i32> %1, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @and_v4i32(<4 x i32> %src) {
; CHECK-LE-LABEL: and_v4i32:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov.i32 q1, #0x1
; CHECK-LE-NEXT:    vand q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: and_v4i32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov.i32 q0, #0x1
; CHECK-BE-NEXT:    vand q1, q1, q0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %s1 = and <4 x i32> %src, <i32 1, i32 1, i32 1, i32 1>
  %r = bitcast <4 x i32> %s1 to <16 x i8>
  ret <16 x i8> %r
}

; Should be the same as and_v4i32 for LE
define arm_aapcs_vfpcc <16 x i8> @and_v16i8_le(<4 x i32> %src) {
; CHECK-LE-LABEL: and_v16i8_le:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov.i32 q1, #0x1
; CHECK-LE-NEXT:    vand q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: and_v16i8_le:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vmov.i32 q0, #0x1
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    vand q1, q1, q0
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %0 = bitcast <4 x i32> %src to <16 x i8>
  %r = and <16 x i8> %0, <i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}

; Should be the same (or at least equivalent) as and_v4i32 for BE
define arm_aapcs_vfpcc <16 x i8> @and_v16i8_be(<4 x i32> %src) {
; CHECK-LE-LABEL: and_v16i8_be:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov.i32 q1, #0x1000000
; CHECK-LE-NEXT:    vand q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: and_v16i8_be:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vmov.i32 q0, #0x1000000
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    vand q1, q1, q0
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %0 = bitcast <4 x i32> %src to <16 x i8>
  %r = and <16 x i8> %0, <i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 1>
  ret <16 x i8> %r
}

; FIXME: This looks wrong
define arm_aapcs_vfpcc <4 x i32> @test(i32* %data) {
; CHECK-LE-LABEL: test:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-LE-NEXT:    vmov.i32 q0, #0x1
; CHECK-LE-NEXT:    vadd.i32 q1, q1, q0
; CHECK-LE-NEXT:    @APP
; CHECK-LE-NEXT:    vmullb.s32 q0, q1, q1
; CHECK-LE-NEXT:    @NO_APP
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: test:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-BE-NEXT:    vmov.i32 q0, #0x1
; CHECK-BE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    @APP
; CHECK-BE-NEXT:    vmullb.s32 q1, q0, q0
; CHECK-BE-NEXT:    @NO_APP
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %data, i32 8
  %0 = bitcast i32* %add.ptr to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = add <4 x i32> %1, <i32 1, i32 1, i32 1, i32 1>
  %3 = tail call <4 x i32> asm sideeffect "  VMULLB.s32 $0, $1, $1", "=&w,w"(<4 x i32> %2) #2
  ret <4 x i32> %3
}
