; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vp2intersect,+avx512vl --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vp2intersect,+avx512vl --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

define void @test_mm256_2intersect_epi32(<4 x i64> %a, <4 x i64> %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vp2intersectd %ymm1, %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x28,0x68,0xc1]
; X86-NEXT:    kmovw %k1, %ecx # encoding: [0xc5,0xf8,0x93,0xc9]
; X86-NEXT:    kmovw %k0, %edx # encoding: [0xc5,0xf8,0x93,0xd0]
; X86-NEXT:    movb %dl, (%eax) # encoding: [0x88,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vp2intersectd %ymm1, %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x28,0x68,0xc1]
; X64-NEXT:    kmovw %k1, %eax # encoding: [0xc5,0xf8,0x93,0xc1]
; X64-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X64-NEXT:    movb %cl, (%rdi) # encoding: [0x88,0x0f]
; X64-NEXT:    movb %al, (%rsi) # encoding: [0x88,0x06]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = bitcast <4 x i64> %a to <8 x i32>
  %1 = bitcast <4 x i64> %b to <8 x i32>
  %2 = tail call { <8 x i1>, <8 x i1> } @llvm.x86.avx512.vp2intersect.d.256(<8 x i32> %0, <8 x i32> %1)
  %3 = extractvalue { <8 x i1>, <8 x i1> } %2, 0
  %4 = bitcast i8* %m0 to <8 x i1>*
  store <8 x i1> %3, <8 x i1>* %4, align 8
  %5 = extractvalue { <8 x i1>, <8 x i1> } %2, 1
  %6 = bitcast i8* %m1 to <8 x i1>*
  store <8 x i1> %5, <8 x i1>* %6, align 8
  ret void
}

define void @test_mm256_2intersect_epi64(<4 x i64> %a, <4 x i64> %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X86-NEXT:    vp2intersectq %ymm1, %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x28,0x68,0xc1]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vp2intersectq %ymm1, %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x28,0x68,0xc1]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdi) # encoding: [0x88,0x07]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rsi) # encoding: [0x88,0x06]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.q.256(<4 x i64> %a, <4 x i64> %b)
  %1 = extractvalue { <4 x i1>, <4 x i1> } %0, 0
  %2 = shufflevector <4 x i1> %1, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %3 = bitcast <8 x i1> %2 to i8
  store i8 %3, i8* %m0, align 1
  %4 = extractvalue { <4 x i1>, <4 x i1> } %0, 1
  %5 = shufflevector <4 x i1> %4, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %6 = bitcast <8 x i1> %5 to i8
  store i8 %6, i8* %m1, align 1
  ret void
}

define void @test_mm256_2intersect_epi32_p(<4 x i64>* nocapture readonly %a, <4 x i64>* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi32_p:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x08]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x04]
; X86-NEXT:    vmovaps (%edx), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x02]
; X86-NEXT:    vp2intersectd (%ecx), %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x28,0x68,0x01]
; X86-NEXT:    kmovw %k1, %ecx # encoding: [0xc5,0xf8,0x93,0xc9]
; X86-NEXT:    kmovw %k0, %edx # encoding: [0xc5,0xf8,0x93,0xd0]
; X86-NEXT:    movb %dl, (%eax) # encoding: [0x88,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x10]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi32_p:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovaps (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; X64-NEXT:    vp2intersectd (%rsi), %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x28,0x68,0x06]
; X64-NEXT:    kmovw %k1, %eax # encoding: [0xc5,0xf8,0x93,0xc1]
; X64-NEXT:    kmovw %k0, %esi # encoding: [0xc5,0xf8,0x93,0xf0]
; X64-NEXT:    movb %sil, (%rdx) # encoding: [0x40,0x88,0x32]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = bitcast <4 x i64>* %a to <8 x i32>*
  %1 = load <8 x i32>, <8 x i32>* %0, align 32
  %2 = bitcast <4 x i64>* %b to <8 x i32>*
  %3 = load <8 x i32>, <8 x i32>* %2, align 32
  %4 = tail call { <8 x i1>, <8 x i1> } @llvm.x86.avx512.vp2intersect.d.256(<8 x i32> %1, <8 x i32> %3)
  %5 = extractvalue { <8 x i1>, <8 x i1> } %4, 0
  %6 = bitcast i8* %m0 to <8 x i1>*
  store <8 x i1> %5, <8 x i1>* %6, align 8
  %7 = extractvalue { <8 x i1>, <8 x i1> } %4, 1
  %8 = bitcast i8* %m1 to <8 x i1>*
  store <8 x i1> %7, <8 x i1>* %8, align 8
  ret void
}

