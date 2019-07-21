; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X64

; On X86, division in expensive. BuildRemEqFold should therefore run even
; when optimizing for size. Only optimizing for minimum size retains a plain div.

define i32 @test_minsize(i32 %X) optsize minsize nounwind readnone {
; X86-LABEL: test_minsize:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl $5
; X86-NEXT:    popl %ecx
; X86-NEXT:    cltd
; X86-NEXT:    idivl %ecx
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    je .LBB0_1
; X86-NEXT:  # %bb.2:
; X86-NEXT:    pushl $-10
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_1:
; X86-NEXT:    pushl $42
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_minsize:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    pushq $5
; X64-NEXT:    popq %rcx
; X64-NEXT:    cltd
; X64-NEXT:    idivl %ecx
; X64-NEXT:    testl %edx, %edx
; X64-NEXT:    pushq $42
; X64-NEXT:    popq %rcx
; X64-NEXT:    pushq $-10
; X64-NEXT:    popq %rax
; X64-NEXT:    cmovel %ecx, %eax
; X64-NEXT:    retq
  %rem = srem i32 %X, 5
  %cmp = icmp eq i32 %rem, 0
  %ret = select i1 %cmp, i32 42, i32 -10
  ret i32 %ret
}

define i32 @test_optsize(i32 %X) optsize nounwind readnone {
; X86-LABEL: test_optsize:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $1717986919, %edx # imm = 0x66666667
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    imull %edx
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    shrl $31, %eax
; X86-NEXT:    sarl %edx
; X86-NEXT:    addl %eax, %edx
; X86-NEXT:    leal (%edx,%edx,4), %eax
; X86-NEXT:    cmpl %eax, %ecx
; X86-NEXT:    movl $42, %eax
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl $-10, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    retl
;
; X64-LABEL: test_optsize:
; X64:       # %bb.0:
; X64-NEXT:    movslq %edi, %rax
; X64-NEXT:    imulq $1717986919, %rax, %rcx # imm = 0x66666667
; X64-NEXT:    movq %rcx, %rdx
; X64-NEXT:    shrq $63, %rdx
; X64-NEXT:    sarq $33, %rcx
; X64-NEXT:    addl %edx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,4), %ecx
; X64-NEXT:    cmpl %ecx, %eax
; X64-NEXT:    movl $42, %ecx
; X64-NEXT:    movl $-10, %eax
; X64-NEXT:    cmovel %ecx, %eax
; X64-NEXT:    retq
  %rem = srem i32 %X, 5
  %cmp = icmp eq i32 %rem, 0
  %ret = select i1 %cmp, i32 42, i32 -10
  ret i32 %ret
}
