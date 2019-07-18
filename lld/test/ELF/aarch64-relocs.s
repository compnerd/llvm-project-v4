# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd %s -o %t
# RUN: echo '.globl zero; zero = 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t2.o
# RUN: ld.lld %t %t2.o -o %t2
# RUN: llvm-objdump -d %t2 | FileCheck %s

.section .R_AARCH64_ADR_PREL_LO21,"ax",@progbits
.globl _start
_start:
  adr x1,msg
msg:  .asciz  "Hello, world\n"
msgend:

# CHECK: Disassembly of section .R_AARCH64_ADR_PREL_LO21:
# CHECK-EMPTY:
# CHECK: _start:
# CHECK:        0:       21 00 00 10     adr     x1, #4
# CHECK: msg:
# CHECK:        4:
# #4 is the adr immediate value.

.section .R_AARCH64_ADR_PREL_PG_H121,"ax",@progbits
  adrp x1,mystr
mystr:
  .asciz "blah"
  .size mystr, 4

# S = 0x210012, A = 0x4, P = 0x210012
# PAGE(S + A) = 0x210000
# PAGE(P) = 0x210000
#
# CHECK: Disassembly of section .R_AARCH64_ADR_PREL_PG_H121:
# CHECK-EMPTY:
# CHECK-NEXT: $x.2:
# CHECK-NEXT:   210012:       01 00 00 90     adrp    x1, #0

.section .R_AARCH64_ADD_ABS_LO12_NC,"ax",@progbits
  add x0, x0, :lo12:.L.str
.L.str:
  .asciz "blah"
  .size mystr, 4

# S = 0x21001b, A = 0x4
# R = (S + A) & 0xFFF = 0x1f
# R << 10 = 0x7c00
#
# CHECK: Disassembly of section .R_AARCH64_ADD_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK-NEXT: $x.4:
# CHECK-NEXT:   21001b:       00 7c 00 91     add     x0, x0, #31

.section .R_AARCH64_LDST64_ABS_LO12_NC,"ax",@progbits
  ldr x28, [x27, :lo12:foo]
foo:
  .asciz "foo"
  .size mystr, 3

# S = 0x210024, A = 0x4
# R = ((S + A) & 0xFFF) << 7 = 0x00001400
# 0x00001400 | 0xf940177c = 0xf940177c
# CHECK: Disassembly of section .R_AARCH64_LDST64_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK-NEXT: $x.6:
# CHECK-NEXT:   210024:       7c 17 40 f9     ldr     x28, [x27, #40]

.section .SUB,"ax",@progbits
  nop
sub:
  nop

# CHECK: Disassembly of section .SUB:
# CHECK-EMPTY:
# CHECK-NEXT: $x.8:
# CHECK-NEXT:   21002c:       1f 20 03 d5     nop
# CHECK: sub:
# CHECK-NEXT:   210030:       1f 20 03 d5     nop

.section .R_AARCH64_CALL26,"ax",@progbits
call26:
        bl sub

# S = 0x21002c, A = 0x4, P = 0x210034
# R = S + A - P = -0x4 = 0xfffffffc
# (R & 0x0ffffffc) >> 2 = 0x03ffffff
# 0x94000000 | 0x03ffffff = 0x97ffffff
# CHECK: Disassembly of section .R_AARCH64_CALL26:
# CHECK-EMPTY:
# CHECK-NEXT: call26:
# CHECK-NEXT:   210034:       ff ff ff 97     bl     #-4

.section .R_AARCH64_JUMP26,"ax",@progbits
jump26:
        b sub

# S = 0x21002c, A = 0x4, P = 0x210038
# R = S + A - P = -0x8 = 0xfffffff8
# (R & 0x0ffffffc) >> 2 = 0x03fffffe
# 0x14000000 | 0x03fffffe = 0x17fffffe
# CHECK: Disassembly of section .R_AARCH64_JUMP26:
# CHECK-EMPTY:
# CHECK-NEXT: jump26:
# CHECK-NEXT:   210038:       fe ff ff 17     b      #-8

.section .R_AARCH64_LDST32_ABS_LO12_NC,"ax",@progbits
ldst32:
  ldr s4, [x5, :lo12:foo32]
foo32:
  .asciz "foo"
  .size mystr, 3

