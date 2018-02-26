; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

; Check that multiple instances of 64-bit constants encodable as
; 32-bit immediates are merged for code size savings.

; Immediates with multiple users should not be pulled into instructions when
; optimizing for code size.
define i1 @imm_multiple_users(i64 %a, i64* %b) optsize {
; CHECK-LABEL: imm_multiple_users:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq $-1, %rax
; CHECK-NEXT:    movq %rax, (%rsi)
; CHECK-NEXT:    cmpq %rax, %rdi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  store i64 -1, i64* %b, align 8
  %cmp = icmp eq i64 %a, -1
  ret i1 %cmp
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1)

; Inlined memsets requiring multiple same-sized stores should be lowered using
; the register, rather than immediate, form of stores when optimizing for
; code size.
define void @memset_zero(i8* noalias nocapture %D) optsize {
; CHECK-LABEL: memset_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movq %rax, 7(%rdi)
; CHECK-NEXT:    movq %rax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memset.p0i8.i64(i8* %D, i8 0, i64 15, i32 1, i1 false)
  ret void
}
