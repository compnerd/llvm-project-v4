; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512vl,+avx512vbmi2 | FileCheck %s

define <16 x i16> @test_compress_w_256(<16 x i16> %src, <16 x i16> %data, i16 %mask) {
; CHECK-LABEL: test_compress_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpcompressw %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512.mask.compress.w.256(<16 x i16> %data, <16 x i16> %src, i16 %mask)
  ret <16 x i16> %res
}
declare <16 x i16> @llvm.x86.avx512.mask.compress.w.256(<16 x i16>, <16 x i16>, i16)

define <8 x i16> @test_compress_w_128(<8 x i16> %data, i8 %mask) {
; CHECK-LABEL: test_compress_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpcompressw %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512.mask.compress.w.128(<8 x i16> %data, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.avx512.mask.compress.w.128(<8 x i16>, <8 x i16>, i8)

define <32 x i8> @test_compress_b_256(<32 x i8> %src, <32 x i8> %data, i32 %mask) {
; CHECK-LABEL: test_compress_b_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpcompressb %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <32 x i8> @llvm.x86.avx512.mask.compress.b.256(<32 x i8> %data, <32 x i8> %src, i32 %mask)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.x86.avx512.mask.compress.b.256(<32 x i8>, <32 x i8>, i32)

define <16 x i8> @test_compress_b_128(<16 x i8> %data, i16 %mask) {
; CHECK-LABEL: test_compress_b_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpcompressb %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.avx512.mask.compress.b.128(<16 x i8> %data, <16 x i8> zeroinitializer, i16 %mask)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.avx512.mask.compress.b.128(<16 x i8>, <16 x i8>, i16)

define <32 x i8> @test_expand_b_256(<32 x i8> %data, <32 x i8> %src, i32 %mask) {
; CHECK-LABEL: test_expand_b_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpexpandb %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovdqa %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <32 x i8> @llvm.x86.avx512.mask.expand.b.256( <32 x i8> %data, <32 x i8> %src, i32 %mask)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.x86.avx512.mask.expand.b.256(<32 x i8>, <32 x i8>, i32)

define <16 x i8> @test_expand_b_128(<16 x i8> %data, i16 %mask) {
; CHECK-LABEL: test_expand_b_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpexpandb %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.avx512.mask.expand.b.128(<16 x i8> %data, <16 x i8> zeroinitializer, i16 %mask)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.avx512.mask.expand.b.128(<16 x i8>, <16 x i8>, i16)

define <16 x i16> @test_expand_w_256(<16 x i16> %data, <16 x i16> %src, i16 %mask) {
; CHECK-LABEL: test_expand_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpexpandw %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovdqa %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512.mask.expand.w.256( <16 x i16> %data, <16 x i16> %src, i16 %mask)
  ret <16 x i16> %res
}
declare <16 x i16> @llvm.x86.avx512.mask.expand.w.256(<16 x i16>, <16 x i16>, i16)

define <8 x i16> @test_expand_w_128(<8 x i16> %data, i8 %mask) {
; CHECK-LABEL: test_expand_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpexpandw %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512.mask.expand.w.128(<8 x i16> %data, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.avx512.mask.expand.w.128(<8 x i16>, <8 x i16>, i8)

define <16 x i16> @test_expand_load_w_256(i8* %addr, <16 x i16> %data, i16 %mask) {
; CHECK-LABEL: test_expand_load_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpexpandw (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512.mask.expand.load.w.256(i8* %addr, <16 x i16> %data, i16 %mask)
  ret <16 x i16> %res
}
declare <16 x i16> @llvm.x86.avx512.mask.expand.load.w.256(i8* %addr, <16 x i16> %data, i16 %mask)

define <8 x i16> @test_expand_load_w_128(i8* %addr, <8 x i16> %data, i8 %mask) {
; CHECK-LABEL: test_expand_load_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpexpandw (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512.mask.expand.load.w.128(i8* %addr, <8 x i16> %data, i8 %mask)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.avx512.mask.expand.load.w.128(i8* %addr, <8 x i16> %data, i8 %mask)

define void @test_compress_store_w_256(i8* %addr, <16 x i16> %data, i16 %mask) {
; CHECK-LABEL: test_compress_store_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpcompressw %ymm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.x86.avx512.mask.compress.store.w.256(i8* %addr, <16 x i16> %data, i16 %mask)
  ret void
}
declare void @llvm.x86.avx512.mask.compress.store.w.256(i8* %addr, <16 x i16> %data, i16 %mask)

define void @test_compress_store_w_128(i8* %addr, <8 x i16> %data, i8 %mask) {
; CHECK-LABEL: test_compress_store_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpcompressw %xmm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.x86.avx512.mask.compress.store.w.128(i8* %addr, <8 x i16> %data, i8 %mask)
  ret void
}
declare void @llvm.x86.avx512.mask.compress.store.w.128(i8* %addr, <8 x i16> %data, i8 %mask)

define <32 x i8> @test_expand_load_b_256(i8* %addr, <32 x i8> %data, i32 %mask) {
; CHECK-LABEL: test_expand_load_b_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpexpandb (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <32 x i8> @llvm.x86.avx512.mask.expand.load.b.256(i8* %addr, <32 x i8> %data, i32 %mask)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.x86.avx512.mask.expand.load.b.256(i8* %addr, <32 x i8> %data, i32 %mask)

define <16 x i8> @test_expand_load_b_128(i8* %addr, <16 x i8> %data, i16 %mask) {
; CHECK-LABEL: test_expand_load_b_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpexpandb (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.avx512.mask.expand.load.b.128(i8* %addr, <16 x i8> %data, i16 %mask)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.avx512.mask.expand.load.b.128(i8* %addr, <16 x i8> %data, i16 %mask)

define void @test_compress_store_b_256(i8* %addr, <32 x i8> %data, i32 %mask) {
; CHECK-LABEL: test_compress_store_b_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpcompressb %ymm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.x86.avx512.mask.compress.store.b.256(i8* %addr, <32 x i8> %data, i32 %mask)
  ret void
}
declare void @llvm.x86.avx512.mask.compress.store.b.256(i8* %addr, <32 x i8> %data, i32 %mask)

define void @test_compress_store_b_128(i8* %addr, <16 x i8> %data, i16 %mask) {
; CHECK-LABEL: test_compress_store_b_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpcompressb %xmm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
  call void @llvm.x86.avx512.mask.compress.store.b.128(i8* %addr, <16 x i8> %data, i16 %mask)
  ret void
}
declare void @llvm.x86.avx512.mask.compress.store.b.128(i8* %addr, <16 x i8> %data, i16 %mask)

define <4 x i32>@test_int_x86_avx512_mask_vpshld_d_128(<4 x i32> %x0, <4 x i32> %x1,<4 x i32> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_d_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldd $22, %xmm1, %xmm0, %xmm3 {%k1} {z}
; CHECK-NEXT:    vpshldd $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshldd $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    vpaddd %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx512.mask.vpshld.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> %x3, i8 %x4)
  %res1 = call <4 x i32> @llvm.x86.avx512.mask.vpshld.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> %x3, i8 -1)
  %res2 = call <4 x i32> @llvm.x86.avx512.mask.vpshld.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> zeroinitializer,i8 %x4)
  %res3 = add <4 x i32> %res, %res1
  %res4 = add <4 x i32> %res3, %res2
  ret <4 x i32> %res4
}
declare <4 x i32> @llvm.x86.avx512.mask.vpshld.d.128(<4 x i32>, <4 x i32>, i32, <4 x i32>, i8)

define <8 x i32>@test_int_x86_avx512_mask_vpshld_d_256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_d_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldd $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshldd $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx512.mask.vpshld.d.256(<8 x i32> %x0, <8 x i32> %x1, i32 22, <8 x i32> %x3, i8 %x4)
  %res1 = call <8 x i32> @llvm.x86.avx512.mask.vpshld.d.256(<8 x i32> %x0, <8 x i32> %x1, i32 22, <8 x i32> %x3, i8 -1)
  %res2 = add <8 x i32> %res, %res1
  ret <8 x i32> %res2
}
declare <8 x i32> @llvm.x86.avx512.mask.vpshld.d.256(<8 x i32>, <8 x i32>, i32, <8 x i32>, i8)

define <2 x i64>@test_int_x86_avx512_mask_vpshld_q_128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_q_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldq $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshldq $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.avx512.mask.vpshld.q.128(<2 x i64> %x0, <2 x i64> %x1, i32 22, <2 x i64> %x3, i8 %x4)
  %res1 = call <2 x i64> @llvm.x86.avx512.mask.vpshld.q.128(<2 x i64> %x0, <2 x i64> %x1, i32 22, <2 x i64> %x3, i8 -1)
  %res2 = add <2 x i64> %res, %res1
  ret <2 x i64> %res2
}
declare <2 x i64> @llvm.x86.avx512.mask.vpshld.q.128(<2 x i64>, <2 x i64>, i32, <2 x i64>, i8)

define <4 x i64>@test_int_x86_avx512_mask_vpshld_q_256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_q_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldq $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshldq $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddq %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x i64> @llvm.x86.avx512.mask.vpshld.q.256(<4 x i64> %x0, <4 x i64> %x1, i32 22, <4 x i64> %x3, i8 %x4)
  %res1 = call <4 x i64> @llvm.x86.avx512.mask.vpshld.q.256(<4 x i64> %x0, <4 x i64> %x1, i32 22, <4 x i64> %x3, i8 -1)
  %res2 = add <4 x i64> %res, %res1
  ret <4 x i64> %res2
}
declare <4 x i64> @llvm.x86.avx512.mask.vpshld.q.256(<4 x i64>, <4 x i64>, i32, <4 x i64>, i8)

define <8 x i16>@test_int_x86_avx512_mask_vpshld_w_128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldw $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshldw $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddw %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512.mask.vpshld.w.128(<8 x i16> %x0, <8 x i16> %x1, i32 22, <8 x i16> %x3, i8 %x4)
  %res1 = call <8 x i16> @llvm.x86.avx512.mask.vpshld.w.128(<8 x i16> %x0, <8 x i16> %x1, i32 22, <8 x i16> %x3, i8 -1)
  %res2 = add <8 x i16> %res, %res1
  ret <8 x i16> %res2
}
declare <8 x i16> @llvm.x86.avx512.mask.vpshld.w.128(<8 x i16>, <8 x i16>, i32, <8 x i16>, i8)

define <16 x i16>@test_int_x86_avx512_mask_vpshld_w_256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshld_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshldw $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshldw $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddw %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512.mask.vpshld.w.256(<16 x i16> %x0, <16 x i16> %x1, i32 22, <16 x i16> %x3, i16 %x4)
  %res1 = call <16 x i16> @llvm.x86.avx512.mask.vpshld.w.256(<16 x i16> %x0, <16 x i16> %x1, i32 22, <16 x i16> %x3, i16 -1)
  %res2 = add <16 x i16> %res, %res1
  ret <16 x i16> %res2
}
declare <16 x i16> @llvm.x86.avx512.mask.vpshld.w.256(<16 x i16>, <16 x i16>, i32, <16 x i16>, i16)

define <4 x i32>@test_int_x86_avx512_mask_vpshrd_d_128(<4 x i32> %x0, <4 x i32> %x1,<4 x i32> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_d_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdd $22, %xmm1, %xmm0, %xmm3 {%k1} {z}
; CHECK-NEXT:    vpshrdd $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshrdd $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    vpaddd %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx512.mask.vpshrd.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> %x3, i8 %x4)
  %res1 = call <4 x i32> @llvm.x86.avx512.mask.vpshrd.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> %x3, i8 -1)
  %res2 = call <4 x i32> @llvm.x86.avx512.mask.vpshrd.d.128(<4 x i32> %x0, <4 x i32> %x1, i32 22, <4 x i32> zeroinitializer,i8 %x4)
  %res3 = add <4 x i32> %res, %res1
  %res4 = add <4 x i32> %res3, %res2
  ret <4 x i32> %res4
}
declare <4 x i32> @llvm.x86.avx512.mask.vpshrd.d.128(<4 x i32>, <4 x i32>, i32, <4 x i32>, i8)

define <8 x i32>@test_int_x86_avx512_mask_vpshrd_d_256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_d_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdd $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshrdd $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx512.mask.vpshrd.d.256(<8 x i32> %x0, <8 x i32> %x1, i32 22, <8 x i32> %x3, i8 %x4)
  %res1 = call <8 x i32> @llvm.x86.avx512.mask.vpshrd.d.256(<8 x i32> %x0, <8 x i32> %x1, i32 22, <8 x i32> %x3, i8 -1)
  %res2 = add <8 x i32> %res, %res1
  ret <8 x i32> %res2
}
declare <8 x i32> @llvm.x86.avx512.mask.vpshrd.d.256(<8 x i32>, <8 x i32>, i32, <8 x i32>, i8)

define <2 x i64>@test_int_x86_avx512_mask_vpshrd_q_128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_q_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdq $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshrdq $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.avx512.mask.vpshrd.q.128(<2 x i64> %x0, <2 x i64> %x1, i32 22, <2 x i64> %x3, i8 %x4)
  %res1 = call <2 x i64> @llvm.x86.avx512.mask.vpshrd.q.128(<2 x i64> %x0, <2 x i64> %x1, i32 22, <2 x i64> %x3, i8 -1)
  %res2 = add <2 x i64> %res, %res1
  ret <2 x i64> %res2
}
declare <2 x i64> @llvm.x86.avx512.mask.vpshrd.q.128(<2 x i64>, <2 x i64>, i32, <2 x i64>, i8)

define <4 x i64>@test_int_x86_avx512_mask_vpshrd_q_256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_q_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdq $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshrdq $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddq %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x i64> @llvm.x86.avx512.mask.vpshrd.q.256(<4 x i64> %x0, <4 x i64> %x1, i32 22, <4 x i64> %x3, i8 %x4)
  %res1 = call <4 x i64> @llvm.x86.avx512.mask.vpshrd.q.256(<4 x i64> %x0, <4 x i64> %x1, i32 22, <4 x i64> %x3, i8 -1)
  %res2 = add <4 x i64> %res, %res1
  ret <4 x i64> %res2
}
declare <4 x i64> @llvm.x86.avx512.mask.vpshrd.q.256(<4 x i64>, <4 x i64>, i32, <4 x i64>, i8)

define <8 x i16>@test_int_x86_avx512_mask_vpshrd_w_128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdw $22, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vpshrdw $22, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddw %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512.mask.vpshrd.w.128(<8 x i16> %x0, <8 x i16> %x1, i32 22, <8 x i16> %x3, i8 %x4)
  %res1 = call <8 x i16> @llvm.x86.avx512.mask.vpshrd.w.128(<8 x i16> %x0, <8 x i16> %x1, i32 22, <8 x i16> %x3, i8 -1)
  %res2 = add <8 x i16> %res, %res1
  ret <8 x i16> %res2
}
declare <8 x i16> @llvm.x86.avx512.mask.vpshrd.w.128(<8 x i16>, <8 x i16>, i32, <8 x i16>, i8)

define <16 x i16>@test_int_x86_avx512_mask_vpshrd_w_256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrd_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshrdw $22, %ymm1, %ymm0, %ymm2 {%k1}
; CHECK-NEXT:    vpshrdw $22, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpaddw %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512.mask.vpshrd.w.256(<16 x i16> %x0, <16 x i16> %x1, i32 22, <16 x i16> %x3, i16 %x4)
  %res1 = call <16 x i16> @llvm.x86.avx512.mask.vpshrd.w.256(<16 x i16> %x0, <16 x i16> %x1, i32 22, <16 x i16> %x3, i16 -1)
  %res2 = add <16 x i16> %res, %res1
  ret <16 x i16> %res2
}
declare <16 x i16> @llvm.x86.avx512.mask.vpshrd.w.256(<16 x i16>, <16 x i16>, i32, <16 x i16>, i16)

