; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin8 -mcpu=yonah | FileCheck %s

define void @test(<1 x i64> %c64, <1 x i64> %mask1, i8* %P) {
; CHECK-LABEL: test:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    .cfi_offset %edi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    movq (%esp), %mm0
; CHECK-NEXT:    movq {{[0-9]+}}(%esp), %mm1
; CHECK-NEXT:    maskmovq %mm0, %mm1
; CHECK-NEXT:    addl $16, %esp
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
	%tmp4 = bitcast <1 x i64> %mask1 to x86_mmx		; <x86_mmx> [#uses=1]
	%tmp6 = bitcast <1 x i64> %c64 to x86_mmx		; <x86_mmx> [#uses=1]
	tail call void @llvm.x86.mmx.maskmovq( x86_mmx %tmp4, x86_mmx %tmp6, i8* %P )
	ret void
}

declare void @llvm.x86.mmx.maskmovq(x86_mmx, x86_mmx, i8*)
