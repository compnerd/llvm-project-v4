; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=fiji -verify-machineinstrs | FileCheck -check-prefix=VI %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs | FileCheck -check-prefix=GFX9 %s

; ===================================================================================
; V_LSHL_OR_B32
; ===================================================================================

define amdgpu_ps float @shl_or(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: shl_or:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_c(i32 inreg %a, i32 inreg %b, i32 %c) {
; VI-LABEL: shl_or_vgpr_c:
; VI:       ; %bb.0:
; VI-NEXT:    s_lshl_b32 s0, s2, s3
; VI-NEXT:    v_or_b32_e32 v0, s0, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_c:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_lshl_b32 s0, s2, s3
; GFX9-NEXT:    v_or_b32_e32 v0, s0, v0
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_all2(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: shl_or_vgpr_all2:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_or_b32_e32 v0, v2, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_all2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = or i32 %c, %x
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_ac(i32 %a, i32 inreg %b, i32 %c) {
; VI-LABEL: shl_or_vgpr_ac:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, s2, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_ac:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, s2, v1
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_const(i32 %a, i32 %b) {
; VI-LABEL: shl_or_vgpr_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_or_b32_e32 v0, 6, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, v1, 6
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = or i32 %x, 6
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_const2(i32 %a, i32 %b) {
; VI-LABEL: shl_or_vgpr_const2:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, 6, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_const2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, 6, v1
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, 6
  %result = or i32 %x, %b
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_const_scalar1(i32 inreg %a, i32 %b) {
; VI-LABEL: shl_or_vgpr_const_scalar1:
; VI:       ; %bb.0:
; VI-NEXT:    s_lshl_b32 s0, s2, 6
; VI-NEXT:    v_or_b32_e32 v0, s0, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_const_scalar1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, s2, 6, v0
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, 6
  %result = or i32 %x, %b
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_or_vgpr_const_scalar2(i32 %a, i32 inreg %b) {
; VI-LABEL: shl_or_vgpr_const_scalar2:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, 6, v0
; VI-NEXT:    v_or_b32_e32 v0, s2, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_or_vgpr_const_scalar2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, 6, s2
; GFX9-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, 6
  %result = or i32 %x, %b
  %bc = bitcast i32 %result to float
  ret float %bc
}
