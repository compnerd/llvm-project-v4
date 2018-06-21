; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer < %s | FileCheck %s
target datalayout = "e-m:x-p:32:32-i64:64-f80:32-n8:16:32-a:0:32-S32"
target triple = "i686-pc-windows-msvc18.0.0"

define void @test1(double* %a, double* %b, double* %c) #0 personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    invoke void @_CxxThrowException(i8* null, i8* null)
; CHECK-NEXT:    to label [[UNREACHABLE:%.*]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[TMP0:%.*]] = catchswitch within none [label %catch] unwind to caller
; CHECK:       catch:
; CHECK-NEXT:    [[TMP1:%.*]] = catchpad within [[TMP0]] [i8* null, i32 64, i8* null]
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds double, double* [[A:%.*]], i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast double* [[A]] to <2 x double>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x double>, <2 x double>* [[TMP2]], align 8
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds double, double* [[B:%.*]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast double* [[B]] to <2 x double>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x double>, <2 x double>* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = fmul <2 x double> [[TMP3]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = call <2 x double> @llvm.floor.v2f64(<2 x double> [[TMP6]]) [ "funclet"(token [[TMP1]]) ]
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds double, double* [[C:%.*]], i64 1
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast double* [[C]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP7]], <2 x double>* [[TMP8]], align 8
; CHECK-NEXT:    catchret from [[TMP1]] to label [[TRY_CONT:%.*]]
; CHECK:       try.cont:
; CHECK-NEXT:    ret void
; CHECK:       unreachable:
; CHECK-NEXT:    unreachable
;
entry:
  invoke void @_CxxThrowException(i8* null, i8* null)
  to label %unreachable unwind label %catch.dispatch

catch.dispatch:                                   ; preds = %entry
  %0 = catchswitch within none [label %catch] unwind to caller

catch:                                            ; preds = %catch.dispatch
  %1 = catchpad within %0 [i8* null, i32 64, i8* null]
  %i0 = load double, double* %a, align 8
  %i1 = load double, double* %b, align 8
  %mul = fmul double %i0, %i1
  %call = tail call double @floor(double %mul) #1 [ "funclet"(token %1) ]
  %arrayidx3 = getelementptr inbounds double, double* %a, i64 1
  %i3 = load double, double* %arrayidx3, align 8
  %arrayidx4 = getelementptr inbounds double, double* %b, i64 1
  %i4 = load double, double* %arrayidx4, align 8
  %mul5 = fmul double %i3, %i4
  %call5 = tail call double @floor(double %mul5) #1 [ "funclet"(token %1) ]
  store double %call, double* %c, align 8
  %arrayidx5 = getelementptr inbounds double, double* %c, i64 1
  store double %call5, double* %arrayidx5, align 8
  catchret from %1 to label %try.cont

try.cont:                                         ; preds = %for.cond.cleanup
  ret void

unreachable:                                      ; preds = %entry
  unreachable
}

declare x86_stdcallcc void @_CxxThrowException(i8*, i8*)

declare i32 @__CxxFrameHandler3(...)

declare double @floor(double) #1

attributes #0 = { "target-features"="+sse2" }
attributes #1 = { nounwind readnone }