declare <8 x i32> @llvm.x86.avx512.mask.vpshrdv.d.256(<8 x i32>, <8 x i32>, <8 x i32>, i8)
declare <8 x i32> @llvm.x86.avx512.maskz.vpshrdv.d.256(<8 x i32>, <8 x i32>, <8 x i32>, i8)

define <8 x i32>@test_int_x86_avx512_mask_vpshrdv_d_256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32>* %x2p, <8 x i32> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_d_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshrdvd (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshrdvd %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshrdvd %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <8 x i32>, <8 x i32>* %x2p
  %res = call <8 x i32> @llvm.x86.avx512.mask.vpshrdv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2, i8 %x3)
  %res1 = call <8 x i32> @llvm.x86.avx512.mask.vpshrdv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4, i8 -1)
  %res2 = call <8 x i32> @llvm.x86.avx512.maskz.vpshrdv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4, i8  %x3)
  %res3 = add <8 x i32> %res, %res1
  %res4 = add <8 x i32> %res2, %res3
  ret <8 x i32> %res4
}

declare <4 x i32> @llvm.x86.avx512.mask.vpshrdv.d.128(<4 x i32>, <4 x i32>, <4 x i32>, i8)
declare <4 x i32> @llvm.x86.avx512.maskz.vpshrdv.d.128(<4 x i32>, <4 x i32>, <4 x i32>, i8)