define void @test_mm256_2intersect_epi64_p(<4 x i64>* nocapture readonly %a, <4 x i64>* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi64_p:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vmovaps (%esi), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x06]
; X86-NEXT:    vp2intersectq (%edx), %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x28,0x68,0x02]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi64_p:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovaps (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; X64-NEXT:    vp2intersectq (%rsi), %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x28,0x68,0x06]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load <4 x i64>, <4 x i64>* %a, align 32
  %1 = load <4 x i64>, <4 x i64>* %b, align 32
  %2 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.q.256(<4 x i64> %0, <4 x i64> %1)
  %3 = extractvalue { <4 x i1>, <4 x i1> } %2, 0
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <4 x i1>, <4 x i1> } %2, 1
  %7 = shufflevector <4 x i1> %6, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

define void @test_mm256_2intersect_epi32_b(i32* nocapture readonly %a, i32* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi32_b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x08]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x04]
; X86-NEXT:    vbroadcastss (%edx), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x18,0x02]
; X86-NEXT:    vp2intersectd (%ecx){1to8}, %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x38,0x68,0x01]
; X86-NEXT:    kmovw %k1, %ecx # encoding: [0xc5,0xf8,0x93,0xc9]
; X86-NEXT:    kmovw %k0, %edx # encoding: [0xc5,0xf8,0x93,0xd0]
; X86-NEXT:    movb %dl, (%eax) # encoding: [0x88,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x10]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi32_b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vbroadcastss (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x18,0x07]
; X64-NEXT:    vp2intersectd (%rsi){1to8}, %ymm0, %k0 # encoding: [0x62,0xf2,0x7f,0x38,0x68,0x06]
; X64-NEXT:    kmovw %k1, %eax # encoding: [0xc5,0xf8,0x93,0xc1]
; X64-NEXT:    kmovw %k0, %esi # encoding: [0xc5,0xf8,0x93,0xf0]
; X64-NEXT:    movb %sil, (%rdx) # encoding: [0x40,0x88,0x32]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load i32, i32* %a, align 4
  %vecinit.i.i = insertelement <8 x i32> undef, i32 %0, i32 0
  %vecinit7.i.i = shufflevector <8 x i32> %vecinit.i.i, <8 x i32> undef, <8 x i32> zeroinitializer
  %1 = load i32, i32* %b, align 4
  %vecinit.i.i2 = insertelement <8 x i32> undef, i32 %1, i32 0
  %vecinit7.i.i3 = shufflevector <8 x i32> %vecinit.i.i2, <8 x i32> undef, <8 x i32> zeroinitializer
  %2 = tail call { <8 x i1>, <8 x i1> } @llvm.x86.avx512.vp2intersect.d.256(<8 x i32> %vecinit7.i.i, <8 x i32> %vecinit7.i.i3)
  %3 = extractvalue { <8 x i1>, <8 x i1> } %2, 0
  %4 = bitcast i8* %m0 to <8 x i1>*
  store <8 x i1> %3, <8 x i1>* %4, align 8
  %5 = extractvalue { <8 x i1>, <8 x i1> } %2, 1
  %6 = bitcast i8* %m1 to <8 x i1>*
  store <8 x i1> %5, <8 x i1>* %6, align 8
  ret void
}

define void @test_mm256_2intersect_epi64_b(i64* nocapture readonly %a, i64* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm256_2intersect_epi64_b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vbroadcastsd (%esi), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x19,0x06]
; X86-NEXT:    vp2intersectq (%edx){1to4}, %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x38,0x68,0x02]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm256_2intersect_epi64_b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vbroadcastsd (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x19,0x07]
; X64-NEXT:    vp2intersectq (%rsi){1to4}, %ymm0, %k0 # encoding: [0x62,0xf2,0xff,0x38,0x68,0x06]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load i64, i64* %a, align 8
  %vecinit.i.i = insertelement <4 x i64> undef, i64 %0, i32 0
  %vecinit3.i.i = shufflevector <4 x i64> %vecinit.i.i, <4 x i64> undef, <4 x i32> zeroinitializer
  %1 = load i64, i64* %b, align 8
  %vecinit.i.i2 = insertelement <4 x i64> undef, i64 %1, i32 0
  %vecinit3.i.i3 = shufflevector <4 x i64> %vecinit.i.i2, <4 x i64> undef, <4 x i32> zeroinitializer
  %2 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.q.256(<4 x i64> %vecinit3.i.i, <4 x i64> %vecinit3.i.i3)
  %3 = extractvalue { <4 x i1>, <4 x i1> } %2, 0
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <4 x i1>, <4 x i1> } %2, 1
  %7 = shufflevector <4 x i1> %6, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi32(<2 x i64> %a, <2 x i64> %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X86-NEXT:    vp2intersectd %xmm1, %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x08,0x68,0xc1]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vp2intersectd %xmm1, %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x08,0x68,0xc1]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdi) # encoding: [0x88,0x07]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rsi) # encoding: [0x88,0x06]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = bitcast <2 x i64> %a to <4 x i32>
  %1 = bitcast <2 x i64> %b to <4 x i32>
  %2 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.d.128(<4 x i32> %0, <4 x i32> %1)
  %3 = extractvalue { <4 x i1>, <4 x i1> } %2, 0
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <4 x i1>, <4 x i1> } %2, 1
  %7 = shufflevector <4 x i1> %6, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi64(<2 x i64> %a, <2 x i64> %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X86-NEXT:    vp2intersectq %xmm1, %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x08,0x68,0xc1]
