; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2  | FileCheck %s

; widen a v3i32 to v4i32 to do a vector multiple and a subtraction

define void @update(<3 x i32>* %dst, <3 x i32>* %src, i32 %n) nounwind {
; CHECK-LABEL: update:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl %edx, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq {{.*}}(%rip), %rax
; CHECK-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl $1, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl $0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movdqa {{.*#+}} xmm0 = <3,3,3,u>
; CHECK-NEXT:    jmp .LBB0_1
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %forbody
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movslq -{{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    shlq $4, %rcx
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    movdqa (%rdx,%rcx), %xmm1
; CHECK-NEXT:    pslld $2, %xmm1
; CHECK-NEXT:    psubd %xmm0, %xmm1
; CHECK-NEXT:    pextrd $2, %xmm1, 8(%rax,%rcx)
; CHECK-NEXT:    movq %xmm1, (%rax,%rcx)
; CHECK-NEXT:    incl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:  .LBB0_1: # %forcond
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    cmpl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    jl .LBB0_2
; CHECK-NEXT:  # %bb.3: # %afterfor
; CHECK-NEXT:    retq
entry:
	%dst.addr = alloca <3 x i32>*
	%src.addr = alloca <3 x i32>*
	%n.addr = alloca i32
	%v = alloca <3 x i32>, align 16
	%i = alloca i32, align 4
	store <3 x i32>* %dst, <3 x i32>** %dst.addr
	store <3 x i32>* %src, <3 x i32>** %src.addr
	store i32 %n, i32* %n.addr
	store <3 x i32> < i32 1, i32 1, i32 1 >, <3 x i32>* %v
	store i32 0, i32* %i
	br label %forcond

forcond:
	%tmp = load i32, i32* %i
	%tmp1 = load i32, i32* %n.addr
	%cmp = icmp slt i32 %tmp, %tmp1
	br i1 %cmp, label %forbody, label %afterfor

forbody:
	%tmp2 = load i32, i32* %i
	%tmp3 = load <3 x i32>*, <3 x i32>** %dst.addr
	%arrayidx = getelementptr <3 x i32>, <3 x i32>* %tmp3, i32 %tmp2
	%tmp4 = load i32, i32* %i
	%tmp5 = load <3 x i32>*, <3 x i32>** %src.addr
	%arrayidx6 = getelementptr <3 x i32>, <3 x i32>* %tmp5, i32 %tmp4
	%tmp7 = load <3 x i32>, <3 x i32>* %arrayidx6
	%mul = mul <3 x i32> %tmp7, < i32 4, i32 4, i32 4 >
	%sub = sub <3 x i32> %mul, < i32 3, i32 3, i32 3 >
	store <3 x i32> %sub, <3 x i32>* %arrayidx
	br label %forinc

forinc:
	%tmp8 = load i32, i32* %i
	%inc = add i32 %tmp8, 1
	store i32 %inc, i32* %i
	br label %forcond

afterfor:
	ret void
}

