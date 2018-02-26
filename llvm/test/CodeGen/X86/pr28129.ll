; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s --check-prefix=X64

define <4 x double> @cmp4f64_domain(<4 x double> %a) {
; X86-LABEL: cmp4f64_domain:
; X86:       # %bb.0:
; X86-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X86-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: cmp4f64_domain:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X64-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X64-NEXT:    retq
  %cmp = fcmp oeq <4 x double> zeroinitializer, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i64>
  %mask = bitcast <4 x i64> %sext to <4 x double>
  %add = fadd <4 x double> %a, %mask
  ret <4 x double> %add
}

define <4 x double> @cmp4f64_domain_optsize(<4 x double> %a) optsize {
; X86-LABEL: cmp4f64_domain_optsize:
; X86:       # %bb.0:
; X86-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X86-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: cmp4f64_domain_optsize:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X64-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X64-NEXT:    retq
  %cmp = fcmp oeq <4 x double> zeroinitializer, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i64>
  %mask = bitcast <4 x i64> %sext to <4 x double>
  %add = fadd <4 x double> %a, %mask
  ret <4 x double> %add
}

define <8 x float> @cmp8f32_domain(<8 x float> %a) {
; X86-LABEL: cmp8f32_domain:
; X86:       # %bb.0:
; X86-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X86-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: cmp8f32_domain:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X64-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X64-NEXT:    retq
  %cmp = fcmp oeq <8 x float> zeroinitializer, zeroinitializer
  %sext = sext <8 x i1> %cmp to <8 x i32>
  %mask = bitcast <8 x i32> %sext to <8 x float>
  %add = fadd <8 x float> %a, %mask
  ret <8 x float> %add
}

define <8 x float> @cmp8f32_domain_optsize(<8 x float> %a) optsize {
; X86-LABEL: cmp8f32_domain_optsize:
; X86:       # %bb.0:
; X86-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X86-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: cmp8f32_domain_optsize:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; X64-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X64-NEXT:    retq
  %cmp = fcmp oeq <8 x float> zeroinitializer, zeroinitializer
  %sext = sext <8 x i1> %cmp to <8 x i32>
  %mask = bitcast <8 x i32> %sext to <8 x float>
  %add = fadd <8 x float> %a, %mask
  ret <8 x float> %add
}
