; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

define <2 x i16> @test_urem_unary_v2i16() nounwind {
; SSE-LABEL: test_urem_unary_v2i16:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_urem_unary_v2i16:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %I8 = insertelement <2 x i16> zeroinitializer, i16 -1, i32 0
  %I9 = insertelement <2 x i16> %I8, i16 -1, i32 1
  %B9 = urem <2 x i16> %I9, %I9
  ret <2 x i16> %B9
}

define <4 x i32> @PR20355(<4 x i32> %a) nounwind {
; SSE2-LABEL: PR20355:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [1431655766,1431655766,1431655766,1431655766]
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    psrad $31, %xmm3
; SSE2-NEXT:    pand %xmm1, %xmm3
; SSE2-NEXT:    paddd %xmm2, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm0[0],xmm4[1],xmm0[1]
; SSE2-NEXT:    psubd %xmm3, %xmm4
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    psrld $31, %xmm0
; SSE2-NEXT:    paddd %xmm4, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: PR20355:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [1431655766,1431655766,1431655766,1431655766]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pmuldq %xmm2, %xmm3
; SSE41-NEXT:    pmuldq %xmm1, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    movdqa %xmm1, %xmm0
; SSE41-NEXT:    psrld $31, %xmm0
; SSE41-NEXT:    paddd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: PR20355:
; AVX1:       # BB#0: # %entry
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [1431655766,1431655766,1431655766,1431655766]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuldq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmuldq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsrld $31, %xmm0, %xmm1
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR20355:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpmuldq %xmm2, %xmm3, %xmm2
; AVX2-NEXT:    vpmuldq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; AVX2-NEXT:    vpsrld $31, %xmm0, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
entry:
  %sdiv = sdiv <4 x i32> %a, <i32 3, i32 3, i32 3, i32 3>
  ret <4 x i32> %sdiv
}
