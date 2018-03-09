; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512

define i32 @_Z10test_shortPsS_i(i16* nocapture readonly, i16* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: _Z10test_shortPsS_i:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    xorl %ecx, %ecx
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB0_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movdqu (%rdi,%rcx,2), %xmm2
; SSE2-NEXT:    movdqu (%rsi,%rcx,2), %xmm3
; SSE2-NEXT:    pmaddwd %xmm2, %xmm3
; SSE2-NEXT:    paddd %xmm3, %xmm1
; SSE2-NEXT:    addq $8, %rcx
; SSE2-NEXT:    cmpq %rcx, %rax
; SSE2-NEXT:    jne .LBB0_1
; SSE2-NEXT:  # %bb.2: # %middle.block
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: _Z10test_shortPsS_i:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    xorl %ecx, %ecx
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB0_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vmovdqu (%rsi,%rcx,2), %xmm1
; AVX2-NEXT:    vpmaddwd (%rdi,%rcx,2), %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    addq $8, %rcx
; AVX2-NEXT:    cmpq %rcx, %rax
; AVX2-NEXT:    jne .LBB0_1
; AVX2-NEXT:  # %bb.2: # %middle.block
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: _Z10test_shortPsS_i:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    xorl %ecx, %ecx
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB0_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vmovdqu (%rsi,%rcx,2), %xmm1
; AVX512-NEXT:    vpmaddwd (%rdi,%rcx,2), %xmm1, %xmm1
; AVX512-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    addq $8, %rcx
; AVX512-NEXT:    cmpq %rcx, %rax
; AVX512-NEXT:    jne .LBB0_1
; AVX512-NEXT:  # %bb.2: # %middle.block
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <8 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i16, i16* %0, i64 %index
  %5 = bitcast i16* %4 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %5, align 2
  %6 = sext <8 x i16> %wide.load to <8 x i32>
  %7 = getelementptr inbounds i16, i16* %1, i64 %index
  %8 = bitcast i16* %7 to <8 x i16>*
  %wide.load14 = load <8 x i16>, <8 x i16>* %8, align 2
  %9 = sext <8 x i16> %wide.load14 to <8 x i32>
  %10 = mul nsw <8 x i32> %9, %6
  %11 = add nsw <8 x i32> %10, %vec.phi
  %index.next = add i64 %index, 8
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <8 x i32> %11, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <8 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <8 x i32> %bin.rdx16, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <8 x i32> %bin.rdx16, %rdx.shuf17
  %13 = extractelement <8 x i32> %bin.rdx18, i32 0
  ret i32 %13
}

