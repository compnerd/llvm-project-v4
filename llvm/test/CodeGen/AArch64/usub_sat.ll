; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

declare i4 @llvm.usub.sat.i4(i4, i4)
declare i8 @llvm.usub.sat.i8(i8, i8)
declare i16 @llvm.usub.sat.i16(i16, i16)
declare i32 @llvm.usub.sat.i32(i32, i32)
declare i64 @llvm.usub.sat.i64(i64, i64)

define i32 @func(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: func:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs w8, w0, w1
; CHECK-NEXT:    csel w0, wzr, w8, lo
; CHECK-NEXT:    ret
  %tmp = call i32 @llvm.usub.sat.i32(i32 %x, i32 %y);
  ret i32 %tmp;
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; CHECK-LABEL: func2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x8, x0, x1
; CHECK-NEXT:    csel x0, xzr, x8, lo
; CHECK-NEXT:    ret
  %tmp = call i64 @llvm.usub.sat.i64(i64 %x, i64 %y);
  ret i64 %tmp;
}

define i16 @func16(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: func16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, #16
; CHECK-NEXT:    subs w8, w8, w1, lsl #16
; CHECK-NEXT:    csel w8, wzr, w8, lo
; CHECK-NEXT:    lsr w0, w8, #16
; CHECK-NEXT:    ret
  %tmp = call i16 @llvm.usub.sat.i16(i16 %x, i16 %y);
  ret i16 %tmp;
}

define i8 @func8(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: func8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, #24
; CHECK-NEXT:    subs w8, w8, w1, lsl #24
; CHECK-NEXT:    csel w8, wzr, w8, lo
; CHECK-NEXT:    lsr w0, w8, #24
; CHECK-NEXT:    ret
  %tmp = call i8 @llvm.usub.sat.i8(i8 %x, i8 %y);
  ret i8 %tmp;
}

define i4 @func3(i4 %x, i4 %y) nounwind {
; CHECK-LABEL: func3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, #28
; CHECK-NEXT:    subs w8, w8, w1, lsl #28
; CHECK-NEXT:    csel w8, wzr, w8, lo
; CHECK-NEXT:    lsr w0, w8, #28
; CHECK-NEXT:    ret
  %tmp = call i4 @llvm.usub.sat.i4(i4 %x, i4 %y);
  ret i4 %tmp;
}
