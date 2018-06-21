; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu -mattr=+avx512f,+vpclmulqdq -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+vpclmulqdq -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

define <8 x i64> @test_x86_pclmulqdq(<8 x i64> %a0, <8 x i64> %a1) {
; CHECK-LABEL: test_x86_pclmulqdq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpclmulqdq $1, %zmm1, %zmm0, %zmm0 # encoding: [0x62,0xf3,0x7d,0x48,0x44,0xc1,0x01]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %res = call <8 x i64> @llvm.x86.pclmulqdq.512(<8 x i64> %a0, <8 x i64> %a1, i8 1)
  ret <8 x i64> %res
}
declare <8 x i64> @llvm.x86.pclmulqdq.512(<8 x i64>, <8 x i64>, i8) nounwind readnone
