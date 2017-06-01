; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; Verify that we don't emit packed vector shifts instructions if the
; condition used by the vector select is a vector of constants.

define <4 x float> @test1(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test1:
; SSE2:       # BB#0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[1,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test1:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # BB#0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test2(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test2:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test2:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # BB#0:
; AVX-NEXT:    vblendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test3(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test3:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test3:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test3:
; AVX:       # BB#0:
; AVX-NEXT:    vblendpd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test4(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test4:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test4:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test5(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test5:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test5:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test6(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test6:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test6:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false>, <8 x i16> %a, <8 x i16> %a
  ret <8 x i16> %1
}

define <8 x i16> @test7(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test7:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test7:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test7:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test7:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX2-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test8(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test8:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX2-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test9(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test9:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test9:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test10(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test10:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test10:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test11(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test11:
; SSE2:       # BB#0:
; SSE2-NEXT:    movaps {{.*#+}} xmm2 = [0,65535,65535,0,65535,65535,65535,65535]
; SSE2-NEXT:    andps %xmm2, %xmm0
; SSE2-NEXT:    andnps %xmm1, %xmm2
; SSE2-NEXT:    orps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test11:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test11:
; AVX:       # BB#0:
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3],xmm0[4,5,6,7]
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 true, i1 true, i1 false, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test12(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test12:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test12:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 undef, i1 false, i1 false, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test13(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test13:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test13:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllOnes), N1, N2) -> N1
define <4 x float> @test14(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test14:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test14:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 undef, i1 true, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test15(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test15:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test15:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 undef, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllZeros), N1, N2) -> N2
define <4 x float> @test16(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test16:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test16:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 undef, i1 false, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test17(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test17:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test17:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 undef, i1 undef, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <4 x float> @test18(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test18:
; SSE2:       # BB#0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test18:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test18:
; AVX:       # BB#0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test19(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test19:
; SSE2:       # BB#0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test19:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test19:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test19:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX2-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test20(<2 x double> %a, <2 x double> %b) {
; SSE2-LABEL: test20:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test20:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test20:
; AVX:       # BB#0:
; AVX-NEXT:    vblendpd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test21(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test21:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test21:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test21:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test21:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX2-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @test22(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test22:
; SSE2:       # BB#0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test22:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test22:
; AVX:       # BB#0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test23(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test23:
; SSE2:       # BB#0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test23:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3,4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test23:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test23:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX2-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test24(<2 x double> %a, <2 x double> %b) {
; SSE2-LABEL: test24:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test24:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test24:
; AVX:       # BB#0:
; AVX-NEXT:    vblendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test25(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test25:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test25:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test25:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test25:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX2-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @select_of_shuffles_0(<2 x float> %a0, <2 x float> %b0, <2 x float> %a1, <2 x float> %b1) {
; SSE-LABEL: select_of_shuffles_0:
; SSE:       # BB#0:
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: select_of_shuffles_0:
; AVX:       # BB#0:
; AVX-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX-NEXT:    vunpcklpd {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; AVX-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <2 x float> %a0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %2 = shufflevector <2 x float> %a1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %3 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %2, <4 x float> %1
  %4 = shufflevector <2 x float> %b0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %5 = shufflevector <2 x float> %b1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %6 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %5, <4 x float> %4
  %7 = fsub <4 x float> %3, %6
  ret <4 x float> %7
}

; PR20677
define <16 x double> @select_illegal(<16 x double> %a, <16 x double> %b) {
; SSE-LABEL: select_illegal:
; SSE:       # BB#0:
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm4
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm5
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm6
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm7
; SSE-NEXT:    movaps %xmm7, 112(%rdi)
; SSE-NEXT:    movaps %xmm6, 96(%rdi)
; SSE-NEXT:    movaps %xmm5, 80(%rdi)
; SSE-NEXT:    movaps %xmm4, 64(%rdi)
; SSE-NEXT:    movaps %xmm3, 48(%rdi)
; SSE-NEXT:    movaps %xmm2, 32(%rdi)
; SSE-NEXT:    movaps %xmm1, 16(%rdi)
; SSE-NEXT:    movaps %xmm0, (%rdi)
; SSE-NEXT:    movq %rdi, %rax
; SSE-NEXT:    retq
;
; AVX-LABEL: select_illegal:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %ymm6, %ymm2
; AVX-NEXT:    vmovaps %ymm7, %ymm3
; AVX-NEXT:    retq
  %sel = select <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x double> %a, <16 x double> %b
  ret <16 x double> %sel
}
