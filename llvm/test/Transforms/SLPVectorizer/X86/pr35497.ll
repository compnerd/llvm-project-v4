; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

%class.1 = type { %class.2 }
%class.2 = type { %"class.3" }
%"class.3" = type { %"struct.1", i64 }
%"struct.1" = type { [8 x i64] }

$_ZN1C10SwitchModeEv = comdat any

; Function Attrs: uwtable
define void @_ZN1C10SwitchModeEv() local_unnamed_addr #0 comdat align 2 {
; CHECK-LABEL: @_ZN1C10SwitchModeEv(
; CHECK-NEXT:  for.body.lr.ph.i:
; CHECK-NEXT:    [[OR_1:%.*]] = or i64 undef, 1
; CHECK-NEXT:    store i64 [[OR_1]], i64* undef, align 8
; CHECK-NEXT:    [[FOO_1:%.*]] = getelementptr inbounds [[CLASS_1:%.*]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 0
; CHECK-NEXT:    [[FOO_2:%.*]] = getelementptr inbounds [[CLASS_1]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64* [[FOO_1]] to <2 x i64>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i64>, <2 x i64>* [[TMP0]], align 8
; CHECK-NEXT:    [[BAR5:%.*]] = load i64, i64* undef, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i64> undef, i64 [[OR_1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x i64> [[TMP2]], i64 [[BAR5]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = and <2 x i64> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[BAR3:%.*]] = getelementptr inbounds [[CLASS_2:%.*]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 0
; CHECK-NEXT:    [[BAR4:%.*]] = getelementptr inbounds [[CLASS_2]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 1
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i64* [[BAR3]] to <2 x i64>*
; CHECK-NEXT:    store <2 x i64> [[TMP4]], <2 x i64>* [[TMP5]], align 8
; CHECK-NEXT:    ret void
;
for.body.lr.ph.i:
  %or.1 = or i64 undef, 1
  store i64 %or.1, i64* undef, align 8
  %foo.1 = getelementptr inbounds %class.1, %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 0
  %foo.3 = load i64, i64* %foo.1, align 8
  %foo.2 = getelementptr inbounds %class.1, %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 1
  %foo.4 = load i64, i64* %foo.2, align 8
  %bar5 = load i64, i64* undef, align 8
  %and.2 = and i64 %or.1, %foo.3
  %and.1 = and i64 %bar5, %foo.4
  %bar3 = getelementptr inbounds %class.2, %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 0
  store i64 %and.2, i64* %bar3, align 8
  %bar4 = getelementptr inbounds %class.2, %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 1
  store i64 %and.1, i64* %bar4, align 8
  ret void
}

; Function Attrs: norecurse nounwind uwtable
define void @pr35497() local_unnamed_addr #0 {
; CHECK-LABEL: @pr35497(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, i64* undef, align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i64 undef, undef
; CHECK-NEXT:    store i64 [[ADD]], i64* undef, align 1
; CHECK-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 5
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i64> undef, i64 [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i64> [[TMP1]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i64> <i64 20, i64 20>, [[TMP2]]
; CHECK-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 4
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw <2 x i64> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[ARRAYIDX2_5:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i64> [[TMP4]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i64> undef, i64 [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <2 x i64> [[TMP6]], i64 [[ADD]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = shl <2 x i64> [[TMP7]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP9:%.*]] = and <2 x i64> <i64 20, i64 20>, [[TMP8]]
; CHECK-NEXT:    [[ARRAYIDX2_6:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i64* [[ARRAYIDX2_6]] to <2 x i64>*
; CHECK-NEXT:    store <2 x i64> [[TMP4]], <2 x i64>* [[TMP10]], align 1
; CHECK-NEXT:    [[TMP11:%.*]] = lshr <2 x i64> [[TMP4]], <i64 6, i64 6>
; CHECK-NEXT:    [[TMP12:%.*]] = add nuw nsw <2 x i64> [[TMP9]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i64* [[ARRAYIDX2_2]] to <2 x i64>*
; CHECK-NEXT:    store <2 x i64> [[TMP12]], <2 x i64>* [[TMP13]], align 1
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i64, i64* undef, align 1
  %and = shl i64 %0, 2
  %shl = and i64 %and, 20
  %add = add i64 undef, undef
  store i64 %add, i64* undef, align 1
  %arrayidx2.1 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 5
  %and.1 = shl i64 undef, 2
  %shl.1 = and i64 %and.1, 20
  %shr.1 = lshr i64 undef, 6
  %add.1 = add nuw nsw i64 %shl, %shr.1
  %arrayidx2.2 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 4
  %shr.2 = lshr i64 undef, 6
  %add.2 = add nuw nsw i64 %shl.1, %shr.2
  %and.4 = shl i64 %add, 2
  %shl.4 = and i64 %and.4, 20
  %arrayidx2.5 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 1
  store i64 %add.1, i64* %arrayidx2.5, align 1
  %and.5 = shl nuw nsw i64 %add.1, 2
  %shl.5 = and i64 %and.5, 20
  %shr.5 = lshr i64 %add.1, 6
  %add.5 = add nuw nsw i64 %shl.4, %shr.5
  store i64 %add.5, i64* %arrayidx2.1, align 1
  %arrayidx2.6 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 0
  store i64 %add.2, i64* %arrayidx2.6, align 1
  %shr.6 = lshr i64 %add.2, 6
  %add.6 = add nuw nsw i64 %shl.5, %shr.6
  store i64 %add.6, i64* %arrayidx2.2, align 1
  ret void
}
