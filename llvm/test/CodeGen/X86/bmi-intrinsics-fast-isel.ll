; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -fast-isel-sink-local-values < %s -fast-isel -mtriple=i686-unknown-unknown -mattr=+bmi | FileCheck %s --check-prefix=X32
; RUN: llc -fast-isel-sink-local-values < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+bmi | FileCheck %s --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/bmi-builtins.c

;
; AMD Intrinsics
;

define i16 @test__tzcnt_u16(i16 %a0) {
; X32-LABEL: test__tzcnt_u16:
; X32:       # %bb.0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movzwl %ax, %ecx
; X32-NEXT:    cmpl $0, %ecx
; X32-NEXT:    jne .LBB0_1
; X32-NEXT:  # %bb.2:
; X32-NEXT:    movw $16, %ax
; X32-NEXT:    retl
; X32-NEXT:  .LBB0_1:
; X32-NEXT:    tzcntw %ax, %ax
; X32-NEXT:    retl
;
; X64-LABEL: test__tzcnt_u16:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    tzcntw %ax, %cx
; X64-NEXT:    cmpl $0, %eax
; X64-NEXT:    movw $16, %ax
; X64-NEXT:    cmovnew %cx, %ax
; X64-NEXT:    retq
  %zext = zext i16 %a0 to i32
  %cmp = icmp ne i32 %zext, 0
  %cttz = call i16 @llvm.cttz.i16(i16 %a0, i1 true)
  %res = select i1 %cmp, i16 %cttz, i16 16
  ret i16 %res
}

define i32 @test__andn_u32(i32 %a0, i32 %a1) {
; X32-LABEL: test__andn_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    xorl $-1, %eax
; X32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__andn_u32:
; X64:       # %bb.0:
; X64-NEXT:    xorl $-1, %edi
; X64-NEXT:    andl %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %xor = xor i32 %a0, -1
  %res = and i32 %xor, %a1
  ret i32 %res
}

define i32 @test__bextr_u32(i32 %a0, i32 %a1) {
; X32-LABEL: test__bextr_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    bextrl %eax, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__bextr_u32:
; X64:       # %bb.0:
; X64-NEXT:    bextrl %esi, %edi, %eax
; X64-NEXT:    retq
  %res = call i32 @llvm.x86.bmi.bextr.32(i32 %a0, i32 %a1)
  ret i32 %res
}

define i32 @test__blsi_u32(i32 %a0) {
; X32-LABEL: test__blsi_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blsi_u32:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    retq
  %neg = sub i32 0, %a0
  %res = and i32 %a0, %neg
  ret i32 %res
}

define i32 @test__blsmsk_u32(i32 %a0) {
; X32-LABEL: test__blsmsk_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blsmsk_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    subl $1, %eax
; X64-NEXT:    xorl %edi, %eax
; X64-NEXT:    retq
  %dec = sub i32 %a0, 1
  %res = xor i32 %a0, %dec
  ret i32 %res
}

define i32 @test__blsr_u32(i32 %a0) {
; X32-LABEL: test__blsr_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blsr_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    subl $1, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    retq
  %dec = sub i32 %a0, 1
  %res = and i32 %a0, %dec
  ret i32 %res
}

define i32 @test__tzcnt_u32(i32 %a0) {
; X32-LABEL: test__tzcnt_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    cmpl $0, %eax
; X32-NEXT:    jne .LBB6_1
; X32-NEXT:  # %bb.2:
; X32-NEXT:    movl $32, %eax
; X32-NEXT:    retl
; X32-NEXT:  .LBB6_1:
; X32-NEXT:    tzcntl %eax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__tzcnt_u32:
; X64:       # %bb.0:
; X64-NEXT:    tzcntl %edi, %ecx
; X64-NEXT:    movl $32, %eax
; X64-NEXT:    cmovael %ecx, %eax
; X64-NEXT:    retq
  %cmp = icmp ne i32 %a0, 0
  %cttz = call i32 @llvm.cttz.i32(i32 %a0, i1 true)
  %res = select i1 %cmp, i32 %cttz, i32 32
  ret i32 %res
}

;
; Intel intrinsics
;

