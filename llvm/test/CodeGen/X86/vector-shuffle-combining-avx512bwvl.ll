; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefix=X64

declare <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)
declare <16 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.256(<16 x i16>, <16 x i16>, <16 x i16>, i16)

define <16 x i16> @combine_vpermt2var_16i16_identity(<16 x i16> %x0, <16 x i16> %x1) {
; X32-LABEL: combine_vpermt2var_16i16_identity:
; X32:       # %bb.0:
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_16i16_identity:
; X64:       # %bb.0:
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <16 x i16> %x0, <16 x i16> %x1, i16 -1)
  %res1 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 15, i16 30, i16 13, i16 28, i16 11, i16 26, i16 9, i16 24, i16 7, i16 22, i16 5, i16 20, i16 3, i16 18, i16 1, i16 16>, <16 x i16> %res0, <16 x i16> %res0, i16 -1)
  ret <16 x i16> %res1
}
define <16 x i16> @combine_vpermt2var_16i16_identity_mask(<16 x i16> %x0, <16 x i16> %x1, i16 %m) {
; X32-LABEL: combine_vpermt2var_16i16_identity_mask:
; X32:       # %bb.0:
; X32-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpermi2w %ymm1, %ymm0, %ymm2 {%k1} {z}
; X32-NEXT:    vmovdqa {{.*#+}} ymm0 = [15,30,13,28,11,26,9,24,7,22,5,20,3,18,1,16]
; X32-NEXT:    vpermi2w %ymm2, %ymm2, %ymm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_16i16_identity_mask:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpermi2w %ymm1, %ymm0, %ymm2 {%k1} {z}
; X64-NEXT:    vmovdqa {{.*#+}} ymm0 = [15,30,13,28,11,26,9,24,7,22,5,20,3,18,1,16]
; X64-NEXT:    vpermi2w %ymm2, %ymm2, %ymm0 {%k1} {z}
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <16 x i16> %x0, <16 x i16> %x1, i16 %m)
  %res1 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 15, i16 30, i16 13, i16 28, i16 11, i16 26, i16 9, i16 24, i16 7, i16 22, i16 5, i16 20, i16 3, i16 18, i16 1, i16 16>, <16 x i16> %res0, <16 x i16> %res0, i16 %m)
  ret <16 x i16> %res1
}

define <16 x i16> @combine_vpermi2var_16i16_as_permw(<16 x i16> %x0, <16 x i16> %x1) {
; X32-LABEL: combine_vpermi2var_16i16_as_permw:
; X32:       # %bb.0:
; X32-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,0,14,1,13,2,12,3,11,4,10,5,9,6,8,7]
; X32-NEXT:    vpermw %ymm0, %ymm1, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermi2var_16i16_as_permw:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,0,14,1,13,2,12,3,11,4,10,5,9,6,8,7]
; X64-NEXT:    vpermw %ymm0, %ymm1, %ymm0
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.256(<16 x i16> %x0, <16 x i16> <i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <16 x i16> %x1, i16 -1)
  %res1 = call <16 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.256(<16 x i16> %res0, <16 x i16> <i16 0, i16 15, i16 1, i16 14, i16 2, i16 13, i16 3, i16 12, i16 4, i16 11, i16 5, i16 10, i16 6, i16 9, i16 7, i16 8>, <16 x i16> %res0, i16 -1)
  ret <16 x i16> %res1
}

define <16 x i16> @combine_vpermt2var_vpermi2var_16i16_as_vperm2(<16 x i16> %x0, <16 x i16> %x1) {
; X32-LABEL: combine_vpermt2var_vpermi2var_16i16_as_vperm2:
; X32:       # %bb.0:
; X32-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,31,2,2,4,29,6,27,8,25,10,23,12,21,14,19]
; X32-NEXT:    vpermt2w %ymm1, %ymm2, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_vpermi2var_16i16_as_vperm2:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,31,2,2,4,29,6,27,8,25,10,23,12,21,14,19]
; X64-NEXT:    vpermt2w %ymm1, %ymm2, %ymm0
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.256(<16 x i16> %x0, <16 x i16> <i16 0, i16 31, i16 2, i16 29, i16 4, i16 27, i16 6, i16 25, i16 8, i16 23, i16 10, i16 21, i16 12, i16 19, i16 14, i16 17>, <16 x i16> %x1, i16 -1)
  %res1 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 0, i16 17, i16 2, i16 18, i16 4, i16 19, i16 6, i16 21, i16 8, i16 23, i16 10, i16 25, i16 12, i16 27, i16 14, i16 29>, <16 x i16> %res0, <16 x i16> %res0, i16 -1)
  ret <16 x i16> %res1
}

define <16 x i16> @combine_vpermt2var_vpermi2var_16i16_as_unpckhwd(<16 x i16> %a0, <16 x i16> %a1) {
; X32-LABEL: combine_vpermt2var_vpermi2var_16i16_as_unpckhwd:
; X32:       # %bb.0:
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm0 = ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15]
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_vpermi2var_16i16_as_unpckhwd:
; X64:       # %bb.0:
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm0 = ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15]
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.256(<16 x i16> %a0, <16 x i16> <i16 20, i16 4, i16 21, i16 5, i16 22, i16 6, i16 23, i16 7, i16 28, i16 12, i16 29, i16 13, i16 30, i16 14, i16 31, i16 15>, <16 x i16> %a1, i16 -1)
  ret <16 x i16> %res0
}

define <16 x i16> @combine_vpermt2var_vpermi2var_16i16_as_unpcklwd(<16 x i16> %a0, <16 x i16> %a1) {
; X32-LABEL: combine_vpermt2var_vpermi2var_16i16_as_unpcklwd:
; X32:       # %bb.0:
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11]
; X32-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_vpermi2var_16i16_as_unpcklwd:
; X64:       # %bb.0:
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11]
; X64-NEXT:    retq
  %res0 = call <16 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.256(<16 x i16> <i16 0, i16 16, i16 1, i16 17, i16 2, i16 18, i16 3, i16 19, i16 8, i16 24, i16 9, i16 25, i16 10, i16 26, i16 11, i16 27>, <16 x i16> %a0, <16 x i16> %a1, i16 -1)
  ret <16 x i16> %res0
}