define <4 x i32>@test_int_x86_avx512_mask_vpshrdv_d_128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32>* %x2p, <4 x i32> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_d_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshrdvd (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshrdvd %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshrdvd %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <4 x i32>, <4 x i32>* %x2p
  %res = call <4 x i32> @llvm.x86.avx512.mask.vpshrdv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2, i8 %x3)
  %res1 = call <4 x i32> @llvm.x86.avx512.mask.vpshrdv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4, i8 -1)
  %res2 = call <4 x i32> @llvm.x86.avx512.maskz.vpshrdv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4, i8  %x3)
  %res3 = add <4 x i32> %res, %res1
  %res4 = add <4 x i32> %res2, %res3
  ret <4 x i32> %res4
}

declare <4 x i64> @llvm.x86.avx512.mask.vpshrdv.q.256(<4 x i64>, <4 x i64>, <4 x i64>, i8)
declare <4 x i64> @llvm.x86.avx512.maskz.vpshrdv.q.256(<4 x i64>, <4 x i64>, <4 x i64>, i8)

define <4 x i64>@test_int_x86_avx512_mask_vpshrdv_q_256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64>* %x2p, <4 x i64> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_q_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshrdvq (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshrdvq %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshrdvq %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddq %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <4 x i64>, <4 x i64>* %x2p
  %res = call <4 x i64> @llvm.x86.avx512.mask.vpshrdv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x2, i8 %x3)
  %res1 = call <4 x i64> @llvm.x86.avx512.mask.vpshrdv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x4, i8 -1)
  %res2 = call <4 x i64> @llvm.x86.avx512.maskz.vpshrdv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x4, i8  %x3)
  %res3 = add <4 x i64> %res, %res1
  %res4 = add <4 x i64> %res2, %res3
  ret <4 x i64> %res4
}

