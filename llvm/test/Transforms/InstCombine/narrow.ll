; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "n8:16:32:64"

; Eliminating the casts in this testcase (by narrowing the AND operation)
; allows instcombine to realize the function always returns false.

define i1 @test1(i32 %A, i32 %B) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i1 false
;
  %C1 = icmp slt i32 %A, %B
  %ELIM1 = zext i1 %C1 to i32
  %C2 = icmp sgt i32 %A, %B
  %ELIM2 = zext i1 %C2 to i32
  %C3 = and i32 %ELIM1, %ELIM2
  %ELIM3 = trunc i32 %C3 to i1
  ret i1 %ELIM3
}

; The next 6 (3 logic ops * (scalar+vector)) tests show potential cases for narrowing a bitwise logic op.

define i32 @shrink_xor(i64 %a) {
; CHECK-LABEL: @shrink_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 %a to i32
; CHECK-NEXT:    [[TRUNC:%.*]] = xor i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[TRUNC]]
;
  %xor = xor i64 %a, 1
  %trunc = trunc i64 %xor to i32
  ret i32 %trunc
}

; Vectors (with splat constants) should get the same transform.

define <2 x i32> @shrink_xor_vec(<2 x i64> %a) {
; CHECK-LABEL: @shrink_xor_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i64> %a to <2 x i32>
; CHECK-NEXT:    [[TRUNC:%.*]] = xor <2 x i32> [[TMP1]], <i32 2, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[TRUNC]]
;
  %xor = xor <2 x i64> %a, <i64 2, i64 2>
  %trunc = trunc <2 x i64> %xor to <2 x i32>
  ret <2 x i32> %trunc
}

; Source and dest types are not in the datalayout.

define i3 @shrink_or(i6 %a) {
; CHECK-LABEL: @shrink_or(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i6 %a to i3
; CHECK-NEXT:    [[TRUNC:%.*]] = or i3 [[TMP1]], 1
; CHECK-NEXT:    ret i3 [[TRUNC]]
;
  %or = or i6 %a, 33
  %trunc = trunc i6 %or to i3
  ret i3 %trunc
}

; Vectors (with non-splat constants) should get the same transform.

define <2 x i8> @shrink_or_vec(<2 x i16> %a) {
; CHECK-LABEL: @shrink_or_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i16> %a to <2 x i8>
; CHECK-NEXT:    [[TRUNC:%.*]] = or <2 x i8> [[TMP1]], <i8 -1, i8 0>
; CHECK-NEXT:    ret <2 x i8> [[TRUNC]]
;
  %or = or <2 x i16> %a, <i16 -1, i16 256>
  %trunc = trunc <2 x i16> %or to <2 x i8>
  ret <2 x i8> %trunc
}

; We discriminate against weird types.

define i31 @shrink_and(i64 %a) {
; CHECK-LABEL: @shrink_and(
; CHECK-NEXT:    [[AND:%.*]] = and i64 %a, 42
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i64 [[AND]] to i31
; CHECK-NEXT:    ret i31 [[TRUNC]]
;
  %and = and i64 %a, 42
  %trunc = trunc i64 %and to i31
  ret i31 %trunc
}

; Chop the top of the constant(s) if needed.

define <2 x i32> @shrink_and_vec(<2 x i33> %a) {
; CHECK-LABEL: @shrink_and_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i33> %a to <2 x i32>
; CHECK-NEXT:    [[TRUNC:%.*]] = and <2 x i32> [[TMP1]], <i32 0, i32 6>
; CHECK-NEXT:    ret <2 x i32> [[TRUNC]]
;
  %and = and <2 x i33> %a, <i33 4294967296, i33 6>
  %trunc = trunc <2 x i33> %and to <2 x i32>
  ret <2 x i32> %trunc
}