define i32 @test_unsigned_short(i16* nocapture readonly, i16* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: test_unsigned_short:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    xorl %ecx, %ecx
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB1_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movdqu (%rdi,%rcx,2), %xmm2
; SSE2-NEXT:    movdqu (%rsi,%rcx,2), %xmm3
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pmulhuw %xmm2, %xmm4
; SSE2-NEXT:    pmullw %xmm2, %xmm3
; SSE2-NEXT:    movdqa %xmm3, %xmm2
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm4[0],xmm2[1],xmm4[1],xmm2[2],xmm4[2],xmm2[3],xmm4[3]
; SSE2-NEXT:    paddd %xmm2, %xmm0
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm3 = xmm3[4],xmm4[4],xmm3[5],xmm4[5],xmm3[6],xmm4[6],xmm3[7],xmm4[7]
; SSE2-NEXT:    paddd %xmm3, %xmm1
; SSE2-NEXT:    addq $8, %rcx
; SSE2-NEXT:    cmpq %rcx, %rax
; SSE2-NEXT:    jne .LBB1_1
; SSE2-NEXT:  # %bb.2: # %middle.block
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test_unsigned_short:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    xorl %ecx, %ecx
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB1_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX2-NEXT:    vpmulld %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    addq $8, %rcx
; AVX2-NEXT:    cmpq %rcx, %rax
; AVX2-NEXT:    jne .LBB1_1
; AVX2-NEXT:  # %bb.2: # %middle.block
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_unsigned_short:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    xorl %ecx, %ecx
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB1_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vpmovzxwd {{.*#+}} ymm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vpmovzxwd {{.*#+}} ymm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vpmulld %ymm1, %ymm2, %ymm1
; AVX512-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    addq $8, %rcx
; AVX512-NEXT:    cmpq %rcx, %rax
; AVX512-NEXT:    jne .LBB1_1
; AVX512-NEXT:  # %bb.2: # %middle.block
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <8 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i16, i16* %0, i64 %index
  %5 = bitcast i16* %4 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %5, align 2
  %6 = zext <8 x i16> %wide.load to <8 x i32>
  %7 = getelementptr inbounds i16, i16* %1, i64 %index
  %8 = bitcast i16* %7 to <8 x i16>*
  %wide.load14 = load <8 x i16>, <8 x i16>* %8, align 2
  %9 = zext <8 x i16> %wide.load14 to <8 x i32>
  %10 = mul nsw <8 x i32> %9, %6
  %11 = add nsw <8 x i32> %10, %vec.phi
  %index.next = add i64 %index, 8
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <8 x i32> %11, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <8 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <8 x i32> %bin.rdx16, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <8 x i32> %bin.rdx16, %rdx.shuf17
  %13 = extractelement <8 x i32> %bin.rdx18, i32 0
  ret i32 %13
}

define i32 @_Z9test_charPcS_i(i8* nocapture readonly, i8* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: _Z9test_charPcS_i:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    xorl %ecx, %ecx
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pxor %xmm3, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm2
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB2_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movq {{.*#+}} xmm4 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm4
; SSE2-NEXT:    movq {{.*#+}} xmm5 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm5 = xmm5[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm5
; SSE2-NEXT:    pmullw %xmm4, %xmm5
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[1],xmm5[1],xmm4[2],xmm5[2],xmm4[3],xmm5[3]
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    paddd %xmm4, %xmm0
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm4 = xmm4[4],xmm5[4],xmm4[5],xmm5[5],xmm4[6],xmm5[6],xmm4[7],xmm5[7]
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    paddd %xmm4, %xmm1
; SSE2-NEXT:    movq {{.*#+}} xmm4 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm4
; SSE2-NEXT:    movq {{.*#+}} xmm5 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm5 = xmm5[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm5
; SSE2-NEXT:    pmullw %xmm4, %xmm5
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[1],xmm5[1],xmm4[2],xmm5[2],xmm4[3],xmm5[3]
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    paddd %xmm4, %xmm3
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm4 = xmm4[4],xmm5[4],xmm4[5],xmm5[5],xmm4[6],xmm5[6],xmm4[7],xmm5[7]
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    paddd %xmm4, %xmm2
; SSE2-NEXT:    addq $16, %rcx
; SSE2-NEXT:    cmpq %rcx, %rax
; SSE2-NEXT:    jne .LBB2_1
; SSE2-NEXT:  # %bb.2: # %middle.block
; SSE2-NEXT:    paddd %xmm3, %xmm0
; SSE2-NEXT:    paddd %xmm2, %xmm1
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: _Z9test_charPcS_i:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    xorl %ecx, %ecx
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB2_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovsxbw (%rdi,%rcx), %ymm2
; AVX2-NEXT:    vpmovsxbw (%rsi,%rcx), %ymm3
; AVX2-NEXT:    vpmaddwd %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpaddd %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    addq $16, %rcx
; AVX2-NEXT:    cmpq %rcx, %rax
; AVX2-NEXT:    jne .LBB2_1
; AVX2-NEXT:  # %bb.2: # %middle.block
; AVX2-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: _Z9test_charPcS_i:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    xorl %ecx, %ecx
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB2_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vpmovsxbw (%rdi,%rcx), %ymm1
; AVX512-NEXT:    vpmovsxbw (%rsi,%rcx), %ymm2
; AVX512-NEXT:    vpmaddwd %ymm1, %ymm2, %ymm1
; AVX512-NEXT:    vpaddd %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    addq $16, %rcx
; AVX512-NEXT:    cmpq %rcx, %rax
; AVX512-NEXT:    jne .LBB2_1
; AVX512-NEXT:  # %bb.2: # %middle.block
; AVX512-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <16 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i8, i8* %0, i64 %index
  %5 = bitcast i8* %4 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %5, align 1
  %6 = sext <16 x i8> %wide.load to <16 x i32>
  %7 = getelementptr inbounds i8, i8* %1, i64 %index
  %8 = bitcast i8* %7 to <16 x i8>*
  %wide.load14 = load <16 x i8>, <16 x i8>* %8, align 1
  %9 = sext <16 x i8> %wide.load14 to <16 x i32>
  %10 = mul nsw <16 x i32> %9, %6
  %11 = add nsw <16 x i32> %10, %vec.phi
  %index.next = add i64 %index, 16
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <16 x i32> %11, <16 x i32> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <16 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <16 x i32> %bin.rdx, <16 x i32> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <16 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <16 x i32> %bin.rdx16, <16 x i32> undef, <16 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <16 x i32> %bin.rdx16, %rdx.shuf17
  %rdx.shuf19 = shufflevector <16 x i32> %bin.rdx18, <16 x i32> undef, <16 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx20 = add <16 x i32> %bin.rdx18, %rdx.shuf19
  %13 = extractelement <16 x i32> %bin.rdx20, i32 0
  ret i32 %13
}
