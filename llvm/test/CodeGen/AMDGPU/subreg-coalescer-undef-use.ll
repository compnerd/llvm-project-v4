; RUN: llc -march=amdgcn -mcpu=tahiti -o - %s | FileCheck %s
; Don't crash when the use of an undefined value is only detected by the
; register coalescer because it is hidden with subregister insert/extract.
target triple="amdgcn--"

; CHECK-LABEL: foobar:
; CHECK: s_load_dwordx2 s[4:5], s[0:1], 0x9
; CHECK-NEXT: s_load_dwordx2 s[0:1], s[0:1], 0xb
; CHECK-NEXT: v_mbcnt_lo_u32_b32_e64
; CHECK-NEXT: s_mov_b32 s2, -1
; CHECK-NEXT: v_cmp_eq_u32_e32 vcc, 0, v0
; CHECK-NEXT: s_waitcnt lgkmcnt(0)
; CHECK-NEXT: v_mov_b32_e32 v1, s5
; CHECK-NEXT: s_and_saveexec_b64 s[4:5], vcc

; CHECK: BB0_1:
; CHECK-NEXT: ; kill: def $vgpr0_vgpr1 killed $sgpr4_sgpr5 killed $exec
; CHECK-NEXT: ; implicit-def: $vgpr0_vgpr1_vgpr2_vgpr3

; CHECK: BB0_2:
; CHECK: s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT: s_mov_b32 s3, 0xf000
; CHECK-NEXT: buffer_store_dword v1, off, s[0:3], 0
; CHECK-NEXT: s_endpgm
define amdgpu_kernel void @foobar(float %a0, float %a1, float addrspace(1)* %out) nounwind {
entry:
  %v0 = insertelement <4 x float> undef, float %a0, i32 0
  %tid = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #0
  %cnd = icmp eq i32 %tid, 0
  br i1 %cnd, label %ift, label %ife

ift:
  %v1 = insertelement <4 x float> undef, float %a1, i32 0
  br label %ife

ife:
  %val = phi <4 x float> [ %v1, %ift ], [ %v0, %entry ]
  %v2 = extractelement <4 x float> %val, i32 1
  store float %v2, float addrspace(1)* %out, align 4
  ret void
}

declare i32 @llvm.amdgcn.mbcnt.lo(i32, i32) #0

attributes #0 = { nounwind readnone }
