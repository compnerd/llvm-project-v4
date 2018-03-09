; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512VL

define <4 x double> @test_x86_avx_vzeroall(<4 x double> %a, <4 x double> %b) {
; AVX-LABEL: test_x86_avx_vzeroall:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovupd %ymm0, -{{[0-9]+}}(%rsp) # 32-byte Spill
; AVX-NEXT:    vzeroall
; AVX-NEXT:    vmovups -{{[0-9]+}}(%rsp), %ymm0 # 32-byte Reload
; AVX-NEXT:    ret{{[l|q]}}
;
; AVX512VL-LABEL: test_x86_avx_vzeroall:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vaddpd %ymm1, %ymm0, %ymm16
; AVX512VL-NEXT:    vzeroall
; AVX512VL-NEXT:    vmovapd %ymm16, %ymm0
; AVX512VL-NEXT:    ret{{[l|q]}}
  %c = fadd <4 x double> %a, %b
  call void @llvm.x86.avx.vzeroall()
  ret <4 x double> %c
}
declare void @llvm.x86.avx.vzeroall() nounwind

define <4 x double> @test_x86_avx_vzeroupper(<4 x double> %a, <4 x double> %b) {
; AVX-LABEL: test_x86_avx_vzeroupper:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovupd %ymm0, -{{[0-9]+}}(%rsp) # 32-byte Spill
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    vmovups -{{[0-9]+}}(%rsp), %ymm0 # 32-byte Reload
; AVX-NEXT:    ret{{[l|q]}}
;
; AVX512VL-LABEL: test_x86_avx_vzeroupper:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vaddpd %ymm1, %ymm0, %ymm16
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    vmovapd %ymm16, %ymm0
; AVX512VL-NEXT:    ret{{[l|q]}}
  %c = fadd <4 x double> %a, %b
  call void @llvm.x86.avx.vzeroupper()
  ret <4 x double> %c
}
declare void @llvm.x86.avx.vzeroupper() nounwind
