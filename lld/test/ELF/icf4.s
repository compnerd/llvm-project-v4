# REQUIRES: x86

# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t
# RUN: ld.lld %t -o %t2 --icf=all --verbose 2>&1 | FileCheck %s

# CHECK-NOT: selected section '.text.f1'
# CHECK-NOT: selected section '.text.f2'

.globl _start, f1, f2
_start:
  ret

.section .text.f1, "ax"
f1:
  mov $1, %rax

.section .text.f2, "ax"
f2:
  mov $0, %rax
