; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basicaa -newgvn -S < %s | FileCheck %s

; Function Attrs: noinline norecurse nounwind readonly ssp uwtable
define i32 @mp_unsgn_cmp(i32 %n, i32* nocapture readonly %in1, i32* nocapture readonly %in2) local_unnamed_addr {
; CHECK-LABEL: @mp_unsgn_cmp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP11:%.*]] = icmp sgt i32 [[N:%.*]], -1
; CHECK-NEXT:    br i1 [[CMP11]], label [[FOR_INC_PREHEADER:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       for.inc.preheader:
; CHECK-NEXT:    br label [[FOR_INC:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[STOREMERGE2:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_INC]] ], [ 0, [[FOR_INC_PREHEADER]] ]
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[STOREMERGE2]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[IN1:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[IN2:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX4]], align 4
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[INC]] = add nsw i32 [[STOREMERGE2]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[STOREMERGE2]], [[N]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[SUB]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[CMP2]], [[CMP1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FOR_INC]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[IF_END8:%.*]], label [[IF_ELSE]]
; CHECK:       if.else:
; CHECK-NEXT:    [[SUB1_LCSSA4:%.*]] = phi i32 [ [[SUB]], [[FOR_END]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CMP6:%.*]] = icmp slt i32 [[SUB1_LCSSA4]], 0
; CHECK-NEXT:    [[DOTSUB1_LCSSA:%.*]] = select i1 [[CMP6]], i32 -1, i32 [[SUB1_LCSSA4]]
; CHECK-NEXT:    ret i32 [[DOTSUB1_LCSSA]]
; CHECK:       if.end8:
; CHECK-NEXT:    ret i32 1
;
entry:
  %cmp11 = icmp sgt i32 %n, -1
  br i1 %cmp11, label %for.inc.preheader, label %if.else

for.inc.preheader:                                ; preds = %entry
  br label %for.inc

for.inc:                                          ; preds = %for.inc.preheader, %for.inc
  %storemerge2 = phi i32 [ %inc, %for.inc ], [ 0, %for.inc.preheader ]
  %idxprom = sext i32 %storemerge2 to i64
  %arrayidx = getelementptr inbounds i32, i32* %in1, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx4 = getelementptr inbounds i32, i32* %in2, i64 %idxprom
  %1 = load i32, i32* %arrayidx4, align 4
  %sub = sub nsw i32 %0, %1
  %inc = add nsw i32 %storemerge2, 1
  %cmp1 = icmp slt i32 %storemerge2, %n
  %cmp2 = icmp eq i32 %sub, 0
  %or.cond = and i1 %cmp2, %cmp1
;; This is a self-critical edge to for.inc. If we insert predicate info on it, we will insert
;; predicateinfo at the end of this block, and think it dominates everthing using only dfs
;; numbers, instead of proper edge dominance.  We would then proceed to propagate the true value
;; of sub == 0 everywhere, making this function only ever return 0.
  br i1 %or.cond, label %for.inc, label %for.end

for.end:                                          ; preds = %for.inc
  %sub.lcssa = phi i32 [ %sub, %for.inc ]
  %cmp5 = icmp sgt i32 %sub.lcssa, 0
  br i1 %cmp5, label %if.end8, label %if.else

if.else:                                          ; preds = %entry, %for.end
  %sub1.lcssa4 = phi i32 [ %sub.lcssa, %for.end ], [ 0, %entry ]
  %cmp6 = icmp slt i32 %sub1.lcssa4, 0
  %.sub1.lcssa = select i1 %cmp6, i32 -1, i32 %sub1.lcssa4
  ret i32 %.sub1.lcssa

if.end8:                                          ; preds = %for.end
  ret i32 1
}


;; This test will generate a copy of a copy of predicateinfo to the multiple uses
;; of branch conditions below.  Make sure we don't try to extract operand info.
; Function Attrs: uwtable
define fastcc void @barney() {
; CHECK-LABEL: @barney(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB22:%.*]]
; CHECK:       bb22:
; CHECK-NEXT:    br i1 undef, label [[BB29:%.*]], label [[BB35:%.*]]
; CHECK:       bb29:
; CHECK-NEXT:    br i1 true, label [[BB33:%.*]], label [[BB35]]
; CHECK:       bb33:
; CHECK-NEXT:    br i1 true, label [[BB35]], label [[BB35]]
; CHECK:       bb35:
; CHECK-NEXT:    unreachable
;
bb:
  br label %bb22
bb22:                                             ; preds = %bb21
  %tmp23 = icmp eq i32 undef, 2
  br i1 %tmp23, label %bb29, label %bb35


bb29:                                             ; preds = %bb28
  br i1 %tmp23, label %bb33, label %bb35


bb33:                                             ; preds = %bb31
  br i1 %tmp23, label %bb35, label %bb35


bb35:                                             ; preds = %bb33, %bb29, %bb22
  unreachable
}

