; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512vl,avx512bw,avx512dq,prefer-256-bit | FileCheck %s

; This file primarily contains tests for specific places in X86ISelLowering.cpp that needed be made aware of the legalizer not allowing 512-bit vectors due to prefer-256-bit even though AVX512 is enabled.

define void @add256(<16 x i32>* %a, <16 x i32>* %b, <16 x i32>* %c) "min-legal-vector-width"="256" {
; CHECK-LABEL: add256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa (%rdi), %ymm0
; CHECK-NEXT:    vmovdqa 32(%rdi), %ymm1
; CHECK-NEXT:    vpaddd (%rsi), %ymm0, %ymm0
; CHECK-NEXT:    vpaddd 32(%rsi), %ymm1, %ymm1
; CHECK-NEXT:    vmovdqa %ymm1, 32(%rdx)
; CHECK-NEXT:    vmovdqa %ymm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %d = load <16 x i32>, <16 x i32>* %a
  %e = load <16 x i32>, <16 x i32>* %b
  %f = add <16 x i32> %d, %e
  store <16 x i32> %f, <16 x i32>* %c
  ret void
}

define void @add512(<16 x i32>* %a, <16 x i32>* %b, <16 x i32>* %c) "min-legal-vector-width"="512" {
; CHECK-LABEL: add512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 (%rdi), %zmm0
; CHECK-NEXT:    vpaddd (%rsi), %zmm0, %zmm0
; CHECK-NEXT:    vmovdqa64 %zmm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %d = load <16 x i32>, <16 x i32>* %a
  %e = load <16 x i32>, <16 x i32>* %b
  %f = add <16 x i32> %d, %e
  store <16 x i32> %f, <16 x i32>* %c
  ret void
}

define void @avg_v64i8_256(<64 x i8>* %a, <64 x i8>* %b) "min-legal-vector-width"="256" {
; CHECK-LABEL: avg_v64i8_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa (%rsi), %ymm0
; CHECK-NEXT:    vmovdqa 32(%rsi), %ymm1
; CHECK-NEXT:    vpavgb (%rdi), %ymm0, %ymm0
; CHECK-NEXT:    vpavgb 32(%rdi), %ymm1, %ymm1
; CHECK-NEXT:    vmovdqu %ymm1, (%rax)
; CHECK-NEXT:    vmovdqu %ymm0, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %1 = load <64 x i8>, <64 x i8>* %a
  %2 = load <64 x i8>, <64 x i8>* %b
  %3 = zext <64 x i8> %1 to <64 x i32>
  %4 = zext <64 x i8> %2 to <64 x i32>
  %5 = add nuw nsw <64 x i32> %3, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %6 = add nuw nsw <64 x i32> %5, %4
  %7 = lshr <64 x i32> %6, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %8 = trunc <64 x i32> %7 to <64 x i8>
  store <64 x i8> %8, <64 x i8>* undef, align 4
  ret void
}


