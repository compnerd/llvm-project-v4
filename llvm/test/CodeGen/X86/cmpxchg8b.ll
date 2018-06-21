; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown- -mcpu=core2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown- -mcpu=core2 | FileCheck %s --check-prefixes=CHECK,X64

; Basic 64-bit cmpxchg
define void @t1(i64* nocapture %p) nounwind ssp {
; X86-LABEL: t1:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    movl $1, %ebx
; X86-NEXT:    lock cmpxchg8b (%esi)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl
;
; X64-LABEL: t1:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $1, %ecx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    lock cmpxchgq %rcx, (%rdi)
; X64-NEXT:    retq
entry:
  %r = cmpxchg i64* %p, i64 0, i64 1 seq_cst seq_cst
  ret void
}