; X86-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X86-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X86-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vp2intersectq %xmm1, %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x08,0x68,0xc1]
; X64-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X64-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdi) # encoding: [0x88,0x07]
; X64-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X64-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rsi) # encoding: [0x88,0x06]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call { <2 x i1>, <2 x i1> } @llvm.x86.avx512.vp2intersect.q.128(<2 x i64> %a, <2 x i64> %b)
  %1 = extractvalue { <2 x i1>, <2 x i1> } %0, 0
  %2 = shufflevector <2 x i1> %1, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %3 = bitcast <8 x i1> %2 to i8
  store i8 %3, i8* %m0, align 1
  %4 = extractvalue { <2 x i1>, <2 x i1> } %0, 1
  %5 = shufflevector <2 x i1> %4, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %6 = bitcast <8 x i1> %5 to i8
  store i8 %6, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi32_p(<2 x i64>* nocapture readonly %a, <2 x i64>* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi32_p:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vmovaps (%esi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x06]
; X86-NEXT:    vp2intersectd (%edx), %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x08,0x68,0x02]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi32_p:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovaps (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; X64-NEXT:    vp2intersectd (%rsi), %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x08,0x68,0x06]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = bitcast <2 x i64>* %a to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 16
  %2 = bitcast <2 x i64>* %b to <4 x i32>*
  %3 = load <4 x i32>, <4 x i32>* %2, align 16
  %4 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.d.128(<4 x i32> %1, <4 x i32> %3)
  %5 = extractvalue { <4 x i1>, <4 x i1> } %4, 0
  %6 = shufflevector <4 x i1> %5, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %7 = bitcast <8 x i1> %6 to i8
  store i8 %7, i8* %m0, align 1
  %8 = extractvalue { <4 x i1>, <4 x i1> } %4, 1
  %9 = shufflevector <4 x i1> %8, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %10 = bitcast <8 x i1> %9 to i8
  store i8 %10, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi64_p(<2 x i64>* nocapture readonly %a, <2 x i64>* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi64_p:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vmovaps (%esi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x06]
; X86-NEXT:    vp2intersectq (%edx), %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x08,0x68,0x02]
; X86-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X86-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X86-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi64_p:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovaps (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; X64-NEXT:    vp2intersectq (%rsi), %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x08,0x68,0x06]
; X64-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X64-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X64-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load <2 x i64>, <2 x i64>* %a, align 16
  %1 = load <2 x i64>, <2 x i64>* %b, align 16
  %2 = tail call { <2 x i1>, <2 x i1> } @llvm.x86.avx512.vp2intersect.q.128(<2 x i64> %0, <2 x i64> %1)
  %3 = extractvalue { <2 x i1>, <2 x i1> } %2, 0
  %4 = shufflevector <2 x i1> %3, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <2 x i1>, <2 x i1> } %2, 1
  %7 = shufflevector <2 x i1> %6, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi32_b(i32* nocapture readonly %a, i32* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi32_b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vbroadcastss (%esi), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x18,0x06]
; X86-NEXT:    vp2intersectd (%edx){1to4}, %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x18,0x68,0x02]
; X86-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X86-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X86-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi32_b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vbroadcastss (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x18,0x07]
; X64-NEXT:    vp2intersectd (%rsi){1to4}, %xmm0, %k0 # encoding: [0x62,0xf2,0x7f,0x18,0x68,0x06]
; X64-NEXT:    kshiftlw $12, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0c]
; X64-NEXT:    kshiftrw $12, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0c]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $12, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0c]
; X64-NEXT:    kshiftrw $12, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0c]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load i32, i32* %a, align 4
  %vecinit.i.i = insertelement <4 x i32> undef, i32 %0, i32 0
  %vecinit3.i.i = shufflevector <4 x i32> %vecinit.i.i, <4 x i32> undef, <4 x i32> zeroinitializer
  %1 = load i32, i32* %b, align 4
  %vecinit.i.i2 = insertelement <4 x i32> undef, i32 %1, i32 0
  %vecinit3.i.i3 = shufflevector <4 x i32> %vecinit.i.i2, <4 x i32> undef, <4 x i32> zeroinitializer
  %2 = tail call { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.d.128(<4 x i32> %vecinit3.i.i, <4 x i32> %vecinit3.i.i3)
  %3 = extractvalue { <4 x i1>, <4 x i1> } %2, 0
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <4 x i1>, <4 x i1> } %2, 1
  %7 = shufflevector <4 x i1> %6, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

