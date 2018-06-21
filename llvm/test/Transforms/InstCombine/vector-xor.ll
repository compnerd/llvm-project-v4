; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; (A&B)^(A&C) -> A&(B^C) etc

define <4 x i32> @test_v4i32_xor_repeated_and_0(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; CHECK-LABEL: @test_v4i32_xor_repeated_and_0(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <4 x i32> [[B:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = and <4 x i32> %a, %b
  %2 = and <4 x i32> %a, %c
  %3 = xor <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @test_v4i32_xor_repeated_and_1(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; CHECK-LABEL: @test_v4i32_xor_repeated_and_1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <4 x i32> [[B:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = and <4 x i32> %a, %b
  %2 = and <4 x i32> %c, %a
  %3 = xor <4 x i32> %1, %2
  ret <4 x i32> %3
}

; xor(bswap(a), c) to bswap(xor(a, bswap(c)))

declare <4 x i32> @llvm.bswap.v4i32(<4 x i32>)

define <4 x i32> @test_v4i32_xor_bswap_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_bswap_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <4 x i32> [[A0:%.*]], <i32 -16777216, i32 -16777216, i32 -16777216, i32 -16777216>
; CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[TMP1]])
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a0)
  %2 = xor  <4 x i32> %1, <i32 255, i32 255, i32 255, i32 255>
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_bswap_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_bswap_const(
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[A0:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 0, i32 -16777216, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a0)
  %2 = xor  <4 x i32> %1, <i32 0, i32 -16777216, i32 2, i32 3>
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_bswap_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_bswap_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[A0:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 undef, i32 0, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a0)
  %2 = xor  <4 x i32> %1, <i32 undef, i32 0, i32 2, i32 3>
  ret <4 x i32> %2
}

; DeMorgan's Law: ~(~X & Y) --> (X | ~Y)

define <4 x i32> @test_v4i32_demorgan_and(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @test_v4i32_demorgan_and(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor <4 x i32> [[Y:%.*]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP1:%.*]] = or <4 x i32> [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %x
  %2 = and <4 x i32> %1, %y
  %3 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %2
  ret <4 x i32> %3
}

; DeMorgan's Law: ~(~X | Y) --> (X & ~Y)

define <4 x i32> @test_v4i32_demorgan_or(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @test_v4i32_demorgan_or(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor <4 x i32> [[Y:%.*]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP1:%.*]] = and <4 x i32> [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %x
  %2 = or  <4 x i32> %1, %y
  %3 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %2
  ret <4 x i32> %3
}

; ~(~X >>s Y) --> (X >>s Y)

define <4 x i32> @test_v4i32_not_ashr_not(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @test_v4i32_not_ashr_not(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %x
  %2 = ashr <4 x i32> %1, %y
  %3 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %2
  ret <4 x i32> %3
}

define <4 x i32> @test_v4i32_not_ashr_not_undef(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @test_v4i32_not_ashr_not_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 undef>, %x
  %2 = ashr <4 x i32> %1, %y
  %3 = xor  <4 x i32> <i32 -1, i32 -1, i32 undef, i32 -1>, %2
  ret <4 x i32> %3
}

; ~(C >>s Y) --> ~C >>u Y (when inverting the replicated sign bits)

define <4 x i32> @test_v4i32_not_ashr_negative_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_ashr_negative_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> <i32 2, i32 2, i32 2, i32 2>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = ashr <4 x i32> <i32 -3, i32 -3, i32 -3, i32 -3>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_ashr_negative_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_ashr_negative_const(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> <i32 2, i32 4, i32 6, i32 8>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = ashr <4 x i32> <i32 -3, i32 -5, i32 -7, i32 -9>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_ashr_negative_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_ashr_negative_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> <i32 2, i32 4, i32 undef, i32 8>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = ashr <4 x i32> <i32 -3, i32 -5, i32 undef, i32 -9>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 undef>, %1
  ret <4 x i32> %2
}

; ~(C >>u Y) --> ~C >>s Y (when inverting the replicated sign bits)

define <4 x i32> @test_v4i32_not_lshr_nonnegative_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_lshr_nonnegative_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> <i32 -4, i32 -4, i32 -4, i32 -4>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = lshr <4 x i32> <i32  3, i32  3, i32  3, i32  3>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_lshr_nonnegative_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_lshr_nonnegative_const(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> <i32 -4, i32 -6, i32 -8, i32 -10>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = lshr <4 x i32> <i32  3, i32  5, i32  7, i32  9>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_lshr_nonnegative_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_lshr_nonnegative_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> <i32 -4, i32 -6, i32 undef, i32 -10>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = lshr <4 x i32> <i32  3, i32  5, i32 undef, i32  9>, %a0
  %2 = xor  <4 x i32> <i32 -1, i32 -1, i32 -1, i32 undef>, %1
  ret <4 x i32> %2
}

; ~(C-X) == X-C-1 == X+(-C-1)

define <4 x i32> @test_v4i32_not_sub_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_sub_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 -4, i32 -4, i32 -4, i32 -4>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = sub <4 x i32> <i32  3, i32  3, i32  3, i32  3>, %a0
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_sub_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_sub_const(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 3, i32 5, i32 -1, i32 15>, [[A0:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> <i32  3, i32  5, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_sub_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_sub_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 3, i32 undef, i32 -1, i32 15>, [[A0:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -1, i32 -1, i32 -1, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> <i32  3, i32 undef, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 undef>, %1
  ret <4 x i32> %2
}

; (C - X) ^ signmask -> (C + signmask - X)

define <4 x i32> @test_v4i32_xor_signmask_sub_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_sub_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 -2147483645, i32 -2147483645, i32 -2147483645, i32 -2147483645>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = sub <4 x i32> <i32  3, i32  3, i32  3, i32  3>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_signmask_sub_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_sub_const(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 3, i32 5, i32 -1, i32 15>, [[A0:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> <i32  3, i32 5, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_signmask_sub_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_sub_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 3, i32 undef, i32 -1, i32 15>, [[A0:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> <i32  3, i32 undef, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 undef>, %1
  ret <4 x i32> %2
}

; ~(X-C) --> (-C-1)-X

define <4 x i32> @test_v4i32_not_signmask_sub_var_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_signmask_sub_var_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, [[A0:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = sub <4 x i32> %a0, <i32  3, i32  3, i32  3, i32  3>
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_signmask_sub_var_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_signmask_sub_var_const(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 -3, i32 -5, i32 1, i32 -15>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> %a0, <i32 3, i32 5, i32 -1, i32 15>
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_not_signmask_sub_var_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_not_signmask_sub_var_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 -3, i32 undef, i32 1, i32 -15>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -1, i32 -1, i32 -1, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = sub <4 x i32> %a0, <i32 3, i32 undef, i32 -1, i32 15>
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32 -1, i32 undef>, %1
  ret <4 x i32> %2
}

; (X + C) ^ signmask -> (X + C + signmask)

define <4 x i32> @test_v4i32_xor_signmask_add_splatconst(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_add_splatconst(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 -2147483645, i32 -2147483645, i32 -2147483645, i32 -2147483645>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = add <4 x i32> <i32  3, i32  3, i32  3, i32  3>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_signmask_add_const(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_add_const(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 3, i32 5, i32 -1, i32 15>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = add <4 x i32> <i32  3, i32 5, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, %1
  ret <4 x i32> %2
}

define <4 x i32> @test_v4i32_xor_signmask_add_const_undef(<4 x i32> %a0) {
; CHECK-LABEL: @test_v4i32_xor_signmask_add_const_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A0:%.*]], <i32 3, i32 undef, i32 -1, i32 15>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i32> [[TMP1]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = add <4 x i32> <i32  3, i32 undef, i32 -1, i32 15>, %a0
  %2 = xor <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 undef>, %1
  ret <4 x i32> %2
}
