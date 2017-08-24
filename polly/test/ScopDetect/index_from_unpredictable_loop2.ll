; RUN: opt %loadPolly -polly-scops -analyze < %s | FileCheck %s --check-prefix=AFFINE
; RUN: opt %loadPolly -polly-scops -polly-allow-nonaffine -analyze < %s | FileCheck %s --check-prefix=NONAFFINE

; The loop for.body => for.inc has an unpredictable iteration count could due to
; the undef start value that it is compared to. Therefore the array element
; %arrayidx101 that depends on that exit value cannot be affine.
; Derived from test-suite/MultiSource/Benchmarks/BitBench/uuencode/uuencode.c

define void @encode_line(i8* nocapture readonly %input, i32 %octets, i64 %p, i32 %n) {
entry:
  br label %outer.for

outer.for:
  %j = phi i32 [0, %entry], [%j.inc, %for.end]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %for.body, label %exit



for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ %p, %outer.for ]
  %octets.addr.02 = phi i32 [ undef, %for.inc ], [ %octets, %outer.for ]
  br i1 false, label %for.inc, label %if.else

if.else:
  %cond = icmp eq i32 %octets.addr.02, 2
  br i1 %cond, label %if.then84, label %for.end

if.then84:
  %0 = add nsw i64 %indvars.iv, 1
  %arrayidx101 = getelementptr inbounds i8, i8* %input, i64 %0
  store i8 42, i8* %arrayidx101, align 1
  br label %for.end

for.inc:
  %cmp = icmp sgt i32 %octets.addr.02, 3
  %indvars.iv.next = add nsw i64 %indvars.iv, 3
  br i1 %cmp, label %for.body, label %for.end



for.end:
  %j.inc = add nuw nsw i32 %j, 1
  br label %outer.for

exit:
  br label %return

return:
  ret void
}


; AFFINE:       Region: %if.else---%for.end

; AFFINE:       Statements {
; AFFINE-NEXT:  	Stmt_if_then84
; AFFINE-NEXT:          Domain :=
; AFFINE-NEXT:              [octets, p_1, p] -> { Stmt_if_then84[] : octets = 2 };
; AFFINE-NEXT:          Schedule :=
; AFFINE-NEXT:              [octets, p_1, p] -> { Stmt_if_then84[] -> [] };
; AFFINE-NEXT:          MustWriteAccess :=	[Reduction Type: NONE] [Scalar: 0]
; AFFINE-NEXT:              [octets, p_1, p] -> { Stmt_if_then84[] -> MemRef_input[1 + p] };
; AFFINE-NEXT:  }


; NONAFFINE:      Region: %outer.for---%return

; NONAFFINE:      Statements {
; NONAFFINE-NEXT: 	Stmt_for_body
; NONAFFINE-NEXT:         Domain :=
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_for_body[i0, 0] : 0 <= i0 < n };
; NONAFFINE-NEXT:         Schedule :=
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_for_body[i0, i1] -> [i0, 0, 0] };
; NONAFFINE-NEXT:         MustWriteAccess :=	[Reduction Type: NONE] [Scalar: 1]
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_for_body[i0, i1] -> MemRef_indvars_iv[] };
; NONAFFINE-NEXT: 	Stmt_if_then84
; NONAFFINE-NEXT:         Domain :=
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_if_then84[i0] : octets = 2 and 0 <= i0 < n };
; NONAFFINE-NEXT:         Schedule :=
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_if_then84[i0] -> [i0, 1, 0] };
; NONAFFINE-NEXT:         ReadAccess :=	[Reduction Type: NONE] [Scalar: 1]
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_if_then84[i0] -> MemRef_indvars_iv[] };
; NONAFFINE-NEXT:         MayWriteAccess :=	[Reduction Type: NONE] [Scalar: 0]
; NONAFFINE-NEXT:             [n, octets] -> { Stmt_if_then84[i0] -> MemRef_input[o0] };
; NONAFFINE-NEXT: }
