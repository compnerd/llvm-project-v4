; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-BE

; Test reduce scalarization in fpext v2f32 to v2f64 from the extract_subvector v4f32 node.

define dso_local void @test(<4 x float>* nocapture readonly %a, <2 x double>* nocapture %b, <2 x double>* nocapture %c) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs0, 0(r3)
; CHECK-NEXT:    xxmrglw vs1, vs0, vs0
; CHECK-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-NEXT:    xvcvspdp vs1, vs1
; CHECK-NEXT:    xvcvspdp vs0, vs0
; CHECK-NEXT:    stxv vs1, 0(r4)
; CHECK-NEXT:    stxv vs0, 0(r5)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    xxmrghw vs1, vs0, vs0
; CHECK-BE-NEXT:    xxmrglw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    stxv vs1, 0(r4)
; CHECK-BE-NEXT:    stxv vs0, 0(r5)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %shuffle = shufflevector <4 x float> %0, <4 x float> undef, <2 x i32> <i32 0, i32 1>
  %shuffle1 = shufflevector <4 x float> %0, <4 x float> undef, <2 x i32> <i32 2, i32 3>
  %vecinit4 = fpext <2 x float> %shuffle to <2 x double>
  %vecinit11 = fpext <2 x float> %shuffle1 to <2 x double>
  store <2 x double> %vecinit4, <2 x double>* %b, align 16
  store <2 x double> %vecinit11, <2 x double>* %c, align 16
  ret void
}

; Ensure we don't crash for wider types

define dso_local void @test2(<16 x float>* nocapture readonly %a, <2 x double>* nocapture %b, <2 x double>* nocapture %c) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs0, 0(r3)
; CHECK-NEXT:    xxsldwi vs1, vs0, vs0, 1
; CHECK-NEXT:    xscvspdpn f2, vs0
; CHECK-NEXT:    xxsldwi vs3, vs0, vs0, 3
; CHECK-NEXT:    xxswapd vs0, vs0
; CHECK-NEXT:    xscvspdpn f1, vs1
; CHECK-NEXT:    xscvspdpn f3, vs3
; CHECK-NEXT:    xscvspdpn f0, vs0
; CHECK-NEXT:    xxmrghd vs0, vs0, vs3
; CHECK-NEXT:    xxmrghd vs1, vs2, vs1
; CHECK-NEXT:    stxv vs0, 0(r4)
; CHECK-NEXT:    stxv vs1, 0(r5)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    xxswapd vs1, vs0
; CHECK-BE-NEXT:    xxsldwi vs2, vs0, vs0, 3
; CHECK-BE-NEXT:    xscvspdpn f3, vs0
; CHECK-BE-NEXT:    xxsldwi vs0, vs0, vs0, 1
; CHECK-BE-NEXT:    xscvspdpn f1, vs1
; CHECK-BE-NEXT:    xscvspdpn f2, vs2
; CHECK-BE-NEXT:    xscvspdpn f0, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs3, vs0
; CHECK-BE-NEXT:    xxmrghd vs1, vs1, vs2
; CHECK-BE-NEXT:    stxv vs0, 0(r4)
; CHECK-BE-NEXT:    stxv vs1, 0(r5)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <16 x float>, <16 x float>* %a, align 16
  %shuffle = shufflevector <16 x float> %0, <16 x float> undef, <2 x i32> <i32 0, i32 1>
  %shuffle1 = shufflevector <16 x float> %0, <16 x float> undef, <2 x i32> <i32 2, i32 3>
  %vecinit4 = fpext <2 x float> %shuffle to <2 x double>
  %vecinit11 = fpext <2 x float> %shuffle1 to <2 x double>
  store <2 x double> %vecinit4, <2 x double>* %b, align 16
  store <2 x double> %vecinit11, <2 x double>* %c, align 16
  ret void
}
