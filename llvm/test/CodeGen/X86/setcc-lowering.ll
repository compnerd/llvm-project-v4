; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+avx < %s | FileCheck %s --check-prefix=AVX
; RUN: llc -mtriple=i386-unknown-linux-gnu -mcpu=knl < %s   | FileCheck %s --check-prefix=KNL-32


; Verify that we don't crash during codegen due to a wrong lowering
; of a setcc node with illegal operand types and return type.

define <8 x i16> @pr25080(<8 x i32> %a) {
; AVX-LABEL: pr25080:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpcmpeqd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpor {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpsllw $15, %xmm0, %xmm0
; AVX-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; KNL-32-LABEL: pr25080:
; KNL-32:       # %bb.0: # %entry
; KNL-32-NEXT:    # kill: def %ymm0 killed %ymm0 def %zmm0
; KNL-32-NEXT:    vpbroadcastd {{.*#+}} ymm1 = [8388607,8388607,8388607,8388607,8388607,8388607,8388607,8388607]
; KNL-32-NEXT:    vptestnmd %zmm1, %zmm0, %k0
; KNL-32-NEXT:    movb $15, %al
; KNL-32-NEXT:    kmovw %eax, %k1
; KNL-32-NEXT:    korw %k1, %k0, %k1
; KNL-32-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-32-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-32-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; KNL-32-NEXT:    retl
entry:
  %0 = trunc <8 x i32> %a to <8 x i23>
  %1 = icmp eq <8 x i23> %0, zeroinitializer
  %2 = or <8 x i1> %1, <i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false>
  %3 = sext <8 x i1> %2 to <8 x i16>
  ret <8 x i16> %3
}

define void @pr26232(i64 %a, <16 x i1> %b) {
; AVX-LABEL: pr26232:
; AVX:       # %bb.0: # %for_loop599.preheader
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
; AVX-NEXT:    .p2align 4, 0x90
; AVX-NEXT:  .LBB1_1: # %for_loop599
; AVX-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    cmpq $65536, %rdi # imm = 0x10000
; AVX-NEXT:    setl %al
; AVX-NEXT:    vmovd %eax, %xmm3
; AVX-NEXT:    vpshufb %xmm1, %xmm3, %xmm3
; AVX-NEXT:    vpand %xmm0, %xmm3, %xmm3
; AVX-NEXT:    vpsllw $7, %xmm3, %xmm3
; AVX-NEXT:    vpand %xmm2, %xmm3, %xmm3
; AVX-NEXT:    vpmovmskb %xmm3, %eax
; AVX-NEXT:    testw %ax, %ax
; AVX-NEXT:    jne .LBB1_1
; AVX-NEXT:  # %bb.2: # %for_exit600
; AVX-NEXT:    retq
;
; KNL-32-LABEL: pr26232:
; KNL-32:       # %bb.0: # %for_loop599.preheader
; KNL-32-NEXT:    pushl %esi
; KNL-32-NEXT:    .cfi_def_cfa_offset 8
; KNL-32-NEXT:    .cfi_offset %esi, -8
; KNL-32-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-32-NEXT:    vpslld $31, %zmm0, %zmm0
; KNL-32-NEXT:    vptestmd %zmm0, %zmm0, %k0
; KNL-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; KNL-32-NEXT:    movw $-1, %dx
; KNL-32-NEXT:    .p2align 4, 0x90
; KNL-32-NEXT:  .LBB1_1: # %for_loop599
; KNL-32-NEXT:    # =>This Inner Loop Header: Depth=1
; KNL-32-NEXT:    cmpl $65536, %ecx # imm = 0x10000
; KNL-32-NEXT:    movl %eax, %esi
; KNL-32-NEXT:    sbbl $0, %esi
; KNL-32-NEXT:    movl $0, %esi
; KNL-32-NEXT:    cmovlw %dx, %si
; KNL-32-NEXT:    kmovw %esi, %k1
; KNL-32-NEXT:    kandw %k0, %k1, %k1
; KNL-32-NEXT:    kmovw %k1, %esi
; KNL-32-NEXT:    testw %si, %si
; KNL-32-NEXT:    jne .LBB1_1
; KNL-32-NEXT:  # %bb.2: # %for_exit600
; KNL-32-NEXT:    popl %esi
; KNL-32-NEXT:    retl
allocas:
  br label %for_test11.preheader

for_test11.preheader:                             ; preds = %for_test11.preheader, %allocas
  br i1 undef, label %for_loop599, label %for_test11.preheader

for_loop599:                                      ; preds = %for_loop599, %for_test11.preheader
  %less_i_load605_ = icmp slt i64 %a, 65536
  %less_i_load605__broadcast_init = insertelement <16 x i1> undef, i1 %less_i_load605_, i32 0
  %less_i_load605__broadcast = shufflevector <16 x i1> %less_i_load605__broadcast_init, <16 x i1> undef, <16 x i32> zeroinitializer
  %"oldMask&test607" = and <16 x i1> %less_i_load605__broadcast, %b
  %intmask.i894 = bitcast <16 x i1> %"oldMask&test607" to i16
  %res.i895 = icmp eq i16 %intmask.i894, 0
  br i1 %res.i895, label %for_exit600, label %for_loop599

for_exit600:                                      ; preds = %for_loop599
  ret void
}
