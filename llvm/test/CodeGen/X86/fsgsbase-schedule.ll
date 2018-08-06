; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=fsgsbase | FileCheck %s --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=goldmont | FileCheck %s --check-prefix=GLM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=ivybridge | FileCheck %s --check-prefix=IVY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skx | FileCheck %s --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl     | FileCheck %s --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver3 | FileCheck %s --check-prefix=BDVER --check-prefix=BDVER3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver4 | FileCheck %s --check-prefix=BDVER --check-prefix=BDVER4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=ZNVER1

define i32 @test_x86_rdfsbase_32() {
; GENERIC-LABEL: test_x86_rdfsbase_32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdfsbasel %eax # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_rdfsbase_32:
; GLM:       # %bb.0:
; GLM-NEXT:    rdfsbasel %eax # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_rdfsbase_32:
; IVY:       # %bb.0:
; IVY-NEXT:    rdfsbasel %eax # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_rdfsbase_32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    rdfsbasel %eax # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_rdfsbase_32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdfsbasel %eax # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_rdfsbase_32:
; SKX:       # %bb.0:
; SKX-NEXT:    rdfsbasel %eax # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_rdfsbase_32:
; KNL:       # %bb.0:
; KNL-NEXT:    rdfsbasel %eax # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_rdfsbase_32:
; BDVER:       # %bb.0:
; BDVER-NEXT:    rdfsbasel %eax
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_rdfsbase_32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdfsbasel %eax # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %res = call i32 @llvm.x86.rdfsbase.32()
  ret i32 %res
}
declare i32 @llvm.x86.rdfsbase.32() nounwind readnone

define i32 @test_x86_rdgsbase_32() {
; GENERIC-LABEL: test_x86_rdgsbase_32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdgsbasel %eax # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_rdgsbase_32:
; GLM:       # %bb.0:
; GLM-NEXT:    rdgsbasel %eax # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_rdgsbase_32:
; IVY:       # %bb.0:
; IVY-NEXT:    rdgsbasel %eax # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_rdgsbase_32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    rdgsbasel %eax # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_rdgsbase_32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdgsbasel %eax # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_rdgsbase_32:
; SKX:       # %bb.0:
; SKX-NEXT:    rdgsbasel %eax # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_rdgsbase_32:
; KNL:       # %bb.0:
; KNL-NEXT:    rdgsbasel %eax # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_rdgsbase_32:
; BDVER:       # %bb.0:
; BDVER-NEXT:    rdgsbasel %eax
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_rdgsbase_32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdgsbasel %eax # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %res = call i32 @llvm.x86.rdgsbase.32()
  ret i32 %res
}
declare i32 @llvm.x86.rdgsbase.32() nounwind readnone

define i64 @test_x86_rdfsbase_64() {
; GENERIC-LABEL: test_x86_rdfsbase_64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdfsbaseq %rax # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_rdfsbase_64:
; GLM:       # %bb.0:
; GLM-NEXT:    rdfsbaseq %rax # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_rdfsbase_64:
; IVY:       # %bb.0:
; IVY-NEXT:    rdfsbaseq %rax # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_rdfsbase_64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    rdfsbaseq %rax # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_rdfsbase_64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdfsbaseq %rax # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_rdfsbase_64:
; SKX:       # %bb.0:
; SKX-NEXT:    rdfsbaseq %rax # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_rdfsbase_64:
; KNL:       # %bb.0:
; KNL-NEXT:    rdfsbaseq %rax # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_rdfsbase_64:
; BDVER:       # %bb.0:
; BDVER-NEXT:    rdfsbaseq %rax
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_rdfsbase_64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdfsbaseq %rax # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %res = call i64 @llvm.x86.rdfsbase.64()
  ret i64 %res
}
declare i64 @llvm.x86.rdfsbase.64() nounwind readnone

define i64 @test_x86_rdgsbase_64() {
; GENERIC-LABEL: test_x86_rdgsbase_64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdgsbaseq %rax # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_rdgsbase_64:
; GLM:       # %bb.0:
; GLM-NEXT:    rdgsbaseq %rax # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_rdgsbase_64:
; IVY:       # %bb.0:
; IVY-NEXT:    rdgsbaseq %rax # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_rdgsbase_64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    rdgsbaseq %rax # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_rdgsbase_64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdgsbaseq %rax # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_rdgsbase_64:
; SKX:       # %bb.0:
; SKX-NEXT:    rdgsbaseq %rax # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_rdgsbase_64:
; KNL:       # %bb.0:
; KNL-NEXT:    rdgsbaseq %rax # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_rdgsbase_64:
; BDVER:       # %bb.0:
; BDVER-NEXT:    rdgsbaseq %rax
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_rdgsbase_64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdgsbaseq %rax # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %res = call i64 @llvm.x86.rdgsbase.64()
  ret i64 %res
}
declare i64 @llvm.x86.rdgsbase.64() nounwind readnone