declare <2 x i64> @llvm.x86.avx512.mask.vpshrdv.q.128(<2 x i64>, <2 x i64>, <2 x i64>, i8)
declare <2 x i64> @llvm.x86.avx512.maskz.vpshrdv.q.128(<2 x i64>, <2 x i64>, <2 x i64>, i8)

define <2 x i64>@test_int_x86_avx512_mask_vpshrdv_q_128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64>* %x2p, <2 x i64> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_q_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshrdvq (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshrdvq %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshrdvq %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddq %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <2 x i64>, <2 x i64>* %x2p
  %res = call <2 x i64> @llvm.x86.avx512.mask.vpshrdv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x2, i8 %x3)
  %res1 = call <2 x i64> @llvm.x86.avx512.mask.vpshrdv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x4, i8 -1)
  %res2 = call <2 x i64> @llvm.x86.avx512.maskz.vpshrdv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x4, i8  %x3)
  %res3 = add <2 x i64> %res, %res1
  %res4 = add <2 x i64> %res2, %res3
  ret <2 x i64> %res4
}

declare <16 x i16> @llvm.x86.avx512.mask.vpshrdv.w.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)
declare <16 x i16> @llvm.x86.avx512.maskz.vpshrdv.w.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)

define <16 x i16>@test_int_x86_avx512_mask_vpshrdv_w_256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16>* %x2p, <16 x i16> %x4, i16 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshrdvw (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshrdvw %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshrdvw %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddw %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddw %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <16 x i16>, <16 x i16>* %x2p
  %res = call <16 x i16> @llvm.x86.avx512.mask.vpshrdv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x2, i16 %x3)
  %res1 = call <16 x i16> @llvm.x86.avx512.mask.vpshrdv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x4, i16 -1)
  %res2 = call <16 x i16> @llvm.x86.avx512.maskz.vpshrdv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x4, i16  %x3)
  %res3 = add <16 x i16> %res, %res1
  %res4 = add <16 x i16> %res2, %res3
  ret <16 x i16> %res4
}

