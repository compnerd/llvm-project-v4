; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefix=X32
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+sse4a,+avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefix=X64
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4a,+avx | FileCheck %s --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/sse4a-builtins.c

define <2 x i64> @test_mm_extracti_si64(<2 x i64> %x) {
; X32-LABEL: test_mm_extracti_si64:
; X32:       # BB#0:
; X32-NEXT:    extrq $2, $3, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_extracti_si64:
; X64:       # BB#0:
; X64-NEXT:    extrq $2, $3, %xmm0
; X64-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.sse4a.extrqi(<2 x i64> %x, i8 3, i8 2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.extrqi(<2 x i64>, i8, i8) nounwind readnone

define <2 x i64> @test_mm_extract_si64(<2 x i64> %x, <2 x i64> %y) {
; X32-LABEL: test_mm_extract_si64:
; X32:       # BB#0:
; X32-NEXT:    extrq %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_extract_si64:
; X64:       # BB#0:
; X64-NEXT:    extrq %xmm1, %xmm0
; X64-NEXT:    retq
  %bc = bitcast <2 x i64> %y to <16 x i8>
  %res = call <2 x i64> @llvm.x86.sse4a.extrq(<2 x i64> %x, <16 x i8> %bc)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.extrq(<2 x i64>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_inserti_si64(<2 x i64> %x, <2 x i64> %y) {
; X32-LABEL: test_mm_inserti_si64:
; X32:       # BB#0:
; X32-NEXT:    insertq $6, $5, %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_inserti_si64:
; X64:       # BB#0:
; X64-NEXT:    insertq $6, $5, %xmm1, %xmm0
; X64-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.sse4a.insertqi(<2 x i64> %x, <2 x i64> %y, i8 5, i8 6)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.insertqi(<2 x i64>, <2 x i64>, i8, i8) nounwind readnone

define <2 x i64> @test_mm_insert_si64(<2 x i64> %x, <2 x i64> %y) {
; X32-LABEL: test_mm_insert_si64:
; X32:       # BB#0:
; X32-NEXT:    insertq %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_insert_si64:
; X64:       # BB#0:
; X64-NEXT:    insertq %xmm1, %xmm0
; X64-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.sse4a.insertq(<2 x i64> %x, <2 x i64> %y)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.insertq(<2 x i64>, <2 x i64>) nounwind readnone

define void @test_stream_sd(double* %p, <2 x double> %a) {
; X32-LABEL: test_stream_sd:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movntsd %xmm0, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_stream_sd:
; X64:       # BB#0:
; X64-NEXT:    movntsd %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = extractelement <2 x double> %a, i64 0
  store double %1, double* %p, align 1, !nontemporal !1
  ret void
}

define void @test_mm_stream_ss(float* %p, <4 x float> %a) {
; X32-LABEL: test_mm_stream_ss:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movntss %xmm0, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_stream_ss:
; X64:       # BB#0:
; X64-NEXT:    movntss %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = extractelement <4 x float> %a, i64 0
  store float %1, float* %p, align 1, !nontemporal !1
  ret void
}

!1 = !{i32 1}