define i16 @test_tzcnt_u16(i16 %a0) {
; X32-LABEL: test_tzcnt_u16:
; X32:       # %bb.0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movzwl %ax, %ecx
; X32-NEXT:    cmpl $0, %ecx
; X32-NEXT:    jne .LBB7_1
; X32-NEXT:  # %bb.2:
; X32-NEXT:    movw $16, %ax
; X32-NEXT:    retl
; X32-NEXT:  .LBB7_1:
; X32-NEXT:    tzcntw %ax, %ax
; X32-NEXT:    retl
;
; X64-LABEL: test_tzcnt_u16:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    tzcntw %ax, %cx
; X64-NEXT:    cmpl $0, %eax
; X64-NEXT:    movw $16, %ax
; X64-NEXT:    cmovnew %cx, %ax
; X64-NEXT:    retq
  %zext = zext i16 %a0 to i32
  %cmp = icmp ne i32 %zext, 0
  %cttz = call i16 @llvm.cttz.i16(i16 %a0, i1 true)
  %res = select i1 %cmp, i16 %cttz, i16 16
  ret i16 %res
}

define i32 @test_andn_u32(i32 %a0, i32 %a1) {
; X32-LABEL: test_andn_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    xorl $-1, %eax
; X32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_andn_u32:
; X64:       # %bb.0:
; X64-NEXT:    xorl $-1, %edi
; X64-NEXT:    andl %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %xor = xor i32 %a0, -1
  %res = and i32 %xor, %a1
  ret i32 %res
}

define i32 @test_bextr_u32(i32 %a0, i32 %a1, i32 %a2) {
; X32-LABEL: test_bextr_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    andl $255, %ecx
; X32-NEXT:    andl $255, %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    bextrl %eax, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_bextr_u32:
; X64:       # %bb.0:
; X64-NEXT:    andl $255, %esi
; X64-NEXT:    andl $255, %edx
; X64-NEXT:    shll $8, %edx
; X64-NEXT:    orl %esi, %edx
; X64-NEXT:    bextrl %edx, %edi, %eax
; X64-NEXT:    retq
  %and1 = and i32 %a1, 255
  %and2 = and i32 %a2, 255
  %shl = shl i32 %and2, 8
  %or = or i32 %and1, %shl
  %res = call i32 @llvm.x86.bmi.bextr.32(i32 %a0, i32 %or)
  ret i32 %res
}

define i32 @test_blsi_u32(i32 %a0) {
; X32-LABEL: test_blsi_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_blsi_u32:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    retq
  %neg = sub i32 0, %a0
  %res = and i32 %a0, %neg
  ret i32 %res
}

define i32 @test_blsmsk_u32(i32 %a0) {
; X32-LABEL: test_blsmsk_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_blsmsk_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    subl $1, %eax
; X64-NEXT:    xorl %edi, %eax
; X64-NEXT:    retq
  %dec = sub i32 %a0, 1
  %res = xor i32 %a0, %dec
  ret i32 %res
}

define i32 @test_blsr_u32(i32 %a0) {
; X32-LABEL: test_blsr_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_blsr_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    subl $1, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    retq
  %dec = sub i32 %a0, 1
  %res = and i32 %a0, %dec
  ret i32 %res
}

define i32 @test_tzcnt_u32(i32 %a0) {
; X32-LABEL: test_tzcnt_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    cmpl $0, %eax
; X32-NEXT:    jne .LBB13_1
; X32-NEXT:  # %bb.2:
; X32-NEXT:    movl $32, %eax
; X32-NEXT:    retl
; X32-NEXT:  .LBB13_1:
; X32-NEXT:    tzcntl %eax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_tzcnt_u32:
; X64:       # %bb.0:
; X64-NEXT:    tzcntl %edi, %ecx
; X64-NEXT:    movl $32, %eax
; X64-NEXT:    cmovael %ecx, %eax
; X64-NEXT:    retq
  %cmp = icmp ne i32 %a0, 0
  %cttz = call i32 @llvm.cttz.i32(i32 %a0, i1 true)
  %res = select i1 %cmp, i32 %cttz, i32 32
  ret i32 %res
}

declare i16 @llvm.cttz.i16(i16, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare i32 @llvm.x86.bmi.bextr.32(i32, i32)
