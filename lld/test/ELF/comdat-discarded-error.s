# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64 %s -o %t1.o
# RUN: echo '.section .text.foo,"axG",@progbits,foo,comdat; .globl foo; foo:' |\
# RUN:   llvm-mc -filetype=obj -triple=x86_64 - -o %t2.o
# RUN: echo '.section .text.foo,"axG",@progbits,foo,comdat; .globl bar; bar:' |\
# RUN:   llvm-mc -filetype=obj -triple=x86_64 - -o %t3.o

# RUN: not ld.lld %t1.o %t2.o %t3.o -o /dev/null 2>&1 | FileCheck %s

# CHECK:      error: relocation refers to a symbol in a discarded section: bar
# CHECK-NEXT: >>> defined in {{.*}}3.o
# CHECK-NEXT: >>> section group signature: foo
# CHECK-NEXT: >>> prevailing definition is in {{.*}}2.o
# CHECK-NEXT: >>> referenced by {{.*}}1.o:(.text+0x1)

.globl _start
_start:
  jmp bar
