; RUN: opt %loadPolly -polly-scops -analyze -polly-print-instructions < %s | FileCheck %s
;
; CHECK:    Statements {
; CHECK-NEXT:  	Stmt_Stmt
; CHECK-NEXT:       Domain :=
; CHECK-NEXT:           { Stmt_Stmt[i0, i1] : 0 <= i0 <= 1023 and 0 <= i1 <= 512 };
; CHECK-NEXT:       Schedule :=
; CHECK-NEXT:           { Stmt_Stmt[i0, i1] -> [i0, i1, 0] };
; CHECK-NEXT:       MustWriteAccess :=	[Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:           { Stmt_Stmt[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT:       Instructions {
; CHECK-NEXT:             store i32 %i.0, i32* %arrayidx, align 4, !polly_split_after !0
; CHECK-NEXT:       }
; CHECK-NEXT:  	Stmt_Stmt_b
; CHECK-NEXT:       Domain :=
; CHECK-NEXT:           { Stmt_Stmt_b[i0, i1] : 0 <= i0 <= 1023 and 0 <= i1 <= 512 };
; CHECK-NEXT:       Schedule :=
; CHECK-NEXT:           { Stmt_Stmt_b[i0, i1] -> [i0, i1, 1] };
; CHECK-NEXT:       MustWriteAccess :=	[Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:           { Stmt_Stmt_b[i0, i1] -> MemRef_B[i0] };
; CHECK-NEXT:       Instructions {
; CHECK-NEXT:             store i32 %i.0, i32* %arrayidx2, align 4
; CHECK-NEXT:             %cond = icmp slt i32 %j, 512
; CHECK-NEXT:       }
; CHECK-NEXT:   }
;
; Function Attrs: noinline nounwind uwtable
define void @func(i32* %A, i32* %B, double* %C) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %add, %for.inc ]
  %cmp = icmp slt i32 %i.0, 1024
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %Stmt

Stmt:
  %j = phi i32 [ 0, %for.body ], [ %inc, %Stmt ]
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %A, i64 %idxprom
  store i32 %i.0, i32* %arrayidx, align 4, !polly_split_after !0
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %B, i64 %idxprom1
  store i32 %i.0, i32* %arrayidx2, align 4
  %inc = add nsw i32 %j, 1
  %cond = icmp slt i32 %j, 512
  br i1 %cond, label %Stmt, label %for.inc

for.inc:                                          ; preds = %Stmt
  %add = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

!0 = !{!"polly_split_after"}