define void @test_mm_2intersect_epi64_b(i64* nocapture readonly %a, i64* nocapture readonly %b, i8* nocapture %m0, i8* nocapture %m1) {
; X86-LABEL: test_mm_2intersect_epi64_b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %esi # encoding: [0x56]
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x14]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x10]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x0c]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi # encoding: [0x8b,0x74,0x24,0x08]
; X86-NEXT:    vmovddup (%esi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xfb,0x12,0x06]
; X86-NEXT:    # xmm0 = mem[0,0]
; X86-NEXT:    vp2intersectq (%edx){1to2}, %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x18,0x68,0x02]
; X86-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X86-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X86-NEXT:    kmovw %k2, %edx # encoding: [0xc5,0xf8,0x93,0xd2]
; X86-NEXT:    movb %dl, (%ecx) # encoding: [0x88,0x11]
; X86-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X86-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X86-NEXT:    kmovw %k0, %ecx # encoding: [0xc5,0xf8,0x93,0xc8]
; X86-NEXT:    movb %cl, (%eax) # encoding: [0x88,0x08]
; X86-NEXT:    popl %esi # encoding: [0x5e]
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm_2intersect_epi64_b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovddup (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xfb,0x12,0x07]
; X64-NEXT:    # xmm0 = mem[0,0]
; X64-NEXT:    vp2intersectq (%rsi){1to2}, %xmm0, %k0 # encoding: [0x62,0xf2,0xff,0x18,0x68,0x06]
; X64-NEXT:    kshiftlw $14, %k0, %k2 # encoding: [0xc4,0xe3,0xf9,0x32,0xd0,0x0e]
; X64-NEXT:    kshiftrw $14, %k2, %k2 # encoding: [0xc4,0xe3,0xf9,0x30,0xd2,0x0e]
; X64-NEXT:    kmovw %k2, %eax # encoding: [0xc5,0xf8,0x93,0xc2]
; X64-NEXT:    movb %al, (%rdx) # encoding: [0x88,0x02]
; X64-NEXT:    kshiftlw $14, %k1, %k0 # encoding: [0xc4,0xe3,0xf9,0x32,0xc1,0x0e]
; X64-NEXT:    kshiftrw $14, %k0, %k0 # encoding: [0xc4,0xe3,0xf9,0x30,0xc0,0x0e]
; X64-NEXT:    kmovw %k0, %eax # encoding: [0xc5,0xf8,0x93,0xc0]
; X64-NEXT:    movb %al, (%rcx) # encoding: [0x88,0x01]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load i64, i64* %a, align 8
  %vecinit.i.i = insertelement <2 x i64> undef, i64 %0, i32 0
  %vecinit1.i.i = shufflevector <2 x i64> %vecinit.i.i, <2 x i64> undef, <2 x i32> zeroinitializer
  %1 = load i64, i64* %b, align 8
  %vecinit.i.i2 = insertelement <2 x i64> undef, i64 %1, i32 0
  %vecinit1.i.i3 = shufflevector <2 x i64> %vecinit.i.i2, <2 x i64> undef, <2 x i32> zeroinitializer
  %2 = tail call { <2 x i1>, <2 x i1> } @llvm.x86.avx512.vp2intersect.q.128(<2 x i64> %vecinit1.i.i, <2 x i64> %vecinit1.i.i3)
  %3 = extractvalue { <2 x i1>, <2 x i1> } %2, 0
  %4 = shufflevector <2 x i1> %3, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %5 = bitcast <8 x i1> %4 to i8
  store i8 %5, i8* %m0, align 1
  %6 = extractvalue { <2 x i1>, <2 x i1> } %2, 1
  %7 = shufflevector <2 x i1> %6, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %8 = bitcast <8 x i1> %7 to i8
  store i8 %8, i8* %m1, align 1
  ret void
}

declare { <8 x i1>, <8 x i1> } @llvm.x86.avx512.vp2intersect.d.256(<8 x i32>, <8 x i32>)
declare { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.q.256(<4 x i64>, <4 x i64>)
declare { <4 x i1>, <4 x i1> } @llvm.x86.avx512.vp2intersect.d.128(<4 x i32>, <4 x i32>)
declare { <2 x i1>, <2 x i1> } @llvm.x86.avx512.vp2intersect.q.128(<2 x i64>, <2 x i64>)
