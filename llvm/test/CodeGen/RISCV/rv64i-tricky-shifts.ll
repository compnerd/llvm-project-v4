; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; These tests must not compile to sllw/srlw/sraw, as this would be semantically
; incorrect in the case that %b holds a value between 32 and 63. Selection
; patterns might make the mistake of assuming that a (sext_inreg foo, i32) can
; only be produced when sign-extending an i32 type.

define i64 @tricky_shl(i64 %a, i64 %b) {
; RV64I-LABEL: tricky_shl:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
  %1 = shl i64 %a, %b
  %2 = shl i64 %1, 32
  %3 = ashr i64 %2, 32
  ret i64 %3
}

define i64 @tricky_lshr(i64 %a, i64 %b) {
; RV64I-LABEL: tricky_lshr:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i64 %a, 4294967295
  %2 = lshr i64 %1, %b
  ret i64 %2
}

define i64 @tricky_ashr(i64 %a, i64 %b) {
; RV64I-LABEL: tricky_ashr:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    sra a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %a, 32
  %2 = ashr i64 %1, 32
  %3 = ashr i64 %2, %b
  ret i64 %3
}