declare <8 x i16> @llvm.x86.avx512.mask.vpshrdv.w.128(<8 x i16>, <8 x i16>, <8 x i16>, i8)
declare <8 x i16> @llvm.x86.avx512.maskz.vpshrdv.w.128(<8 x i16>, <8 x i16>, <8 x i16>, i8)

define <8 x i16>@test_int_x86_avx512_mask_vpshrdv_w_128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16>* %x2p, <8 x i16> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshrdv_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshrdvw (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshrdvw %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshrdvw %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddw %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddw %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <8 x i16>, <8 x i16>* %x2p
  %res = call <8 x i16> @llvm.x86.avx512.mask.vpshrdv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x2, i8 %x3)
  %res1 = call <8 x i16> @llvm.x86.avx512.mask.vpshrdv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x4, i8 -1)
  %res2 = call <8 x i16> @llvm.x86.avx512.maskz.vpshrdv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x4, i8  %x3)
  %res3 = add <8 x i16> %res, %res1
  %res4 = add <8 x i16> %res2, %res3
  ret <8 x i16> %res4
}

declare <8 x i32> @llvm.x86.avx512.mask.vpshldv.d.256(<8 x i32>, <8 x i32>, <8 x i32>, i8)
declare <8 x i32> @llvm.x86.avx512.maskz.vpshldv.d.256(<8 x i32>, <8 x i32>, <8 x i32>, i8)

