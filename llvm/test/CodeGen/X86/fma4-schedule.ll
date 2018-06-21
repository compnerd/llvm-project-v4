; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+fma4 | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver1 | FileCheck %s --check-prefix=CHECK --check-prefix=BDVER --check-prefix=BDVER1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver2 -mattr=-fma | FileCheck %s --check-prefix=CHECK --check-prefix=BDVER --check-prefix=BDVER1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver3 -mattr=-fma | FileCheck %s --check-prefix=CHECK --check-prefix=BDVER --check-prefix=BDVER1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver4 -mattr=-fma | FileCheck %s --check-prefix=CHECK --check-prefix=BDVER --check-prefix=BDVER1

;
; VFMADD
;

define void @test_vfmaddpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddpd $2, $1, $0, $0 \0A\09 vfmaddpd $3, $1, $0, $0 \0A\09 vfmaddpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmaddpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmaddpd $2, $1, $0, $0 \0A\09 vfmaddpd $3, $1, $0, $0 \0A\09 vfmaddpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfmaddps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddps $2, $1, $0, $0 \0A\09 vfmaddps $3, $1, $0, $0 \0A\09 vfmaddps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfmaddps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmaddps $2, $1, $0, $0 \0A\09 vfmaddps $3, $1, $0, $0 \0A\09 vfmaddps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