define void @avg_v64i8_512(<64 x i8>* %a, <64 x i8>* %b) "min-legal-vector-width"="512" {
; CHECK-LABEL: avg_v64i8_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 (%rsi), %zmm0
; CHECK-NEXT:    vpavgb (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    vmovdqu64 %zmm0, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %1 = load <64 x i8>, <64 x i8>* %a
  %2 = load <64 x i8>, <64 x i8>* %b
  %3 = zext <64 x i8> %1 to <64 x i32>
  %4 = zext <64 x i8> %2 to <64 x i32>
  %5 = add nuw nsw <64 x i32> %3, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %6 = add nuw nsw <64 x i32> %5, %4
  %7 = lshr <64 x i32> %6, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %8 = trunc <64 x i32> %7 to <64 x i8>
  store <64 x i8> %8, <64 x i8>* undef, align 4
  ret void
}

define void @pmaddwd_32_256(<32 x i16>* %APtr, <32 x i16>* %BPtr, <16 x i32>* %CPtr) "min-legal-vector-width"="256" {
; CHECK-LABEL: pmaddwd_32_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa (%rdi), %ymm0
; CHECK-NEXT:    vmovdqa 32(%rdi), %ymm1
; CHECK-NEXT:    vpmaddwd (%rsi), %ymm0, %ymm0
; CHECK-NEXT:    vpmaddwd 32(%rsi), %ymm1, %ymm1
; CHECK-NEXT:    vmovdqa %ymm1, 32(%rdx)
; CHECK-NEXT:    vmovdqa %ymm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
   %A = load <32 x i16>, <32 x i16>* %APtr
   %B = load <32 x i16>, <32 x i16>* %BPtr
   %a = sext <32 x i16> %A to <32 x i32>
   %b = sext <32 x i16> %B to <32 x i32>
   %m = mul nsw <32 x i32> %a, %b
   %odd = shufflevector <32 x i32> %m, <32 x i32> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
   %even = shufflevector <32 x i32> %m, <32 x i32> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
   %ret = add <16 x i32> %odd, %even
   store <16 x i32> %ret, <16 x i32>* %CPtr
   ret void
}

define void @pmaddwd_32_512(<32 x i16>* %APtr, <32 x i16>* %BPtr, <16 x i32>* %CPtr) "min-legal-vector-width"="512" {
; CHECK-LABEL: pmaddwd_32_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 (%rdi), %zmm0
; CHECK-NEXT:    vpmaddwd (%rsi), %zmm0, %zmm0
; CHECK-NEXT:    vmovdqa64 %zmm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
   %A = load <32 x i16>, <32 x i16>* %APtr
   %B = load <32 x i16>, <32 x i16>* %BPtr
   %a = sext <32 x i16> %A to <32 x i32>
   %b = sext <32 x i16> %B to <32 x i32>
   %m = mul nsw <32 x i32> %a, %b
   %odd = shufflevector <32 x i32> %m, <32 x i32> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
   %even = shufflevector <32 x i32> %m, <32 x i32> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
   %ret = add <16 x i32> %odd, %even
   store <16 x i32> %ret, <16 x i32>* %CPtr
   ret void
}

define void @psubus_64i8_max_256(<64 x i8>* %xptr, <64 x i8>* %yptr, <64 x i8>* %zptr) "min-legal-vector-width"="256" {
; CHECK-LABEL: psubus_64i8_max_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa (%rdi), %ymm0
; CHECK-NEXT:    vmovdqa 32(%rdi), %ymm1
; CHECK-NEXT:    vpsubusb (%rsi), %ymm0, %ymm0
; CHECK-NEXT:    vpsubusb 32(%rsi), %ymm1, %ymm1
; CHECK-NEXT:    vmovdqa %ymm1, 32(%rdx)
; CHECK-NEXT:    vmovdqa %ymm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %x = load <64 x i8>, <64 x i8>* %xptr
  %y = load <64 x i8>, <64 x i8>* %yptr
  %cmp = icmp ult <64 x i8> %x, %y
  %max = select <64 x i1> %cmp, <64 x i8> %y, <64 x i8> %x
  %res = sub <64 x i8> %max, %y
  store <64 x i8> %res, <64 x i8>* %zptr
  ret void
}

define void @psubus_64i8_max_512(<64 x i8>* %xptr, <64 x i8>* %yptr, <64 x i8>* %zptr) "min-legal-vector-width"="512" {
; CHECK-LABEL: psubus_64i8_max_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 (%rdi), %zmm0
; CHECK-NEXT:    vpsubusb (%rsi), %zmm0, %zmm0
; CHECK-NEXT:    vmovdqa64 %zmm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %x = load <64 x i8>, <64 x i8>* %xptr
  %y = load <64 x i8>, <64 x i8>* %yptr
  %cmp = icmp ult <64 x i8> %x, %y
  %max = select <64 x i1> %cmp, <64 x i8> %y, <64 x i8> %x
  %res = sub <64 x i8> %max, %y
  store <64 x i8> %res, <64 x i8>* %zptr
  ret void
}

define i32 @_Z9test_charPcS_i_256(i8* nocapture readonly, i8* nocapture readonly, i32) "min-legal-vector-width"="256" {
; CHECK-LABEL: _Z9test_charPcS_i_256:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB8_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vpmovsxbw (%rdi,%rcx), %ymm3
; CHECK-NEXT:    vpmovsxbw 16(%rdi,%rcx), %ymm4
; CHECK-NEXT:    vpmovsxbw (%rsi,%rcx), %ymm5
; CHECK-NEXT:    vpmaddwd %ymm3, %ymm5, %ymm3
; CHECK-NEXT:    vpaddd %ymm1, %ymm3, %ymm1
; CHECK-NEXT:    vpmovsxbw 16(%rsi,%rcx), %ymm3
; CHECK-NEXT:    vpmaddwd %ymm4, %ymm3, %ymm3
; CHECK-NEXT:    vpaddd %ymm2, %ymm3, %ymm2
; CHECK-NEXT:    addq $32, %rcx
; CHECK-NEXT:    cmpq %rcx, %rax
; CHECK-NEXT:    jne .LBB8_1
; CHECK-NEXT:  # %bb.2: # %middle.block
; CHECK-NEXT:    vpaddd %ymm0, %ymm1, %ymm1
; CHECK-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; CHECK-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovd %xmm0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <32 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i8, i8* %0, i64 %index
  %5 = bitcast i8* %4 to <32 x i8>*
  %wide.load = load <32 x i8>, <32 x i8>* %5, align 1
  %6 = sext <32 x i8> %wide.load to <32 x i32>
  %7 = getelementptr inbounds i8, i8* %1, i64 %index
  %8 = bitcast i8* %7 to <32 x i8>*
  %wide.load14 = load <32 x i8>, <32 x i8>* %8, align 1
  %9 = sext <32 x i8> %wide.load14 to <32 x i32>
  %10 = mul nsw <32 x i32> %9, %6
  %11 = add nsw <32 x i32> %10, %vec.phi
  %index.next = add i64 %index, 32
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf1 = shufflevector <32 x i32> %11, <32 x i32> undef, <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx1 = add <32 x i32> %11, %rdx.shuf1
  %rdx.shuf = shufflevector <32 x i32> %bin.rdx1, <32 x i32> undef, <32 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <32 x i32> %bin.rdx1, %rdx.shuf
  %rdx.shuf15 = shufflevector <32 x i32> %bin.rdx, <32 x i32> undef, <32 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx32 = add <32 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <32 x i32> %bin.rdx32, <32 x i32> undef, <32 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <32 x i32> %bin.rdx32, %rdx.shuf17
  %rdx.shuf19 = shufflevector <32 x i32> %bin.rdx18, <32 x i32> undef, <32 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx20 = add <32 x i32> %bin.rdx18, %rdx.shuf19
  %13 = extractelement <32 x i32> %bin.rdx20, i32 0
  ret i32 %13
}

define i32 @_Z9test_charPcS_i_512(i8* nocapture readonly, i8* nocapture readonly, i32) "min-legal-vector-width"="512" {
; CHECK-LABEL: _Z9test_charPcS_i_512:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB9_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vpmovsxbw (%rdi,%rcx), %zmm2
; CHECK-NEXT:    vpmovsxbw (%rsi,%rcx), %zmm3
; CHECK-NEXT:    vpmaddwd %zmm2, %zmm3, %zmm2
; CHECK-NEXT:    vpaddd %zmm1, %zmm2, %zmm1
; CHECK-NEXT:    addq $32, %rcx
; CHECK-NEXT:    cmpq %rcx, %rax
; CHECK-NEXT:    jne .LBB9_1
; CHECK-NEXT:  # %bb.2: # %middle.block
; CHECK-NEXT:    vpaddd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovd %xmm0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <32 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i8, i8* %0, i64 %index
  %5 = bitcast i8* %4 to <32 x i8>*
  %wide.load = load <32 x i8>, <32 x i8>* %5, align 1
  %6 = sext <32 x i8> %wide.load to <32 x i32>
  %7 = getelementptr inbounds i8, i8* %1, i64 %index
  %8 = bitcast i8* %7 to <32 x i8>*
  %wide.load14 = load <32 x i8>, <32 x i8>* %8, align 1
  %9 = sext <32 x i8> %wide.load14 to <32 x i32>
  %10 = mul nsw <32 x i32> %9, %6
  %11 = add nsw <32 x i32> %10, %vec.phi
  %index.next = add i64 %index, 32
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf1 = shufflevector <32 x i32> %11, <32 x i32> undef, <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx1 = add <32 x i32> %11, %rdx.shuf1
  %rdx.shuf = shufflevector <32 x i32> %bin.rdx1, <32 x i32> undef, <32 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <32 x i32> %bin.rdx1, %rdx.shuf
  %rdx.shuf15 = shufflevector <32 x i32> %bin.rdx, <32 x i32> undef, <32 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx32 = add <32 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <32 x i32> %bin.rdx32, <32 x i32> undef, <32 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <32 x i32> %bin.rdx32, %rdx.shuf17
  %rdx.shuf19 = shufflevector <32 x i32> %bin.rdx18, <32 x i32> undef, <32 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx20 = add <32 x i32> %bin.rdx18, %rdx.shuf19
  %13 = extractelement <32 x i32> %bin.rdx20, i32 0
  ret i32 %13
}

@a = global [1024 x i8] zeroinitializer, align 16
@b = global [1024 x i8] zeroinitializer, align 16

define i32 @sad_16i8_256() "min-legal-vector-width"="256" {
; CHECK-LABEL: sad_16i8_256:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    movq $-1024, %rax # imm = 0xFC00
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB10_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmovdqu a+1024(%rax), %xmm2
; CHECK-NEXT:    vpsadbw b+1024(%rax), %xmm2, %xmm2
; CHECK-NEXT:    vpaddd %ymm1, %ymm2, %ymm1
; CHECK-NEXT:    addq $4, %rax
; CHECK-NEXT:    jne .LBB10_1
; CHECK-NEXT:  # %bb.2: # %middle.block
; CHECK-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; CHECK-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovd %xmm0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.phi = phi <16 x i32> [ zeroinitializer, %entry ], [ %10, %vector.body ]
  %0 = getelementptr inbounds [1024 x i8], [1024 x i8]* @a, i64 0, i64 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 4
  %2 = zext <16 x i8> %wide.load to <16 x i32>
  %3 = getelementptr inbounds [1024 x i8], [1024 x i8]* @b, i64 0, i64 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load1 = load <16 x i8>, <16 x i8>* %4, align 4
  %5 = zext <16 x i8> %wide.load1 to <16 x i32>
  %6 = sub nsw <16 x i32> %2, %5
  %7 = icmp sgt <16 x i32> %6, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %8 = sub nsw <16 x i32> zeroinitializer, %6
  %9 = select <16 x i1> %7, <16 x i32> %6, <16 x i32> %8
  %10 = add nsw <16 x i32> %9, %vec.phi
  %index.next = add i64 %index, 4
  %11 = icmp eq i64 %index.next, 1024
  br i1 %11, label %middle.block, label %vector.body

middle.block:
  %.lcssa = phi <16 x i32> [ %10, %vector.body ]
  %rdx.shuf = shufflevector <16 x i32> %.lcssa, <16 x i32> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <16 x i32> %.lcssa, %rdx.shuf
  %rdx.shuf2 = shufflevector <16 x i32> %bin.rdx, <16 x i32> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx2 = add <16 x i32> %bin.rdx, %rdx.shuf2
  %rdx.shuf3 = shufflevector <16 x i32> %bin.rdx2, <16 x i32> undef, <16 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx3 = add <16 x i32> %bin.rdx2, %rdx.shuf3
  %rdx.shuf4 = shufflevector <16 x i32> %bin.rdx3, <16 x i32> undef, <16 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx4 = add <16 x i32> %bin.rdx3, %rdx.shuf4
  %12 = extractelement <16 x i32> %bin.rdx4, i32 0
  ret i32 %12
}

define i32 @sad_16i8_512() "min-legal-vector-width"="512" {
; CHECK-LABEL: sad_16i8_512:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    movq $-1024, %rax # imm = 0xFC00
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB11_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmovdqu a+1024(%rax), %xmm1
; CHECK-NEXT:    vpsadbw b+1024(%rax), %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    addq $4, %rax
; CHECK-NEXT:    jne .LBB11_1
; CHECK-NEXT:  # %bb.2: # %middle.block
; CHECK-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovd %xmm0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.phi = phi <16 x i32> [ zeroinitializer, %entry ], [ %10, %vector.body ]
  %0 = getelementptr inbounds [1024 x i8], [1024 x i8]* @a, i64 0, i64 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 4
  %2 = zext <16 x i8> %wide.load to <16 x i32>
  %3 = getelementptr inbounds [1024 x i8], [1024 x i8]* @b, i64 0, i64 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load1 = load <16 x i8>, <16 x i8>* %4, align 4
  %5 = zext <16 x i8> %wide.load1 to <16 x i32>
  %6 = sub nsw <16 x i32> %2, %5
  %7 = icmp sgt <16 x i32> %6, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %8 = sub nsw <16 x i32> zeroinitializer, %6
  %9 = select <16 x i1> %7, <16 x i32> %6, <16 x i32> %8
  %10 = add nsw <16 x i32> %9, %vec.phi
  %index.next = add i64 %index, 4
  %11 = icmp eq i64 %index.next, 1024
  br i1 %11, label %middle.block, label %vector.body

middle.block:
  %.lcssa = phi <16 x i32> [ %10, %vector.body ]
  %rdx.shuf = shufflevector <16 x i32> %.lcssa, <16 x i32> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <16 x i32> %.lcssa, %rdx.shuf
  %rdx.shuf2 = shufflevector <16 x i32> %bin.rdx, <16 x i32> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx2 = add <16 x i32> %bin.rdx, %rdx.shuf2
  %rdx.shuf3 = shufflevector <16 x i32> %bin.rdx2, <16 x i32> undef, <16 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx3 = add <16 x i32> %bin.rdx2, %rdx.shuf3
  %rdx.shuf4 = shufflevector <16 x i32> %bin.rdx3, <16 x i32> undef, <16 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx4 = add <16 x i32> %bin.rdx3, %rdx.shuf4
  %12 = extractelement <16 x i32> %bin.rdx4, i32 0
  ret i32 %12
}

define void @sbto16f32_256(<16 x i16> %a, <16 x float>* %res) "min-legal-vector-width"="256" {
; CHECK-LABEL: sbto16f32_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    kshiftrw $8, %k0, %k1
; CHECK-NEXT:    vpmovm2d %k1, %ymm0
; CHECK-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-NEXT:    vpmovm2d %k0, %ymm1
; CHECK-NEXT:    vcvtdq2ps %ymm1, %ymm1
; CHECK-NEXT:    vmovaps %ymm1, (%rdi)
; CHECK-NEXT:    vmovaps %ymm0, 32(%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = sitofp <16 x i1> %mask to <16 x float>
  store <16 x float> %1, <16 x float>* %res
  ret void
}

define void @sbto16f32_512(<16 x i16> %a, <16 x float>* %res) "min-legal-vector-width"="512" {
; CHECK-LABEL: sbto16f32_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    vpmovm2d %k0, %zmm0
; CHECK-NEXT:    vcvtdq2ps %zmm0, %zmm0
; CHECK-NEXT:    vmovaps %zmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = sitofp <16 x i1> %mask to <16 x float>
  store <16 x float> %1, <16 x float>* %res
  ret void
}

define void @sbto16f64_256(<16 x i16> %a, <16 x double>* %res)  "min-legal-vector-width"="256" {
; CHECK-LABEL: sbto16f64_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    kshiftrw $8, %k0, %k1
; CHECK-NEXT:    vpmovm2d %k1, %ymm0
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm1
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm0
; CHECK-NEXT:    vpmovm2d %k0, %ymm2
; CHECK-NEXT:    vcvtdq2pd %xmm2, %ymm3
; CHECK-NEXT:    vextracti128 $1, %ymm2, %xmm2
; CHECK-NEXT:    vcvtdq2pd %xmm2, %ymm2
; CHECK-NEXT:    vmovaps %ymm2, 32(%rdi)
; CHECK-NEXT:    vmovaps %ymm3, (%rdi)
; CHECK-NEXT:    vmovaps %ymm0, 96(%rdi)
; CHECK-NEXT:    vmovaps %ymm1, 64(%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = sitofp <16 x i1> %mask to <16 x double>
  store <16 x double> %1, <16 x double>* %res
  ret void
}

define void @sbto16f64_512(<16 x i16> %a, <16 x double>* %res)  "min-legal-vector-width"="512" {
; CHECK-LABEL: sbto16f64_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    vpmovm2d %k0, %zmm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm1
; CHECK-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm0
; CHECK-NEXT:    vmovaps %zmm0, 64(%rdi)
; CHECK-NEXT:    vmovaps %zmm1, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = sitofp <16 x i1> %mask to <16 x double>
  store <16 x double> %1, <16 x double>* %res
  ret void
}

define void @ubto16f32_256(<16 x i16> %a, <16 x float>* %res) "min-legal-vector-width"="256" {
; CHECK-LABEL: ubto16f32_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    kshiftrw $8, %k0, %k1
; CHECK-NEXT:    vpmovm2d %k1, %ymm0
; CHECK-NEXT:    vpsrld $31, %ymm0, %ymm0
; CHECK-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-NEXT:    vpmovm2d %k0, %ymm1
; CHECK-NEXT:    vpsrld $31, %ymm1, %ymm1
; CHECK-NEXT:    vcvtdq2ps %ymm1, %ymm1
; CHECK-NEXT:    vmovaps %ymm1, (%rdi)
; CHECK-NEXT:    vmovaps %ymm0, 32(%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = uitofp <16 x i1> %mask to <16 x float>
  store <16 x float> %1, <16 x float>* %res
  ret void
}

define void @ubto16f32_512(<16 x i16> %a, <16 x float>* %res) "min-legal-vector-width"="512" {
; CHECK-LABEL: ubto16f32_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    vpmovm2d %k0, %zmm0
; CHECK-NEXT:    vpsrld $31, %zmm0, %zmm0
; CHECK-NEXT:    vcvtdq2ps %zmm0, %zmm0
; CHECK-NEXT:    vmovaps %zmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = uitofp <16 x i1> %mask to <16 x float>
  store <16 x float> %1, <16 x float>* %res
  ret void
}

define void @ubto16f64_256(<16 x i16> %a, <16 x double>* %res) "min-legal-vector-width"="256" {
; CHECK-LABEL: ubto16f64_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    kshiftrw $8, %k0, %k1
; CHECK-NEXT:    vpmovm2d %k1, %ymm0
; CHECK-NEXT:    vpsrld $31, %ymm0, %ymm0
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm1
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm0
; CHECK-NEXT:    vpmovm2d %k0, %ymm2
; CHECK-NEXT:    vpsrld $31, %ymm2, %ymm2
; CHECK-NEXT:    vcvtdq2pd %xmm2, %ymm3
; CHECK-NEXT:    vextracti128 $1, %ymm2, %xmm2
; CHECK-NEXT:    vcvtdq2pd %xmm2, %ymm2
; CHECK-NEXT:    vmovaps %ymm2, 32(%rdi)
; CHECK-NEXT:    vmovaps %ymm3, (%rdi)
; CHECK-NEXT:    vmovaps %ymm0, 96(%rdi)
; CHECK-NEXT:    vmovaps %ymm1, 64(%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = uitofp <16 x i1> %mask to <16 x double>
  store <16 x double> %1, <16 x double>* %res
  ret void
}

define void @ubto16f64_512(<16 x i16> %a, <16 x double>* %res) "min-legal-vector-width"="512" {
; CHECK-LABEL: ubto16f64_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovw2m %ymm0, %k0
; CHECK-NEXT:    vpmovm2d %k0, %zmm0
; CHECK-NEXT:    vpsrld $31, %zmm0, %zmm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm1
; CHECK-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm0
; CHECK-NEXT:    vmovaps %zmm0, 64(%rdi)
; CHECK-NEXT:    vmovaps %zmm1, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %mask = icmp slt <16 x i16> %a, zeroinitializer
  %1 = uitofp <16 x i1> %mask to <16 x double>
  store <16 x double> %1, <16 x double>* %res
  ret void
}

define <16 x i16> @test_16f32toub_256(<16 x float>* %ptr, <16 x i16> %passthru) "min-legal-vector-width"="256" {
; CHECK-LABEL: test_16f32toub_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq (%rdi), %ymm1
; CHECK-NEXT:    vpslld $31, %ymm1, %ymm1
; CHECK-NEXT:    vpmovd2m %ymm1, %k0
; CHECK-NEXT:    vcvttps2dq 32(%rdi), %ymm1
; CHECK-NEXT:    vpslld $31, %ymm1, %ymm1
; CHECK-NEXT:    vpmovd2m %ymm1, %k1
; CHECK-NEXT:    kunpckbw %k0, %k1, %k1
; CHECK-NEXT:    vmovdqu16 %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %a = load <16 x float>, <16 x float>* %ptr
  %mask = fptoui <16 x float> %a to <16 x i1>
  %select = select <16 x i1> %mask, <16 x i16> %passthru, <16 x i16> zeroinitializer
  ret <16 x i16> %select
}

define <16 x i16> @test_16f32toub_512(<16 x float>* %ptr, <16 x i16> %passthru) "min-legal-vector-width"="512" {
; CHECK-LABEL: test_16f32toub_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq (%rdi), %zmm1
; CHECK-NEXT:    vpslld $31, %zmm1, %zmm1
; CHECK-NEXT:    vpmovd2m %zmm1, %k1
; CHECK-NEXT:    vmovdqu16 %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %a = load <16 x float>, <16 x float>* %ptr
  %mask = fptoui <16 x float> %a to <16 x i1>
  %select = select <16 x i1> %mask, <16 x i16> %passthru, <16 x i16> zeroinitializer
  ret <16 x i16> %select
}

define <16 x i16> @test_16f32tosb_256(<16 x float>* %ptr, <16 x i16> %passthru) "min-legal-vector-width"="256" {
; CHECK-LABEL: test_16f32tosb_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq (%rdi), %ymm1
; CHECK-NEXT:    vpmovd2m %ymm1, %k0
; CHECK-NEXT:    vcvttps2dq 32(%rdi), %ymm1
; CHECK-NEXT:    vpmovd2m %ymm1, %k1
; CHECK-NEXT:    kunpckbw %k0, %k1, %k1
; CHECK-NEXT:    vmovdqu16 %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %a = load <16 x float>, <16 x float>* %ptr
  %mask = fptosi <16 x float> %a to <16 x i1>
  %select = select <16 x i1> %mask, <16 x i16> %passthru, <16 x i16> zeroinitializer
  ret <16 x i16> %select
}

define <16 x i16> @test_16f32tosb_512(<16 x float>* %ptr, <16 x i16> %passthru) "min-legal-vector-width"="512" {
; CHECK-LABEL: test_16f32tosb_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq (%rdi), %zmm1
; CHECK-NEXT:    vpmovd2m %zmm1, %k1
; CHECK-NEXT:    vmovdqu16 %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %a = load <16 x float>, <16 x float>* %ptr
  %mask = fptosi <16 x float> %a to <16 x i1>
  %select = select <16 x i1> %mask, <16 x i16> %passthru, <16 x i16> zeroinitializer
  ret <16 x i16> %select
}

define void @mul256(<64 x i8>* %a, <64 x i8>* %b, <64 x i8>* %c) "min-legal-vector-width"="256" {
; CHECK-LABEL: mul256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa (%rdi), %ymm0
; CHECK-NEXT:    vmovdqa 32(%rdi), %ymm1
; CHECK-NEXT:    vmovdqa (%rsi), %ymm2
; CHECK-NEXT:    vmovdqa 32(%rsi), %ymm3
; CHECK-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15],ymm2[24],ymm0[24],ymm2[25],ymm0[25],ymm2[26],ymm0[26],ymm2[27],ymm0[27],ymm2[28],ymm0[28],ymm2[29],ymm0[29],ymm2[30],ymm0[30],ymm2[31],ymm0[31]
; CHECK-NEXT:    vpunpckhbw {{.*#+}} ymm5 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; CHECK-NEXT:    vpmullw %ymm4, %ymm5, %ymm4
; CHECK-NEXT:    vmovdqa {{.*#+}} ymm5 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; CHECK-NEXT:    vpand %ymm5, %ymm4, %ymm4
; CHECK-NEXT:    vpunpcklbw {{.*#+}} ymm2 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[16],ymm0[16],ymm2[17],ymm0[17],ymm2[18],ymm0[18],ymm2[19],ymm0[19],ymm2[20],ymm0[20],ymm2[21],ymm0[21],ymm2[22],ymm0[22],ymm2[23],ymm0[23]
; CHECK-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; CHECK-NEXT:    vpmullw %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpand %ymm5, %ymm0, %ymm0
; CHECK-NEXT:    vpackuswb %ymm4, %ymm0, %ymm0
; CHECK-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm3[8],ymm0[8],ymm3[9],ymm0[9],ymm3[10],ymm0[10],ymm3[11],ymm0[11],ymm3[12],ymm0[12],ymm3[13],ymm0[13],ymm3[14],ymm0[14],ymm3[15],ymm0[15],ymm3[24],ymm0[24],ymm3[25],ymm0[25],ymm3[26],ymm0[26],ymm3[27],ymm0[27],ymm3[28],ymm0[28],ymm3[29],ymm0[29],ymm3[30],ymm0[30],ymm3[31],ymm0[31]
; CHECK-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm1[8],ymm0[8],ymm1[9],ymm0[9],ymm1[10],ymm0[10],ymm1[11],ymm0[11],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15],ymm1[24],ymm0[24],ymm1[25],ymm0[25],ymm1[26],ymm0[26],ymm1[27],ymm0[27],ymm1[28],ymm0[28],ymm1[29],ymm0[29],ymm1[30],ymm0[30],ymm1[31],ymm0[31]
; CHECK-NEXT:    vpmullw %ymm2, %ymm4, %ymm2
; CHECK-NEXT:    vpand %ymm5, %ymm2, %ymm2
; CHECK-NEXT:    vpunpcklbw {{.*#+}} ymm3 = ymm3[0],ymm0[0],ymm3[1],ymm0[1],ymm3[2],ymm0[2],ymm3[3],ymm0[3],ymm3[4],ymm0[4],ymm3[5],ymm0[5],ymm3[6],ymm0[6],ymm3[7],ymm0[7],ymm3[16],ymm0[16],ymm3[17],ymm0[17],ymm3[18],ymm0[18],ymm3[19],ymm0[19],ymm3[20],ymm0[20],ymm3[21],ymm0[21],ymm3[22],ymm0[22],ymm3[23],ymm0[23]
; CHECK-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm1[0],ymm0[0],ymm1[1],ymm0[1],ymm1[2],ymm0[2],ymm1[3],ymm0[3],ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[16],ymm0[16],ymm1[17],ymm0[17],ymm1[18],ymm0[18],ymm1[19],ymm0[19],ymm1[20],ymm0[20],ymm1[21],ymm0[21],ymm1[22],ymm0[22],ymm1[23],ymm0[23]
; CHECK-NEXT:    vpmullw %ymm3, %ymm1, %ymm1
; CHECK-NEXT:    vpand %ymm5, %ymm1, %ymm1
; CHECK-NEXT:    vpackuswb %ymm2, %ymm1, %ymm1
; CHECK-NEXT:    vmovdqa %ymm1, 32(%rdx)
; CHECK-NEXT:    vmovdqa %ymm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %d = load <64 x i8>, <64 x i8>* %a
  %e = load <64 x i8>, <64 x i8>* %b
  %f = mul <64 x i8> %d, %e
  store <64 x i8> %f, <64 x i8>* %c
  ret void
}

define void @mul512(<64 x i8>* %a, <64 x i8>* %b, <64 x i8>* %c) "min-legal-vector-width"="512" {
; CHECK-LABEL: mul512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 (%rdi), %zmm0
; CHECK-NEXT:    vmovdqa64 (%rsi), %zmm1
; CHECK-NEXT:    vpunpckhbw {{.*#+}} zmm2 = zmm1[8],zmm0[8],zmm1[9],zmm0[9],zmm1[10],zmm0[10],zmm1[11],zmm0[11],zmm1[12],zmm0[12],zmm1[13],zmm0[13],zmm1[14],zmm0[14],zmm1[15],zmm0[15],zmm1[24],zmm0[24],zmm1[25],zmm0[25],zmm1[26],zmm0[26],zmm1[27],zmm0[27],zmm1[28],zmm0[28],zmm1[29],zmm0[29],zmm1[30],zmm0[30],zmm1[31],zmm0[31],zmm1[40],zmm0[40],zmm1[41],zmm0[41],zmm1[42],zmm0[42],zmm1[43],zmm0[43],zmm1[44],zmm0[44],zmm1[45],zmm0[45],zmm1[46],zmm0[46],zmm1[47],zmm0[47],zmm1[56],zmm0[56],zmm1[57],zmm0[57],zmm1[58],zmm0[58],zmm1[59],zmm0[59],zmm1[60],zmm0[60],zmm1[61],zmm0[61],zmm1[62],zmm0[62],zmm1[63],zmm0[63]
; CHECK-NEXT:    vpunpckhbw {{.*#+}} zmm3 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; CHECK-NEXT:    vpmullw %zmm2, %zmm3, %zmm2
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; CHECK-NEXT:    vpandq %zmm3, %zmm2, %zmm2
; CHECK-NEXT:    vpunpcklbw {{.*#+}} zmm1 = zmm1[0],zmm0[0],zmm1[1],zmm0[1],zmm1[2],zmm0[2],zmm1[3],zmm0[3],zmm1[4],zmm0[4],zmm1[5],zmm0[5],zmm1[6],zmm0[6],zmm1[7],zmm0[7],zmm1[16],zmm0[16],zmm1[17],zmm0[17],zmm1[18],zmm0[18],zmm1[19],zmm0[19],zmm1[20],zmm0[20],zmm1[21],zmm0[21],zmm1[22],zmm0[22],zmm1[23],zmm0[23],zmm1[32],zmm0[32],zmm1[33],zmm0[33],zmm1[34],zmm0[34],zmm1[35],zmm0[35],zmm1[36],zmm0[36],zmm1[37],zmm0[37],zmm1[38],zmm0[38],zmm1[39],zmm0[39],zmm1[48],zmm0[48],zmm1[49],zmm0[49],zmm1[50],zmm0[50],zmm1[51],zmm0[51],zmm1[52],zmm0[52],zmm1[53],zmm0[53],zmm1[54],zmm0[54],zmm1[55],zmm0[55]
; CHECK-NEXT:    vpunpcklbw {{.*#+}} zmm0 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; CHECK-NEXT:    vpmullw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpandq %zmm3, %zmm0, %zmm0
; CHECK-NEXT:    vpackuswb %zmm2, %zmm0, %zmm0
; CHECK-NEXT:    vmovdqa64 %zmm0, (%rdx)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %d = load <64 x i8>, <64 x i8>* %a
  %e = load <64 x i8>, <64 x i8>* %b
  %f = mul <64 x i8> %d, %e
  store <64 x i8> %f, <64 x i8>* %c
  ret void
}
