; RUN: opt %loadPolly -polly-stmt-granularity=scalar-indep -polly-print-instructions -polly-scops -analyze < %s | FileCheck %s -match-full-lines
;
; Split a block into two independent statements that share no scalar.
; This case has an independent statement just for PHI writes.
;
; for (int j = 0; j < n; j += 1) {
; bodyA:
;   double valA = A[0];
;   A[0] = valA;
;
; bodyB:
;   phi = 42.0;
; }
;
define void @func(i32 %n, double* noalias nonnull %A) {
entry:
  br label %for

for:
  %j = phi i32 [0, %entry], [%j.inc, %inc]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %bodyA, label %exit

    bodyA:
      %valA = load double, double* %A
      store double %valA, double* %A
      br label %bodyB

    bodyB:
      %phi = phi double [42.0, %bodyA]
      br label %inc

inc:
  %j.inc = add nuw nsw i32 %j, 1
  br label %for

exit:
  br label %return

return:
  ret void
}


; CHECK:      Statements {
; CHECK-NEXT:     Stmt_bodyA
; CHECK-NEXT:         Domain :=
; CHECK-NEXT:             [n] -> { Stmt_bodyA[i0] : 0 <= i0 < n };
; CHECK-NEXT:         Schedule :=
; CHECK-NEXT:             [n] -> { Stmt_bodyA[i0] -> [i0, 0] };
; CHECK-NEXT:         ReadAccess :=       [Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:             [n] -> { Stmt_bodyA[i0] -> MemRef_A[0] };
; CHECK-NEXT:         MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:             [n] -> { Stmt_bodyA[i0] -> MemRef_A[0] };
; CHECK-NEXT:         Instructions {
; CHECK-NEXT:             %valA = load double, double* %A
; CHECK-NEXT:             store double %valA, double* %A
; CHECK-NEXT:         }
; CHECK-NEXT:     Stmt_bodyA_b
; CHECK-NEXT:         Domain :=
; CHECK-NEXT:             [n] -> { Stmt_bodyA_b[i0] : 0 <= i0 < n };
; CHECK-NEXT:         Schedule :=
; CHECK-NEXT:             [n] -> { Stmt_bodyA_b[i0] -> [i0, 1] };
; CHECK-NEXT:         MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:             [n] -> { Stmt_bodyA_b[i0] -> MemRef_phi__phi[] };
; CHECK-NEXT:         Instructions {
; CHECK-NEXT:         }
; CHECK-NEXT: }
