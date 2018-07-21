; Test ORs of a constant into a byte of memory.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; Check the lowest useful constant, expressed as a signed integer.
define void @f1(i8 *%ptr) {
; CHECK-LABEL: f1:
; CHECK: oi 0(%r2), 1
; CHECK: br %r14
  %val = load i8, i8 *%ptr
  %or = or i8 %val, -255
  store i8 %or, i8 *%ptr
  ret void
}

; Check the highest useful constant, expressed as a signed integer.
define void @f2(i8 *%ptr) {
; CHECK-LABEL: f2:
; CHECK: oi 0(%r2), 254
; CHECK: br %r14
  %val = load i8, i8 *%ptr
  %or = or i8 %val, -2
  store i8 %or, i8 *%ptr
  ret void
}

; Check the lowest useful constant, expressed as an unsigned integer.
define void @f3(i8 *%ptr) {
; CHECK-LABEL: f3:
; CHECK: oi 0(%r2), 1
; CHECK: br %r14
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 1
  store i8 %or, i8 *%ptr
  ret void
}

; Check the highest useful constant, expressed as a unsigned integer.
define void @f4(i8 *%ptr) {
; CHECK-LABEL: f4:
; CHECK: oi 0(%r2), 254
; CHECK: br %r14
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 254
  store i8 %or, i8 *%ptr
  ret void
}

; Check the high end of the OI range.
define void @f5(i8 *%src) {
; CHECK-LABEL: f5:
; CHECK: oi 4095(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 4095
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the next byte up, which should use OIY instead of OI.
define void @f6(i8 *%src) {
; CHECK-LABEL: f6:
; CHECK: oiy 4096(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 4096
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the high end of the OIY range.
define void @f7(i8 *%src) {
; CHECK-LABEL: f7:
; CHECK: oiy 524287(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 524287
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the next byte up, which needs separate address logic.
; Other sequences besides this one would be OK.
define void @f8(i8 *%src) {
; CHECK-LABEL: f8:
; CHECK: agfi %r2, 524288
; CHECK: oi 0(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 524288
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the high end of the negative OIY range.
define void @f9(i8 *%src) {
; CHECK-LABEL: f9:
; CHECK: oiy -1(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 -1
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the low end of the OIY range.
define void @f10(i8 *%src) {
; CHECK-LABEL: f10:
; CHECK: oiy -524288(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 -524288
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check the next byte down, which needs separate address logic.
; Other sequences besides this one would be OK.
define void @f11(i8 *%src) {
; CHECK-LABEL: f11:
; CHECK: agfi %r2, -524289
; CHECK: oi 0(%r2), 127
; CHECK: br %r14
  %ptr = getelementptr i8, i8 *%src, i64 -524289
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check that OI does not allow an index
define void @f12(i64 %src, i64 %index) {
; CHECK-LABEL: f12:
; CHECK: agr %r2, %r3
; CHECK: oi 4095(%r2), 127
; CHECK: br %r14
  %add1 = add i64 %src, %index
  %add2 = add i64 %add1, 4095
  %ptr = inttoptr i64 %add2 to i8 *
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}

; Check that OIY does not allow an index
define void @f13(i64 %src, i64 %index) {
; CHECK-LABEL: f13:
; CHECK: agr %r2, %r3
; CHECK: oiy 4096(%r2), 127
; CHECK: br %r14
  %add1 = add i64 %src, %index
  %add2 = add i64 %add1, 4096
  %ptr = inttoptr i64 %add2 to i8 *
  %val = load i8, i8 *%ptr
  %or = or i8 %val, 127
  store i8 %or, i8 *%ptr
  ret void
}
