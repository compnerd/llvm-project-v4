; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mattr=avx512f -mtriple=x86_64-unknown | FileCheck %s

define <4 x float> @test_mm_mask_move_ss(<4 x float> %__W, i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: test_mm_mask_move_ss:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovss %xmm2, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %__U, 1
  %tobool.i = icmp ne i8 %0, 0
  %__B.elt.i = extractelement <4 x float> %__B, i32 0
  %__W.elt.i = extractelement <4 x float> %__W, i32 0
  %vecext1.i = select i1 %tobool.i, float %__B.elt.i, float %__W.elt.i
  %vecins.i = insertelement <4 x float> %__A, float %vecext1.i, i32 0
  ret <4 x float> %vecins.i
}

define <4 x float> @test_mm_maskz_move_ss(i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: test_mm_maskz_move_ss:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovss %xmm1, %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %__U, 1
  %tobool.i = icmp ne i8 %0, 0
  %vecext.i = extractelement <4 x float> %__B, i32 0
  %cond.i = select i1 %tobool.i, float %vecext.i, float 0.000000e+00
  %vecins.i = insertelement <4 x float> %__A, float %cond.i, i32 0
  ret <4 x float> %vecins.i
}

define <2 x double> @test_mm_mask_move_sd(<2 x double> %__W, i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: test_mm_mask_move_sd:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovsd %xmm2, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %__U, 1
  %tobool.i = icmp ne i8 %0, 0
  %__B.elt.i = extractelement <2 x double> %__B, i32 0
  %__W.elt.i = extractelement <2 x double> %__W, i32 0
  %vecext1.i = select i1 %tobool.i, double %__B.elt.i, double %__W.elt.i
  %vecins.i = insertelement <2 x double> %__A, double %vecext1.i, i32 0
  ret <2 x double> %vecins.i
}

define <2 x double> @test_mm_maskz_move_sd(i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: test_mm_maskz_move_sd:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovsd %xmm1, %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %__U, 1
  %tobool.i = icmp ne i8 %0, 0
  %vecext.i = extractelement <2 x double> %__B, i32 0
  %cond.i = select i1 %tobool.i, double %vecext.i, double 0.000000e+00
  %vecins.i = insertelement <2 x double> %__A, double %cond.i, i32 0
  ret <2 x double> %vecins.i
}

define void @test_mm_mask_store_ss(float* %__W, i8 zeroext %__U, <4 x float> %__A) local_unnamed_addr #1 {
; CHECK-LABEL: test_mm_mask_store_ss:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %esi, %k1
; CHECK-NEXT:    vmovss %xmm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
entry:
  %0 = bitcast float* %__W to <16 x float>*
  %shuffle.i.i = shufflevector <4 x float> %__A, <4 x float> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = and i8 %__U, 1
  %conv2.i = zext i8 %1 to i16
  %2 = bitcast i16 %conv2.i to <16 x i1>
  tail call void @llvm.masked.store.v16f32.p0v16f32(<16 x float> %shuffle.i.i, <16 x float>* %0, i32 16, <16 x i1> %2) #5
  ret void
}

define void @test_mm_mask_store_sd(double* %__W, i8 zeroext %__U, <2 x double> %__A) local_unnamed_addr #1 {
; CHECK-LABEL: test_mm_mask_store_sd:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %esi, %k1
; CHECK-NEXT:    vmovsd %xmm0, (%rdi) {%k1}
; CHECK-NEXT:    retq
entry:
  %0 = bitcast double* %__W to <8 x double>*
  %shuffle.i.i = shufflevector <2 x double> %__A, <2 x double> undef, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = and i8 %__U, 1
  %2 = bitcast i8 %1 to <8 x i1>
  tail call void @llvm.masked.store.v8f64.p0v8f64(<8 x double> %shuffle.i.i, <8 x double>* %0, i32 16, <8 x i1> %2) #5
  ret void
}

define <4 x float> @test_mm_mask_load_ss(<4 x float> %__A, i8 zeroext %__U, float* %__W) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm_mask_load_ss:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovss (%rsi), %xmm0 {%k1}
; CHECK-NEXT:    retq
entry:
  %shuffle.i = shufflevector <4 x float> %__A, <4 x float> <float 0.000000e+00, float undef, float undef, float undef>, <4 x i32> <i32 0, i32 4, i32 4, i32 4>
  %0 = bitcast float* %__W to <16 x float>*
  %shuffle.i.i = shufflevector <4 x float> %shuffle.i, <4 x float> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = and i8 %__U, 1
  %conv2.i = zext i8 %1 to i16
  %2 = bitcast i16 %conv2.i to <16 x i1>
  %3 = tail call <16 x float> @llvm.masked.load.v16f32.p0v16f32(<16 x float>* %0, i32 16, <16 x i1> %2, <16 x float> %shuffle.i.i) #5
  %shuffle4.i = shufflevector <16 x float> %3, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %shuffle4.i
}

define <2 x double> @test_mm_mask_load_sd(<2 x double> %__A, i8 zeroext %__U, double* %__W) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm_mask_load_sd:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovsd (%rsi), %xmm0 {%k1}
; CHECK-NEXT:    retq
entry:
  %shuffle5.i = insertelement <2 x double> %__A, double 0.000000e+00, i32 1
  %0 = bitcast double* %__W to <8 x double>*
  %shuffle.i.i = shufflevector <2 x double> %shuffle5.i, <2 x double> undef, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = and i8 %__U, 1
  %2 = bitcast i8 %1 to <8 x i1>
  %3 = tail call <8 x double> @llvm.masked.load.v8f64.p0v8f64(<8 x double>* %0, i32 16, <8 x i1> %2, <8 x double> %shuffle.i.i) #5
  %shuffle3.i = shufflevector <8 x double> %3, <8 x double> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x double> %shuffle3.i
}

define <4 x float> @test_mm_maskz_load_ss(i8 zeroext %__U, float* %__W) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm_maskz_load_ss:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovss (%rsi), %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
entry:
  %0 = bitcast float* %__W to <16 x float>*
  %1 = and i8 %__U, 1
  %conv2.i = zext i8 %1 to i16
  %2 = bitcast i16 %conv2.i to <16 x i1>
  %3 = tail call <16 x float> @llvm.masked.load.v16f32.p0v16f32(<16 x float>* %0, i32 16, <16 x i1> %2, <16 x float> zeroinitializer) #5
  %shuffle.i = shufflevector <16 x float> %3, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %shuffle.i
}

define <2 x double> @test_mm_maskz_load_sd(i8 zeroext %__U, double* %__W) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm_maskz_load_sd:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vmovsd (%rsi), %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
entry:
  %0 = bitcast double* %__W to <8 x double>*
  %1 = and i8 %__U, 1
  %2 = bitcast i8 %1 to <8 x i1>
  %3 = tail call <8 x double> @llvm.masked.load.v8f64.p0v8f64(<8 x double>* %0, i32 16, <8 x i1> %2, <8 x double> zeroinitializer) #5
  %shuffle.i = shufflevector <8 x double> %3, <8 x double> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x double> %shuffle.i
}

declare void @llvm.masked.store.v16f32.p0v16f32(<16 x float>, <16 x float>*, i32, <16 x i1>) #3

declare void @llvm.masked.store.v8f64.p0v8f64(<8 x double>, <8 x double>*, i32, <8 x i1>) #3

declare <16 x float> @llvm.masked.load.v16f32.p0v16f32(<16 x float>*, i32, <16 x i1>, <16 x float>) #4

declare <8 x double> @llvm.masked.load.v8f64.p0v8f64(<8 x double>*, i32, <8 x i1>, <8 x double>) #4
