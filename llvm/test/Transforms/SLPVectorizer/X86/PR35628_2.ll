; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-vectorize-hor -slp-vectorize-hor-store -S < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=haswell | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"

define void @test() #0 {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[DUMMY_PHI:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[OP_EXTRA3:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi i64 [ 2, [[ENTRY]] ], [ [[TMP6:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[DUMMY_ADD:%.*]] = add i16 0, 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i64> undef, i64 [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i64> [[TMP1]], i64 [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i64> [[TMP2]], i64 [[TMP0]], i32 2
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i64> [[TMP3]], i64 [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP5:%.*]] = add <4 x i64> [[TMP4]], <i64 3, i64 2, i64 1, i64 0>
; CHECK-NEXT:    [[TMP6]] = extractelement <4 x i64> [[TMP5]], i32 3
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i64> [[TMP5]], i32 0
; CHECK-NEXT:    [[DUMMY_SHL:%.*]] = shl i64 [[TMP7]], 32
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i64> <i64 1, i64 1, i64 1, i64 1>, [[TMP5]]
; CHECK-NEXT:    [[TMP9:%.*]] = ashr exact <4 x i64> [[TMP8]], <i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i64> [[TMP9]], <4 x i64> undef, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <4 x i64> [[TMP9]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <4 x i64> [[BIN_RDX]], <4 x i64> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX2:%.*]] = add <4 x i64> [[BIN_RDX]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i64> [[BIN_RDX2]], i32 0
; CHECK-NEXT:    [[OP_EXTRA:%.*]] = add i64 [[TMP10]], 0
; CHECK-NEXT:    [[OP_EXTRA3]] = add i64 [[OP_EXTRA]], [[TMP6]]
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  br label %loop

loop:
  %dummy_phi = phi i64 [ 1, %entry ], [ %last, %loop ]
  %0 = phi i64 [ 2, %entry ], [ %fork, %loop ]
  %inc1 = add i64 %0, 1
  %inc2 = add i64 %0, 2
  %inc11 = add i64 1, %inc1
  %exact1 = ashr exact i64 %inc11, 32
  %inc3 = add i64 %0, 3
  %dummy_add = add i16 0, 0
  %inc12 = add i64 1, %inc2
  %exact2 = ashr exact i64 %inc12, 32
  %dummy_shl = shl i64 %inc3, 32
  %inc13 = add i64 1, %inc3
  %exact3 = ashr exact i64 %inc13, 32
  %fork = add i64 %0, 0
  %sum1 = add i64 %exact3, %exact2
  %sum2 = add i64 %sum1, %exact1
  %zsum = add i64 %sum2, 0
  %sext22 = add i64 1, %fork
  %exact4 = ashr exact i64 %sext22, 32
  %join = add i64 %fork, %zsum
  %last = add i64 %join, %exact4
  br label %loop
}

