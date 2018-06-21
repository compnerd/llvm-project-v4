; RUN: llvm-as -o %t.bc %s
; RUN: rm -f %t.lto.o %t1.lto.o
; RUN: wasm-ld --lto-partitions=2 -save-temps -o %t %t.bc -r
; RUN: llvm-nm %t.lto.o | FileCheck --check-prefix=CHECK0 %s
; RUN: llvm-nm %t1.lto.o | FileCheck --check-prefix=CHECK1 %s

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown-wasm"

; CHECK0-NOT: bar
; CHECK0: T foo
; CHECK0-NOT: bar
define void @foo() {
  call void @bar()
  ret void
}

; CHECK1-NOT: foo
; CHECK1: T bar
; CHECK1-NOT: foo
define void @bar() {
  call void @foo()
  ret void
}
