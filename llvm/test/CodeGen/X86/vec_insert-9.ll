; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64

define <4 x i32> @var_insert2(<4 x i32> %x, i32 %val, i32 %idx) nounwind  {
; X32-LABEL: var_insert2:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    pinsrd $3, {{[0-9]+}}(%esp), %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: var_insert2:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movd %edi, %xmm0
; X64-NEXT:    pinsrd $3, %esi, %xmm0
; X64-NEXT:    retq
entry:
  %tmp3 = insertelement <4 x i32> undef, i32 %val, i32 0
  %tmp4 = insertelement <4 x i32> %tmp3, i32 %idx, i32 3
  ret <4 x i32> %tmp4
}