define <8 x i32>@test_int_x86_avx512_mask_vpshldv_d_256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32>* %x2p, <8 x i32> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_d_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshldvd (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshldvd %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshldvd %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <8 x i32>, <8 x i32>* %x2p
  %res = call <8 x i32> @llvm.x86.avx512.mask.vpshldv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2, i8 %x3)
  %res1 = call <8 x i32> @llvm.x86.avx512.mask.vpshldv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4, i8 -1)
  %res2 = call <8 x i32> @llvm.x86.avx512.maskz.vpshldv.d.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4, i8  %x3)
  %res3 = add <8 x i32> %res, %res1
  %res4 = add <8 x i32> %res2, %res3
  ret <8 x i32> %res4
}

declare <4 x i32> @llvm.x86.avx512.mask.vpshldv.d.128(<4 x i32>, <4 x i32>, <4 x i32>, i8)
declare <4 x i32> @llvm.x86.avx512.maskz.vpshldv.d.128(<4 x i32>, <4 x i32>, <4 x i32>, i8)

define <4 x i32>@test_int_x86_avx512_mask_vpshldv_d_128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32>* %x2p, <4 x i32> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_d_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshldvd (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshldvd %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshldvd %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <4 x i32>, <4 x i32>* %x2p
  %res = call <4 x i32> @llvm.x86.avx512.mask.vpshldv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2, i8 %x3)
  %res1 = call <4 x i32> @llvm.x86.avx512.mask.vpshldv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4, i8 -1)
  %res2 = call <4 x i32> @llvm.x86.avx512.maskz.vpshldv.d.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4, i8  %x3)
  %res3 = add <4 x i32> %res, %res1
  %res4 = add <4 x i32> %res2, %res3
  ret <4 x i32> %res4
}

declare <4 x i64> @llvm.x86.avx512.mask.vpshldv.q.256(<4 x i64>, <4 x i64>, <4 x i64>, i8)
declare <4 x i64> @llvm.x86.avx512.maskz.vpshldv.q.256(<4 x i64>, <4 x i64>, <4 x i64>, i8)

define <4 x i64>@test_int_x86_avx512_mask_vpshldv_q_256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64>* %x2p, <4 x i64> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_q_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshldvq (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshldvq %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshldvq %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddq %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <4 x i64>, <4 x i64>* %x2p
  %res = call <4 x i64> @llvm.x86.avx512.mask.vpshldv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x2, i8 %x3)
  %res1 = call <4 x i64> @llvm.x86.avx512.mask.vpshldv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x4, i8 -1)
  %res2 = call <4 x i64> @llvm.x86.avx512.maskz.vpshldv.q.256(<4 x i64> %x0, <4 x i64> %x1, <4 x i64> %x4, i8  %x3)
  %res3 = add <4 x i64> %res, %res1
  %res4 = add <4 x i64> %res2, %res3
  ret <4 x i64> %res4
}