define void @test_vfmaddsd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddsd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddsd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddsd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddsd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddsd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddsd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddsd $2, $1, $0, $0 \0A\09 vfmaddsd $3, $1, $0, $0 \0A\09 vfmaddsd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmaddss_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddss_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddss %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddss (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddss %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddss_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddss %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddss (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddss %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddss $2, $1, $0, $0 \0A\09 vfmaddss $3, $1, $0, $0 \0A\09 vfmaddss $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

;
; VFMADDSUB
;

define void @test_vfmaddsubpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddsubpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddsubpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddsubpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddsubpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddsubpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddsubpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsubpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsubpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddsubpd $2, $1, $0, $0 \0A\09 vfmaddsubpd $3, $1, $0, $0 \0A\09 vfmaddsubpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmaddsubpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddsubpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddsubpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddsubpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddsubpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddsubpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddsubpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddsubpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddsubpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmaddsubpd $2, $1, $0, $0 \0A\09 vfmaddsubpd $3, $1, $0, $0 \0A\09 vfmaddsubpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfmaddsubps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddsubps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddsubps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddsubps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddsubps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddsubps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddsubps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsubps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmaddsubps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmaddsubps $2, $1, $0, $0 \0A\09 vfmaddsubps $3, $1, $0, $0 \0A\09 vfmaddsubps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfmaddsubps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmaddsubps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmaddsubps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmaddsubps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmaddsubps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmaddsubps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmaddsubps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddsubps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmaddsubps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmaddsubps $2, $1, $0, $0 \0A\09 vfmaddsubps $3, $1, $0, $0 \0A\09 vfmaddsubps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

;
; VFMSUBADD
;

define void @test_vfmsubaddpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubaddpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubaddpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubaddpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubaddpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubaddpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubaddpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubaddpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubaddpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubaddpd $2, $1, $0, $0 \0A\09 vfmsubaddpd $3, $1, $0, $0 \0A\09 vfmsubaddpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmsubaddpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubaddpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubaddpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubaddpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubaddpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubaddpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubaddpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubaddpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubaddpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmsubaddpd $2, $1, $0, $0 \0A\09 vfmsubaddpd $3, $1, $0, $0 \0A\09 vfmsubaddpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfmsubaddps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubaddps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubaddps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubaddps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubaddps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubaddps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubaddps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubaddps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubaddps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubaddps $2, $1, $0, $0 \0A\09 vfmsubaddps $3, $1, $0, $0 \0A\09 vfmsubaddps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfmsubaddps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubaddps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubaddps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubaddps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubaddps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubaddps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubaddps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubaddps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubaddps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmsubaddps $2, $1, $0, $0 \0A\09 vfmsubaddps $3, $1, $0, $0 \0A\09 vfmsubaddps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

;
; VFMSUB
;

define void @test_vfmsubpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubpd $2, $1, $0, $0 \0A\09 vfmsubpd $3, $1, $0, $0 \0A\09 vfmsubpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmsubpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmsubpd $2, $1, $0, $0 \0A\09 vfmsubpd $3, $1, $0, $0 \0A\09 vfmsubpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfmsubps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubps $2, $1, $0, $0 \0A\09 vfmsubps $3, $1, $0, $0 \0A\09 vfmsubps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfmsubps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfmsubps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfmsubps $2, $1, $0, $0 \0A\09 vfmsubps $3, $1, $0, $0 \0A\09 vfmsubps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

define void @test_vfmsubsd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubsd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubsd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubsd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubsd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubsd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubsd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubsd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubsd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubsd $2, $1, $0, $0 \0A\09 vfmsubsd $3, $1, $0, $0 \0A\09 vfmsubsd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfmsubss_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfmsubss_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfmsubss %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfmsubss (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfmsubss %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfmsubss_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfmsubss %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubss (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfmsubss %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfmsubss $2, $1, $0, $0 \0A\09 vfmsubss $3, $1, $0, $0 \0A\09 vfmsubss $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

;
; VFNMADD
;

define void @test_vfnmaddpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddpd $2, $1, $0, $0 \0A\09 vfnmaddpd $3, $1, $0, $0 \0A\09 vfnmaddpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmaddpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmaddpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmaddpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddpd $2, $1, $0, $0 \0A\09 vfnmaddpd $3, $1, $0, $0 \0A\09 vfnmaddpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmaddps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddps $2, $1, $0, $0 \0A\09 vfnmaddps $3, $1, $0, $0 \0A\09 vfnmaddps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfnmaddps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmaddps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmaddps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddps $2, $1, $0, $0 \0A\09 vfnmaddps $3, $1, $0, $0 \0A\09 vfnmaddps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

define void @test_vfnmaddsd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddsd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddsd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddsd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddsd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddsd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddsd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddsd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddsd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddsd $2, $1, $0, $0 \0A\09 vfnmaddsd $3, $1, $0, $0 \0A\09 vfnmaddsd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmaddss_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmaddss_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmaddss %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmaddss (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmaddss %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmaddss_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmaddss %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddss (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmaddss %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmaddss $2, $1, $0, $0 \0A\09 vfnmaddss $3, $1, $0, $0 \0A\09 vfnmaddss $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

;
; VFNMSUB
;

define void @test_vfnmsubpd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubpd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubpd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubpd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubpd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubpd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubpd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubpd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubpd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubpd $2, $1, $0, $0 \0A\09 vfnmsubpd $3, $1, $0, $0 \0A\09 vfnmsubpd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmsubpd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubpd_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubpd %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubpd (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubpd %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubpd_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubpd %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmsubpd (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmsubpd %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubpd $2, $1, $0, $0 \0A\09 vfnmsubpd $3, $1, $0, $0 \0A\09 vfnmsubpd $1, $3, $0, $0", "x,x,x,*m"(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmsubps_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubps_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubps %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubps (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubps %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubps_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubps %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubps (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubps %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubps $2, $1, $0, $0 \0A\09 vfnmsubps $3, $1, $0, $0 \0A\09 vfnmsubps $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}

define void @test_vfnmsubps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubps_256:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubps %ymm2, %ymm1, %ymm0, %ymm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubps (%rdi), %ymm1, %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubps %ymm1, (%rdi), %ymm0, %ymm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    vzeroupper # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubps_256:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubps %ymm2, %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmsubps (%rdi), %ymm1, %ymm0, %ymm0
; BDVER-NEXT:    vfnmsubps %ymm1, (%rdi), %ymm0, %ymm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    vzeroupper
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubps $2, $1, $0, $0 \0A\09 vfnmsubps $3, $1, $0, $0 \0A\09 vfnmsubps $1, $3, $0, $0", "x,x,x,*m"(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> *%a3) nounwind
  ret void
}

define void @test_vfnmsubsd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubsd_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubsd %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubsd (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubsd %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubsd_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubsd %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubsd (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubsd %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubsd $2, $1, $0, $0 \0A\09 vfnmsubsd $3, $1, $0, $0 \0A\09 vfnmsubsd $1, $3, $0, $0", "x,x,x,*m"(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> *%a3) nounwind
  ret void
}

define void @test_vfnmsubss_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) optsize {
; GENERIC-LABEL: test_vfnmsubss_128:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    vfnmsubss %xmm2, %xmm1, %xmm0, %xmm0 # sched: [5:0.50]
; GENERIC-NEXT:    vfnmsubss (%rdi), %xmm1, %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    vfnmsubss %xmm1, (%rdi), %xmm0, %xmm0 # sched: [10:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER-LABEL: test_vfnmsubss_128:
; BDVER:       # %bb.0:
; BDVER-NEXT:    #APP
; BDVER-NEXT:    vfnmsubss %xmm2, %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubss (%rdi), %xmm1, %xmm0, %xmm0
; BDVER-NEXT:    vfnmsubss %xmm1, (%rdi), %xmm0, %xmm0
; BDVER-NEXT:    #NO_APP
; BDVER-NEXT:    retq
  tail call void asm "vfnmsubss $2, $1, $0, $0 \0A\09 vfnmsubss $3, $1, $0, $0 \0A\09 vfnmsubss $1, $3, $0, $0", "x,x,x,*m"(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> *%a3) nounwind
  ret void
}
