; REQUIRES: x86

; First ensure that the ThinLTO handling in lld handles
; bitcode without summary sections gracefully and generates index file.
; RUN: llvm-as %s -o %t1.o
; RUN: llvm-as %p/Inputs/thinlto.ll -o %t2.o
; RUN: rm -f %t3
; RUN: ld.lld --plugin-opt=thinlto-index-only -shared %t1.o %t2.o -o %t3
; RUN: ls %t2.o.thinlto.bc
; RUN: not test -e %t3
; RUN: ld.lld -shared %t1.o %t2.o -o %t3
; RUN: llvm-nm %t3 | FileCheck %s --check-prefix=NM

; Basic ThinLTO tests.
; RUN: opt -module-summary %s -o %t1.o
; RUN: opt -module-summary %p/Inputs/thinlto.ll -o %t2.o
; RUN: opt -module-summary %p/Inputs/thinlto_empty.ll -o %t3.o

; Ensure lld generates an index and not a binary if requested.
; RUN: rm -f %t4
; RUN: ld.lld --plugin-opt=thinlto-index-only -shared %t1.o %t2.o -o %t4
; RUN: llvm-bcanalyzer -dump %t1.o.thinlto.bc | FileCheck %s --check-prefix=BACKEND1
; RUN: llvm-bcanalyzer -dump %t2.o.thinlto.bc | FileCheck %s --check-prefix=BACKEND2
; RUN: not test -e %t4

; Ensure lld generates an index even if the file is wrapped in --start-lib/--end-lib
; RUN: rm -f %t2.o.thinlto.bc %t4
; RUN: ld.lld --plugin-opt=thinlto-index-only -shared %t1.o %t3.o --start-lib %t2.o --end-lib -o %t4
; RUN: ls %t2.o.thinlto.bc
; RUN: not test -e %t4

; Test that LLD generates an empty index even for lazy object file that is not added to link.
; RUN: rm -f %t1.o.thinlto.bc %t3
; RUN: ld.lld --plugin-opt=thinlto-index-only -shared %t2.o --start-lib %t1.o --end-lib -o %t3
; RUN: ls %t1.o.thinlto.bc

; Ensure lld generates an error if unable to write an empty index file
; for lazy object file that is not added to link.
; RUN: rm -f %t1.o.thinlto.bc
; RUN: touch %t1.o.thinlto.bc
; RUN: chmod 400 %t1.o.thinlto.bc
; RUN: not ld.lld --plugin-opt=thinlto-index-only -shared %t2.o --start-lib %t1.o --end-lib \
; RUN:   -o %t3 2>&1 | FileCheck %s
; CHECK: cannot open {{.*}}1.o.thinlto.bc: {{P|p}}ermission denied
; RUN: rm -f %t1.o.thinlto.bc

; NM: T f

; The backend index for this module contains summaries from itself and
; Inputs/thinlto.ll, as it imports from the latter.
; BACKEND1: <MODULE_STRTAB_BLOCK
; BACKEND1-NEXT: <ENTRY {{.*}} record string = '{{.*}}thinlto-index-only.ll.tmp{{.*}}.o'
; BACKEND1-NEXT: <ENTRY {{.*}} record string = '{{.*}}thinlto-index-only.ll.tmp{{.*}}.o'
; BACKEND1-NEXT: </MODULE_STRTAB_BLOCK
; BACKEND1: <GLOBALVAL_SUMMARY_BLOCK
; BACKEND1: <VERSION
; BACKEND1: <FLAGS
; BACKEND1: <VALUE_GUID op0={{1|2}} op1={{-3706093650706652785|-5300342847281564238}}
; BACKEND1: <VALUE_GUID op0={{1|2}} op1={{-3706093650706652785|-5300342847281564238}}
; BACKEND1: <COMBINED
; BACKEND1: <COMBINED
; BACKEND1: </GLOBALVAL_SUMMARY_BLOCK

; The backend index for Input/thinlto.ll contains summaries from itself only,
; as it does not import anything.
; BACKEND2: <MODULE_STRTAB_BLOCK
; BACKEND2-NEXT: <ENTRY {{.*}} record string = '{{.*}}thinlto-index-only.ll.tmp2.o'
; BACKEND2-NEXT: </MODULE_STRTAB_BLOCK
; BACKEND2-NEXT: <GLOBALVAL_SUMMARY_BLOCK
; BACKEND2-NEXT: <VERSION
; BACKEND2-NEXT: <FLAGS
; BACKEND2-NEXT: <VALUE_GUID op0=1 op1=-5300342847281564238
; BACKEND2-NEXT: <COMBINED
; BACKEND2-NEXT: </GLOBALVAL_SUMMARY_BLOCK

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare void @g(...)

define void @f() {
entry:
  call void (...) @g()
  ret void
}
