; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

;------------------------------------------------------------------------------;
; Odd divisors
;------------------------------------------------------------------------------;

define i32 @test_srem_odd(i32 %X) nounwind {
; CHECK-LABEL: test_srem_odd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #26215
; CHECK-NEXT:    movk w8, #26214, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #33
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    add w8, w8, w8, lsl #2
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 5
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @test_srem_odd_25(i32 %X) nounwind {
; CHECK-LABEL: test_srem_odd_25:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #34079
; CHECK-NEXT:    movk w8, #20971, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #35
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #25
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 25
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_srem_odd, except the divisor has bit 30 set.
define i32 @test_srem_odd_bit30(i32 %X) nounwind {
; CHECK-LABEL: test_srem_odd_bit30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sxtw x8, w0
; CHECK-NEXT:    sbfiz x9, x0, #29, #32
; CHECK-NEXT:    sub x8, x9, x8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #59
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #3
; CHECK-NEXT:    movk w9, #16384, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 1073741827
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_srem_odd, except the divisor has bit 31 set.
define i32 @test_srem_odd_bit31(i32 %X) nounwind {
; CHECK-LABEL: test_srem_odd_bit31:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sxtw x8, w0
; CHECK-NEXT:    add x8, x8, x8, lsl #29
; CHECK-NEXT:    neg x8, x8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #60
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #-2147483645
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 2147483651
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

;------------------------------------------------------------------------------;
; Even divisors
;------------------------------------------------------------------------------;

define i16 @test_srem_even(i16 %X) nounwind {
; CHECK-LABEL: test_srem_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #9363
; CHECK-NEXT:    sxth w8, w0
; CHECK-NEXT:    movk w9, #37449, lsl #16
; CHECK-NEXT:    smull x9, w8, w9
; CHECK-NEXT:    lsr x9, x9, #32
; CHECK-NEXT:    add w8, w9, w8
; CHECK-NEXT:    asr w9, w8, #3
; CHECK-NEXT:    add w8, w9, w8, lsr #31
; CHECK-NEXT:    mov w9, #14
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    tst w8, #0xffff
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %srem = srem i16 %X, 14
  %cmp = icmp ne i16 %srem, 0
  %ret = zext i1 %cmp to i16
  ret i16 %ret
}

define i32 @test_srem_even_100(i32 %X) nounwind {
; CHECK-LABEL: test_srem_even_100:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #34079
; CHECK-NEXT:    movk w8, #20971, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #37
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #100
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 100
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_srem_even, except the divisor has bit 30 set.
define i32 @test_srem_even_bit30(i32 %X) nounwind {
; CHECK-LABEL: test_srem_even_bit30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65433
; CHECK-NEXT:    movk w8, #16383, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #60
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #104
; CHECK-NEXT:    movk w9, #16384, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 1073741928
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_srem_odd, except the divisor has bit 31 set.
define i32 @test_srem_even_bit31(i32 %X) nounwind {
; CHECK-LABEL: test_srem_even_bit31:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65433
; CHECK-NEXT:    movk w8, #32767, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x8, x8, #32
; CHECK-NEXT:    sub w8, w8, w0
; CHECK-NEXT:    asr w9, w8, #30
; CHECK-NEXT:    add w8, w9, w8, lsr #31
; CHECK-NEXT:    mov w9, #102
; CHECK-NEXT:    movk w9, #32768, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 2147483750
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

;------------------------------------------------------------------------------;
; Special case
;------------------------------------------------------------------------------;

; 'NE' predicate is fine too.
define i32 @test_srem_odd_setne(i32 %X) nounwind {
; CHECK-LABEL: test_srem_odd_setne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #26215
; CHECK-NEXT:    movk w8, #26214, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #33
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    add w8, w8, w8, lsl #2
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 5
  %cmp = icmp ne i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

;------------------------------------------------------------------------------;
; Negative tests
;------------------------------------------------------------------------------;

; The fold is invalid if divisor is 1.
define i32 @test_srem_one(i32 %X) nounwind {
; CHECK-LABEL: test_srem_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #1
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 1
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We can lower remainder of division by all-ones much better elsewhere.
define i32 @test_srem_allones(i32 %X) nounwind {
; CHECK-LABEL: test_srem_allones:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    csel w8, w0, w0, lt
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 4294967295
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We can lower remainder of division by powers of two much better elsewhere.
define i32 @test_srem_pow2(i32 %X) nounwind {
; CHECK-LABEL: test_srem_pow2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #15 // =15
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    csel w8, w8, w0, lt
; CHECK-NEXT:    and w8, w8, #0xfffffff0
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i32 %X, 16
  %cmp = icmp eq i32 %srem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}
