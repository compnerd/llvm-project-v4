; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare double @llvm.exp2.f64(double)
declare double @llvm.log2.f64(double)

define double @exp2_log2(double %a) {
; CHECK-LABEL: @exp2_log2(
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.log2.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call double @llvm.log2.f64(double %a)
  %2 = call double @llvm.exp2.f64(double %1)
  ret double %2
}

define double @exp2_log2_fast(double %a) {
; CHECK-LABEL: @exp2_log2_fast(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call fast double @llvm.log2.f64(double %a)
  %2 = call fast double @llvm.exp2.f64(double %1)
  ret double %2
}

define double @exp2_fast_log2_strict(double %a) {
; CHECK-LABEL: @exp2_fast_log2_strict(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call double @llvm.log2.f64(double %a)
  %2 = call fast double @llvm.exp2.f64(double %1)
  ret double %2
}

define double @exp2_strict_log2_fast(double %a) {
; CHECK-LABEL: @exp2_strict_log2_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.log2.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call fast double @llvm.log2.f64(double %a)
  %2 = call double @llvm.exp2.f64(double %1)
  ret double %2
}

define double @exp2_log2_exp2_log2(double %a) {
; CHECK-LABEL: @exp2_log2_exp2_log2(
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.log2.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = call double @llvm.log2.f64(double [[TMP2]])
; CHECK-NEXT:    [[TMP4:%.*]] = call double @llvm.exp2.f64(double [[TMP3]])
; CHECK-NEXT:    ret double [[TMP4]]
;
  %1 = call double @llvm.log2.f64(double %a)
  %2 = call double @llvm.exp2.f64(double %1)
  %3 = call double @llvm.log2.f64(double %2)
  %4 = call double @llvm.exp2.f64(double %3)
  ret double %4
}

define double @exp2_log2_exp2_log2_fast(double %a) {
; CHECK-LABEL: @exp2_log2_exp2_log2_fast(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call fast double @llvm.log2.f64(double %a)
  %2 = call fast double @llvm.exp2.f64(double %1)
  %3 = call fast double @llvm.log2.f64(double %2)
  %4 = call fast double @llvm.exp2.f64(double %3)
  ret double %4
}
