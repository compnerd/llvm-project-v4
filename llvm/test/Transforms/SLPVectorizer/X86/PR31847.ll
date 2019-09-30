; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -o - -mtriple=i386 -mcpu=haswell < %s | FileCheck %s
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"

@shift = common local_unnamed_addr global [10 x i32] zeroinitializer, align 4
@data = common local_unnamed_addr global [10 x i8*] zeroinitializer, align 4

define void @flat(i32 %intensity) {
; CHECK-LABEL: @flat(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @shift, i32 0, i32 0), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @shift, i32 0, i32 1), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i8*, i8** getelementptr inbounds ([10 x i8*], [10 x i8*]* @data, i32 0, i32 0), align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load i8*, i8** getelementptr inbounds ([10 x i8*], [10 x i8*]* @data, i32 0, i32 1), align 4
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 1, [[TMP0]]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8* [[TMP2]], i32 [[SHR]]
; CHECK-NEXT:    [[SHR1:%.*]] = lshr i32 1, [[TMP1]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i8, i8* [[TMP3]], i32 [[SHR1]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[D1_DATA_046:%.*]] = phi i8* [ [[TMP3]], [[ENTRY:%.*]] ], [ [[ADD_PTR23_1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[Y_045:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[INC_1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = load i8, i8* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[TMP4]] to i32
; CHECK-NEXT:    [[SUB:%.*]] = add nsw i32 [[CONV]], -128
; CHECK-NEXT:    [[TMP5:%.*]] = load i8, i8* [[ARRAYIDX2]], align 1
; CHECK-NEXT:    [[CONV3:%.*]] = zext i8 [[TMP5]] to i32
; CHECK-NEXT:    [[SUB4:%.*]] = add nsw i32 [[CONV3]], -128
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[SUB]], -1
; CHECK-NEXT:    [[SUB7:%.*]] = sub nsw i32 128, [[CONV]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP5]], i32 [[SUB]], i32 [[SUB7]]
; CHECK-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[SUB4]], -1
; CHECK-NEXT:    [[SUB12:%.*]] = sub nsw i32 128, [[CONV3]]
; CHECK-NEXT:    [[COND14:%.*]] = select i1 [[CMP8]], i32 [[SUB4]], i32 [[SUB12]]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[COND14]], [[COND]]
; CHECK-NEXT:    [[IDX_NEG:%.*]] = sub nsw i32 0, [[ADD]]
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8* [[D1_DATA_046]], i32 [[IDX_NEG]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i8, i8* [[ADD_PTR]], align 1
; CHECK-NEXT:    [[CONV15:%.*]] = zext i8 [[TMP6]] to i32
; CHECK-NEXT:    [[ADD16:%.*]] = add nsw i32 [[CONV15]], [[INTENSITY:%.*]]
; CHECK-NEXT:    [[CONV17:%.*]] = trunc i32 [[ADD16]] to i8
; CHECK-NEXT:    store i8 [[CONV17]], i8* [[ADD_PTR]], align 1
; CHECK-NEXT:    [[ADD_PTR18:%.*]] = getelementptr inbounds i8, i8* [[D1_DATA_046]], i32 [[ADD]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i8, i8* [[ADD_PTR18]], align 1
; CHECK-NEXT:    [[NOT_TOBOOL:%.*]] = icmp eq i8 [[TMP7]], 0
; CHECK-NEXT:    [[CONV21:%.*]] = zext i1 [[NOT_TOBOOL]] to i8
; CHECK-NEXT:    store i8 [[CONV21]], i8* [[ADD_PTR18]], align 1
; CHECK-NEXT:    [[ADD_PTR23:%.*]] = getelementptr inbounds i8, i8* [[D1_DATA_046]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i8, i8* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[CONV_1:%.*]] = zext i8 [[TMP8]] to i32
; CHECK-NEXT:    [[SUB_1:%.*]] = add nsw i32 [[CONV_1]], -128
; CHECK-NEXT:    [[TMP9:%.*]] = load i8, i8* [[ARRAYIDX2]], align 1
; CHECK-NEXT:    [[CONV3_1:%.*]] = zext i8 [[TMP9]] to i32
; CHECK-NEXT:    [[SUB4_1:%.*]] = add nsw i32 [[CONV3_1]], -128
; CHECK-NEXT:    [[CMP5_1:%.*]] = icmp sgt i32 [[SUB_1]], -1
; CHECK-NEXT:    [[SUB7_1:%.*]] = sub nsw i32 128, [[CONV_1]]
; CHECK-NEXT:    [[COND_1:%.*]] = select i1 [[CMP5_1]], i32 [[SUB_1]], i32 [[SUB7_1]]
; CHECK-NEXT:    [[CMP8_1:%.*]] = icmp sgt i32 [[SUB4_1]], -1
; CHECK-NEXT:    [[SUB12_1:%.*]] = sub nsw i32 128, [[CONV3_1]]
; CHECK-NEXT:    [[COND14_1:%.*]] = select i1 [[CMP8_1]], i32 [[SUB4_1]], i32 [[SUB12_1]]
; CHECK-NEXT:    [[ADD_1:%.*]] = add nsw i32 [[COND14_1]], [[COND_1]]
; CHECK-NEXT:    [[IDX_NEG_1:%.*]] = sub nsw i32 0, [[ADD_1]]
; CHECK-NEXT:    [[ADD_PTR_1:%.*]] = getelementptr inbounds i8, i8* [[ADD_PTR23]], i32 [[IDX_NEG_1]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i8, i8* [[ADD_PTR_1]], align 1
; CHECK-NEXT:    [[CONV15_1:%.*]] = zext i8 [[TMP10]] to i32
; CHECK-NEXT:    [[ADD16_1:%.*]] = add nsw i32 [[CONV15_1]], [[INTENSITY]]
; CHECK-NEXT:    [[CONV17_1:%.*]] = trunc i32 [[ADD16_1]] to i8
; CHECK-NEXT:    store i8 [[CONV17_1]], i8* [[ADD_PTR_1]], align 1
; CHECK-NEXT:    [[ADD_PTR18_1:%.*]] = getelementptr inbounds i8, i8* [[ADD_PTR23]], i32 [[ADD_1]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i8, i8* [[ADD_PTR18_1]], align 1
; CHECK-NEXT:    [[NOT_TOBOOL_1:%.*]] = icmp eq i8 [[TMP11]], 0
; CHECK-NEXT:    [[CONV21_1:%.*]] = zext i1 [[NOT_TOBOOL_1]] to i8
; CHECK-NEXT:    store i8 [[CONV21_1]], i8* [[ADD_PTR18_1]], align 1
; CHECK-NEXT:    [[ADD_PTR23_1]] = getelementptr inbounds i8, i8* [[ADD_PTR23]], i32 [[TMP1]]
; CHECK-NEXT:    [[INC_1]] = add nsw i32 [[Y_045]], 2
; CHECK-NEXT:    [[EXITCOND_1:%.*]] = icmp eq i32 [[INC_1]], 128
; CHECK-NEXT:    br i1 [[EXITCOND_1]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
entry:
  %0 = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @shift, i32 0, i32 0), align 4
  %1 = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @shift, i32 0, i32 1), align 4
  %2 = load i8*, i8** getelementptr inbounds ([10 x i8*], [10 x i8*]* @data, i32 0, i32 0), align 4
  %3 = load i8*, i8** getelementptr inbounds ([10 x i8*], [10 x i8*]* @data, i32 0, i32 1), align 4
  %shr = lshr i32 1, %0
  %arrayidx = getelementptr inbounds i8, i8* %2, i32 %shr
  %shr1 = lshr i32 1, %1
  %arrayidx2 = getelementptr inbounds i8, i8* %3, i32 %shr1
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %for.body, %entry
  %d1_data.046 = phi i8* [ %3, %entry ], [ %add.ptr23.1, %for.body ]
  %y.045 = phi i32 [ 0, %entry ], [ %inc.1, %for.body ]
  %4 = load i8, i8* %arrayidx, align 1
  %conv = zext i8 %4 to i32
  %sub = add nsw i32 %conv, -128
  %5 = load i8, i8* %arrayidx2, align 1
  %conv3 = zext i8 %5 to i32
  %sub4 = add nsw i32 %conv3, -128
  %cmp5 = icmp sgt i32 %sub, -1
  %sub7 = sub nsw i32 128, %conv
  %cond = select i1 %cmp5, i32 %sub, i32 %sub7
  %cmp8 = icmp sgt i32 %sub4, -1
  %sub12 = sub nsw i32 128, %conv3
  %cond14 = select i1 %cmp8, i32 %sub4, i32 %sub12
  %add = add nsw i32 %cond14, %cond
  %idx.neg = sub nsw i32 0, %add
  %add.ptr = getelementptr inbounds i8, i8* %d1_data.046, i32 %idx.neg
  %6 = load i8, i8* %add.ptr, align 1
  %conv15 = zext i8 %6 to i32
  %add16 = add nsw i32 %conv15, %intensity
  %conv17 = trunc i32 %add16 to i8
  store i8 %conv17, i8* %add.ptr, align 1
  %add.ptr18 = getelementptr inbounds i8, i8* %d1_data.046, i32 %add
  %7 = load i8, i8* %add.ptr18, align 1
  %not.tobool = icmp eq i8 %7, 0
  %conv21 = zext i1 %not.tobool to i8
  store i8 %conv21, i8* %add.ptr18, align 1
  %add.ptr23 = getelementptr inbounds i8, i8* %d1_data.046, i32 %1
  %8 = load i8, i8* %arrayidx, align 1
  %conv.1 = zext i8 %8 to i32
  %sub.1 = add nsw i32 %conv.1, -128
  %9 = load i8, i8* %arrayidx2, align 1
  %conv3.1 = zext i8 %9 to i32
  %sub4.1 = add nsw i32 %conv3.1, -128
  %cmp5.1 = icmp sgt i32 %sub.1, -1
  %sub7.1 = sub nsw i32 128, %conv.1
  %cond.1 = select i1 %cmp5.1, i32 %sub.1, i32 %sub7.1
  %cmp8.1 = icmp sgt i32 %sub4.1, -1
  %sub12.1 = sub nsw i32 128, %conv3.1
  %cond14.1 = select i1 %cmp8.1, i32 %sub4.1, i32 %sub12.1
  %add.1 = add nsw i32 %cond14.1, %cond.1
  %idx.neg.1 = sub nsw i32 0, %add.1
  %add.ptr.1 = getelementptr inbounds i8, i8* %add.ptr23, i32 %idx.neg.1
  %10 = load i8, i8* %add.ptr.1, align 1
  %conv15.1 = zext i8 %10 to i32
  %add16.1 = add nsw i32 %conv15.1, %intensity
  %conv17.1 = trunc i32 %add16.1 to i8
  store i8 %conv17.1, i8* %add.ptr.1, align 1
  %add.ptr18.1 = getelementptr inbounds i8, i8* %add.ptr23, i32 %add.1
  %11 = load i8, i8* %add.ptr18.1, align 1
  %not.tobool.1 = icmp eq i8 %11, 0
  %conv21.1 = zext i1 %not.tobool.1 to i8
  store i8 %conv21.1, i8* %add.ptr18.1, align 1
  %add.ptr23.1 = getelementptr inbounds i8, i8* %add.ptr23, i32 %1
  %inc.1 = add nsw i32 %y.045, 2
  %exitcond.1 = icmp eq i32 %inc.1, 128
  br i1 %exitcond.1, label %for.cond.cleanup, label %for.body
}