declare <2 x i64> @llvm.x86.avx512.mask.vpshldv.q.128(<2 x i64>, <2 x i64>, <2 x i64>, i8)
declare <2 x i64> @llvm.x86.avx512.maskz.vpshldv.q.128(<2 x i64>, <2 x i64>, <2 x i64>, i8)

define <2 x i64>@test_int_x86_avx512_mask_vpshldv_q_128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64>* %x2p, <2 x i64> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_q_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshldvq (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshldvq %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshldvq %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddq %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <2 x i64>, <2 x i64>* %x2p
  %res = call <2 x i64> @llvm.x86.avx512.mask.vpshldv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x2, i8 %x3)
  %res1 = call <2 x i64> @llvm.x86.avx512.mask.vpshldv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x4, i8 -1)
  %res2 = call <2 x i64> @llvm.x86.avx512.maskz.vpshldv.q.128(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %x4, i8  %x3)
  %res3 = add <2 x i64> %res, %res1
  %res4 = add <2 x i64> %res2, %res3
  ret <2 x i64> %res4
}

declare <16 x i16> @llvm.x86.avx512.mask.vpshldv.w.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)
declare <16 x i16> @llvm.x86.avx512.maskz.vpshldv.w.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)

define <16 x i16>@test_int_x86_avx512_mask_vpshldv_w_256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16>* %x2p, <16 x i16> %x4, i16 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_w_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %ymm0, %ymm3
; CHECK-NEXT:    vpshldvw (%rdi), %ymm1, %ymm3 {%k1}
; CHECK-NEXT:    vmovdqa %ymm0, %ymm4
; CHECK-NEXT:    vpshldvw %ymm2, %ymm1, %ymm4
; CHECK-NEXT:    vpshldvw %ymm2, %ymm1, %ymm0 {%k1} {z}
; CHECK-NEXT:    vpaddw %ymm0, %ymm4, %ymm0
; CHECK-NEXT:    vpaddw %ymm0, %ymm3, %ymm0
; CHECK-NEXT:    retq
  %x2 = load <16 x i16>, <16 x i16>* %x2p
  %res = call <16 x i16> @llvm.x86.avx512.mask.vpshldv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x2, i16 %x3)
  %res1 = call <16 x i16> @llvm.x86.avx512.mask.vpshldv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x4, i16 -1)
  %res2 = call <16 x i16> @llvm.x86.avx512.maskz.vpshldv.w.256(<16 x i16> %x0, <16 x i16> %x1, <16 x i16> %x4, i16  %x3)
  %res3 = add <16 x i16> %res, %res1
  %res4 = add <16 x i16> %res2, %res3
  ret <16 x i16> %res4
}

declare <8 x i16> @llvm.x86.avx512.mask.vpshldv.w.128(<8 x i16>, <8 x i16>, <8 x i16>, i8)
declare <8 x i16> @llvm.x86.avx512.maskz.vpshldv.w.128(<8 x i16>, <8 x i16>, <8 x i16>, i8)

define <8 x i16>@test_int_x86_avx512_mask_vpshldv_w_128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16>* %x2p, <8 x i16> %x4, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpshldv_w_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vmovdqa %xmm0, %xmm3
; CHECK-NEXT:    vpshldvw (%rdi), %xmm1, %xmm3 {%k1}
; CHECK-NEXT:    vmovdqa %xmm0, %xmm4
; CHECK-NEXT:    vpshldvw %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vpshldvw %xmm2, %xmm1, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddw %xmm0, %xmm4, %xmm0
; CHECK-NEXT:    vpaddw %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    retq
  %x2 = load <8 x i16>, <8 x i16>* %x2p
  %res = call <8 x i16> @llvm.x86.avx512.mask.vpshldv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x2, i8 %x3)
  %res1 = call <8 x i16> @llvm.x86.avx512.mask.vpshldv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x4, i8 -1)
  %res2 = call <8 x i16> @llvm.x86.avx512.maskz.vpshldv.w.128(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %x4, i8  %x3)
  %res3 = add <8 x i16> %res, %res1
  %res4 = add <8 x i16> %res2, %res3
  ret <8 x i16> %res4
}