# S = 0x21003c, A = 0x4
# R = ((S + A) & 0xFFC) << 8 = 0x00004000
# 0x00004000 | 0xbd4000a4 = 0xbd4040a4
# CHECK: Disassembly of section .R_AARCH64_LDST32_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK-NEXT: ldst32:
# CHECK-NEXT:   21003c:       a4 40 40 bd     ldr s4, [x5, #64]

.section .R_AARCH64_LDST8_ABS_LO12_NC,"ax",@progbits
ldst8:
  ldrsb x11, [x13, :lo12:foo8]
foo8:
  .asciz "foo"
  .size mystr, 3

# S = 0x210044, A = 0x4
# R = ((S + A) & 0xFFF) << 10 = 0x00012000
# 0x00012000 | 0x398001ab = 0x398121ab
# CHECK: Disassembly of section .R_AARCH64_LDST8_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK-NEXT: ldst8:
# CHECK-NEXT:   210044:       ab 21 81 39     ldrsb x11, [x13, #72]

.section .R_AARCH64_LDST128_ABS_LO12_NC,"ax",@progbits
ldst128:
  ldr q20, [x19, #:lo12:foo128]
foo128:
  .asciz "foo"
  .size mystr, 3

# S = 0x21004c, A = 0x4
# R = ((S + A) & 0xFF8) << 6 = 0x00001400
# 0x00001400 | 0x3dc00274 = 0x3dc01674
# CHECK: Disassembly of section .R_AARCH64_LDST128_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK: ldst128:
# CHECK:   21004c:       74 16 c0 3d     ldr     q20, [x19, #80]
#foo128:
#   210050:       66 6f 6f 00     .word

.section .R_AARCH64_LDST16_ABS_LO12_NC,"ax",@progbits
ldst16:
  ldr h17, [x19, :lo12:foo16]
  ldrh w1, [x19, :lo12:foo16]
  ldrh w2, [x19, :lo12:foo16 + 2]
foo16:
  .asciz "foo"
  .size mystr, 4

# S = 0x210054, A = 0x4
# R = ((S + A) & 0x0FFC) << 9 = 0xb000
# 0xb000 | 0x7d400271 = 0x7d40b271
# CHECK: Disassembly of section .R_AARCH64_LDST16_ABS_LO12_NC:
# CHECK-EMPTY:
# CHECK-NEXT: ldst16:
# CHECK-NEXT:   210054:       71 c2 40 7d     ldr     h17, [x19, #96]
# CHECK-NEXT:   210058:       61 c2 40 79     ldrh    w1, [x19, #96]
# CHECK-NEXT:   21005c:       62 c6 40 79     ldrh    w2, [x19, #98]

.section .R_AARCH64_MOVW_UABS,"ax",@progbits
movz1:
   movk x12, #:abs_g0:zero+0xC
   movk x12, #:abs_g0_nc:zero+0xF000E000D000C
   movk x13, #:abs_g1:zero+0xD000C
   movk x13, #:abs_g1_nc:zero+0xF000E000D000C
   movk x14, #:abs_g2:zero+0xE000D000C
   movk x14, #:abs_g2_nc:zero+0xF000E000D000C
   movz x15, #:abs_g3:zero+0xF000E000D000C
   movk x16, #:abs_g3:zero+0xF000E000D000C

## 4222124650659840 == (0xF << 48)
# CHECK: Disassembly of section .R_AARCH64_MOVW_UABS:
# CHECK-EMPTY:
# CHECK-NEXT: movz1:
# CHECK-NEXT: 8c 01 80 f2   movk  x12, #12
# CHECK-NEXT: 8c 01 80 f2   movk  x12, #12
# CHECK-NEXT: ad 01 a0 f2   movk  x13, #13, lsl #16
# CHECK-NEXT: ad 01 a0 f2   movk  x13, #13, lsl #16
# CHECK-NEXT: ce 01 c0 f2   movk  x14, #14, lsl #32
# CHECK-NEXT: ce 01 c0 f2   movk  x14, #14, lsl #32
# CHECK-NEXT: ef 01 e0 d2   mov x15, #4222124650659840
# CHECK-NEXT: f0 01 e0 f2   movk  x16, #15, lsl #48

.section .R_AARCH64_MOVW_SABS,"ax",@progbits
   movz x1, #:abs_g0_s:zero+1
   movz x1, #:abs_g0_s:zero-1
   movz x2, #:abs_g1_s:zero+0x20000
   movz x2, #:abs_g1_s:zero-0x20000
   movz x3, #:abs_g2_s:zero+0x300000000
   movz x3, #:abs_g2_s:zero-0x300000000

# CHECK: Disassembly of section .R_AARCH64_MOVW_SABS:
# CHECK-EMPTY:
# CHECK-NEXT: :
# CHECK-NEXT: 21 00 80 d2   mov x1, #1
# CHECK-NEXT: 01 00 80 92   mov x1, #-1
# CHECK-NEXT: 42 00 a0 d2   mov x2, #131072
## -65537 = 0xfffffffffffeffff
# CHECK-NEXT: 22 00 a0 92   mov x2, #-65537
## 12884901888 = 0x300000000
# CHECK-NEXT: 63 00 c0 d2   mov x3, #12884901888
## -8589934593 = #0xfffffffdffffffff
# CHECK-NEXT: 43 00 c0 92   mov x3, #-8589934593

.section .R_AARCH64_MOVW_PREL,"ax",@progbits
   movz x1, #:prel_g0:.+1
   movz x1, #:prel_g0_nc:.-1
   movk x1, #:prel_g0:.+1
   movk x1, #:prel_g0_nc:.-1
   movz x2, #:prel_g1:.+0x20000
   movz x2, #:prel_g1_nc:.-0x20000
   movk x2, #:prel_g1:.+0x20000
   movk x2, #:prel_g1_nc:.-0x20000
   movz x3, #:prel_g2:.+0x300000000
   movz x3, #:prel_g2_nc:.-0x300000000
   movk x3, #:prel_g2:.+0x300000000
   movk x3, #:prel_g2_nc:.-0x300000000
   movz x3, #:prel_g2:.+0x300000000
   movz x4, #:prel_g3:.+0x4000000000000
   movz x4, #:prel_g3:.-0x4000000000000
   movk x4, #:prel_g3:.+0x4000000000000
   movk x4, #:prel_g3:.-0x4000000000000

# CHECK: Disassembly of section .R_AARCH64_MOVW_PREL:
# CHECK-EMPTY:
# CHECK-NEXT: :
# CHECK-NEXT: 21009c: 21 00 80 d2  mov	x1, #1
# CHECK-NEXT: 2100a0: 01 00 80 92  mov	x1, #-1
# CHECK-NEXT: 2100a4: 21 00 80 f2  movk	x1, #1
# CHECK-NEXT: 2100a8: e1 ff 9f f2  movk	x1, #65535
# CHECK-NEXT: 2100ac: 42 00 a0 d2  mov	x2, #131072
## -65537 = 0xfffffffffffeffff
# CHECK-NEXT: 2100b0: 22 00 a0 92  mov	x2, #-65537
# CHECK-NEXT: 2100b4: 42 00 a0 f2  movk	x2, #2, lsl #16
# CHECK-NEXT: 2100b8: c2 ff bf f2  movk	x2, #65534, lsl #16
## 12884901888 = 0x300000000
# CHECK-NEXT: 2100bc: 63 00 c0 d2  mov	x3, #12884901888
## -8589934593 = #0xfffffffdffffffff
# CHECK-NEXT: 2100c0: 43 00 c0 92  mov	x3, #-8589934593
# CHECK-NEXT: 2100c4: 63 00 c0 f2  movk	x3, #3, lsl #32
# CHECK-NEXT: 2100c8: a3 ff df f2  movk	x3, #65533, lsl #32
# CHECK-NEXT: 2100cc: 63 00 c0 d2  mov	x3, #12884901888
## 1125899906842624 = 0x4000000000000
# CHECK-NEXT: 2100d0: 84 00 e0 d2  mov	x4, #1125899906842624
# CHECK-NEXT: 2100d4: 84 ff ff d2  mov	x4, #-1125899906842624
# CHECK-NEXT: 2100d8: 84 00 e0 f2  movk	x4, #4, lsl #48
# CHECK-NEXT: 2100dc: 84 ff ff f2  movk	x4, #65532, lsl #48