define void @test_x86_wrfsbase_32(i32 %x) {
; GENERIC-LABEL: test_x86_wrfsbase_32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    wrfsbasel %edi # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_wrfsbase_32:
; GLM:       # %bb.0:
; GLM-NEXT:    wrfsbasel %edi # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_wrfsbase_32:
; IVY:       # %bb.0:
; IVY-NEXT:    wrfsbasel %edi # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_wrfsbase_32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    wrfsbasel %edi # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_wrfsbase_32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    wrfsbasel %edi # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_wrfsbase_32:
; SKX:       # %bb.0:
; SKX-NEXT:    wrfsbasel %edi # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_wrfsbase_32:
; KNL:       # %bb.0:
; KNL-NEXT:    wrfsbasel %edi # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_wrfsbase_32:
; BDVER:       # %bb.0:
; BDVER-NEXT:    wrfsbasel %edi
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_wrfsbase_32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    wrfsbasel %edi # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  call void @llvm.x86.wrfsbase.32(i32 %x)
  ret void
}
declare void @llvm.x86.wrfsbase.32(i32) nounwind readnone

define void @test_x86_wrgsbase_32(i32 %x) {
; GENERIC-LABEL: test_x86_wrgsbase_32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    wrgsbasel %edi # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_wrgsbase_32:
; GLM:       # %bb.0:
; GLM-NEXT:    wrgsbasel %edi # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_wrgsbase_32:
; IVY:       # %bb.0:
; IVY-NEXT:    wrgsbasel %edi # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_wrgsbase_32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    wrgsbasel %edi # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_wrgsbase_32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    wrgsbasel %edi # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_wrgsbase_32:
; SKX:       # %bb.0:
; SKX-NEXT:    wrgsbasel %edi # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_wrgsbase_32:
; KNL:       # %bb.0:
; KNL-NEXT:    wrgsbasel %edi # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_wrgsbase_32:
; BDVER:       # %bb.0:
; BDVER-NEXT:    wrgsbasel %edi
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_wrgsbase_32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    wrgsbasel %edi # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  call void @llvm.x86.wrgsbase.32(i32 %x)
  ret void
}
declare void @llvm.x86.wrgsbase.32(i32) nounwind readnone

define void @test_x86_wrfsbase_64(i64 %x) {
; GENERIC-LABEL: test_x86_wrfsbase_64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    wrfsbaseq %rdi # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_wrfsbase_64:
; GLM:       # %bb.0:
; GLM-NEXT:    wrfsbaseq %rdi # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_wrfsbase_64:
; IVY:       # %bb.0:
; IVY-NEXT:    wrfsbaseq %rdi # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_wrfsbase_64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    wrfsbaseq %rdi # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_wrfsbase_64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    wrfsbaseq %rdi # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_wrfsbase_64:
; SKX:       # %bb.0:
; SKX-NEXT:    wrfsbaseq %rdi # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_wrfsbase_64:
; KNL:       # %bb.0:
; KNL-NEXT:    wrfsbaseq %rdi # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_wrfsbase_64:
; BDVER:       # %bb.0:
; BDVER-NEXT:    wrfsbaseq %rdi
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_wrfsbase_64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    wrfsbaseq %rdi # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  call void @llvm.x86.wrfsbase.64(i64 %x)
  ret void
}
declare void @llvm.x86.wrfsbase.64(i64) nounwind readnone

define void @test_x86_wrgsbase_64(i64 %x) {
; GENERIC-LABEL: test_x86_wrgsbase_64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    wrgsbaseq %rdi # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GLM-LABEL: test_x86_wrgsbase_64:
; GLM:       # %bb.0:
; GLM-NEXT:    wrgsbaseq %rdi # sched: [100:1.00]
; GLM-NEXT:    retq # sched: [4:1.00]
;
; IVY-LABEL: test_x86_wrgsbase_64:
; IVY:       # %bb.0:
; IVY-NEXT:    wrgsbaseq %rdi # sched: [100:0.33]
; IVY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_x86_wrgsbase_64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    wrgsbaseq %rdi # sched: [100:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_x86_wrgsbase_64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    wrgsbaseq %rdi # sched: [100:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_x86_wrgsbase_64:
; SKX:       # %bb.0:
; SKX-NEXT:    wrgsbaseq %rdi # sched: [100:0.25]
; SKX-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_x86_wrgsbase_64:
; KNL:       # %bb.0:
; KNL-NEXT:    wrgsbaseq %rdi # sched: [100:0.25]
; KNL-NEXT:    retq # sched: [7:1.00]
;
; BDVER-LABEL: test_x86_wrgsbase_64:
; BDVER:       # %bb.0:
; BDVER-NEXT:    wrgsbaseq %rdi
; BDVER-NEXT:    retq
;
; ZNVER1-LABEL: test_x86_wrgsbase_64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    wrgsbaseq %rdi # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  call void @llvm.x86.wrgsbase.64(i64 %x)
  ret void
}
declare void @llvm.x86.wrgsbase.64(i64) nounwind readnone
