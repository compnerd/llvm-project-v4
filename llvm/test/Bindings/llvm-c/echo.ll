; RUN: llvm-as < %s | llvm-dis > %t.orig
; RUN: llvm-as < %s | llvm-c-test --echo > %t.echo
; RUN: diff -w %t.orig %t.echo

source_filename = "/test/Bindings/echo.ll"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

module asm "classical GAS"

%S = type { i64, %S* }

@var = global i32 42
@ext = external global i32*
@cst = constant %S { i64 1, %S* @cst }
@tl = thread_local global { i64, %S* } { i64 1, %S* @cst }
@arr = linkonce_odr global [5 x i8] [ i8 2, i8 3, i8 5, i8 7, i8 11 ]
@str = private unnamed_addr constant [13 x i8] c"hello world\0A\00"
@locStr = private local_unnamed_addr constant [13 x i8] c"hello world\0A\00"
@hidden = hidden global i32 7
@protected = protected global i32 23
@section = global i32 27, section ".custom"
@align = global i32 31, align 4

@aliased1 = alias i32, i32* @var
@aliased2 = internal alias i32, i32* @var
@aliased3 = external alias i32, i32* @var
@aliased4 = weak alias i32, i32* @var
@aliased5 = weak_odr alias i32, i32* @var

@ifunc = ifunc i32 (i32), i64 ()* @ifunc_resolver

define i64 @ifunc_resolver() {
entry:
  ret i64 0
}

define { i64, %S* } @unpackrepack(%S %s) {
  %1 = extractvalue %S %s, 0
  %2 = extractvalue %S %s, 1
  %3 = insertvalue { i64, %S* } undef, %S* %2, 1
  %4 = insertvalue { i64, %S* } %3, i64 %1, 0
  ret { i64, %S* } %4
}

declare void @decl()

; TODO: label and metadata types
define void @types() {
  %1 = alloca half
  %2 = alloca float
  %3 = alloca double
  %4 = alloca x86_fp80
  %5 = alloca fp128
  %6 = alloca ppc_fp128
  %7 = alloca i7
  %8 = alloca void (i1)*
  %9 = alloca [3 x i22]
  %10 = alloca i328 addrspace(5)*
  %11 = alloca <5 x i23*>
  %12 = alloca x86_mmx
  ret void
}

define i32 @iops(i32 %a, i32 %b) {
  %1 = add i32 %a, %b
  %2 = mul i32 %a, %1
  %3 = sub i32 %2, %1
  %4 = udiv i32 %3, %b
  %5 = sdiv i32 %2, %4
  %6 = urem i32 %3, %5
  %7 = srem i32 %2, %6
  %8 = shl i32 %1, %b
  %9 = lshr i32 %a, %7
  %10 = ashr i32 %b, %8
  %11 = and i32 %9, %10
  %12 = or i32 %2, %11
  %13 = xor i32 %12, %4
  ret i32 %13
}

define i32 @call() {
  %1 = call i32 @iops(i32 23, i32 19)
  ret i32 %1
}

define i32 @cond(i32 %a, i32 %b) {
  br label %br
unreachable:
  unreachable
br:
  %1 = icmp eq i32 %a, %b
  br i1 %1, label %next0, label %unreachable
next0:
  %2 = icmp ne i32 %a, %b
  br i1 %2, label %next1, label %unreachable
next1:
  %3 = icmp ugt i32 %a, %b
  br i1 %3, label %next2, label %unreachable
next2:
  %4 = icmp uge i32 %a, %b
  br i1 %4, label %next3, label %unreachable
next3:
  %5 = icmp ult i32 %a, %b
  br i1 %5, label %next4, label %unreachable
next4:
  %6 = icmp ule i32 %a, %b
  br i1 %6, label %next5, label %unreachable
next5:
  %7 = icmp sgt i32 %a, %b
  br i1 %7, label %next6, label %unreachable
next6:
  %8 = icmp sge i32 %a, %b
  br i1 %8, label %next7, label %unreachable
next7:
  %9 = icmp slt i32 %a, %b
  br i1 %9, label %next8, label %unreachable
next8:
  %10 = icmp sle i32 %a, %b
  br i1 %10, label %next9, label %unreachable
next9:
  ret i32 0
}

define i32 @loop(i32 %i) {
  br label %cond
cond:
  %c = phi i32 [ %i, %0 ], [ %j, %do ]
  %p = phi i32 [ %r, %do ], [ 789, %0 ]
  %1 = icmp eq i32 %c, 0
  br i1 %1, label %do, label %done
do:
  %2 = sub i32 %p, 23
  %j = sub i32 %i, 1
  %r = mul i32 %2, 3
  br label %cond
done:
  ret i32 %p
}

define void @memops(i8* %ptr) {
  %a = load i8, i8* %ptr
  %b = load volatile i8, i8* %ptr
  %c = load i8, i8* %ptr, align 8
  %d = load atomic i8, i8* %ptr acquire, align 32
  store i8 0, i8* %ptr
  store volatile i8 0, i8* %ptr
  store i8 0, i8* %ptr, align 8
  store atomic i8 0, i8* %ptr release, align 32
  %e = atomicrmw add i8* %ptr, i8 0 monotonic
  %f = atomicrmw volatile xchg i8* %ptr, i8 0 acq_rel
  %g = cmpxchg i8* %ptr, i8 1, i8 2 seq_cst acquire
  %h = cmpxchg weak i8* %ptr, i8 1, i8 2 seq_cst acquire
  %i = cmpxchg volatile i8* %ptr, i8 1, i8 2 monotonic monotonic
  ret void
}

declare void @personalityFn()

define void @exn() personality void ()* @personalityFn {
entry:
  invoke void @decl()
          to label %via.cleanup unwind label %exn.dispatch
via.cleanup:
  invoke void @decl()
          to label %via.catchswitch unwind label %cleanup.inner
cleanup.inner:
  %cp.inner = cleanuppad within none []
  cleanupret from %cp.inner unwind label %exn.dispatch
via.catchswitch:
  invoke void @decl()
          to label %exit unwind label %dispatch.inner
dispatch.inner:
  %cs.inner = catchswitch within none [label %pad.inner] unwind label %exn.dispatch
pad.inner:
  %catch.inner = catchpad within %cs.inner [i32 0]
  catchret from %catch.inner to label %exit
exn.dispatch:
  %cs = catchswitch within none [label %pad1, label %pad2] unwind label %cleanup
pad1:
  catchpad within %cs [i32 1]
  unreachable
pad2:
  catchpad within %cs [i32 2]
  unreachable
cleanup:
  %cp = cleanuppad within none []
  cleanupret from %cp unwind to caller
exit:
  ret void
}

define void @with_debuginfo() !dbg !4 {
  ret void, !dbg !7
}

declare i8* @llvm.stacksave()
declare void @llvm.stackrestore(i8*)
declare void @llvm.lifetime.start.p0i8(i64, i8*)
declare void @llvm.lifetime.end.p0i8(i64, i8*)

define void @test_intrinsics() {
entry:
  %sp = call i8* @llvm.stacksave()
  %x = alloca i32
  %0 = bitcast i32* %x to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %0)
  call void @llvm.stackrestore(i8* %sp)
  ret void
}

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!3}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "echo.ll", directory: "/llvm/test/Bindings/llvm-c/echo.ll")
!2 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = distinct !DISubprogram(name: "with_debuginfo", linkageName: "_with_debuginfo", scope: null, file: !1, line: 42, type: !5, isLocal: false, isDefinition: true, scopeLine: 1519, flags: DIFlagPrototyped, isOptimized: true, unit: !0, templateParams: !6, retainedNodes: !6)
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 42, scope: !8, inlinedAt: !11)
!8 = distinct !DILexicalBlock(scope: !9, file: !1, line: 42, column: 12)
!9 = distinct !DISubprogram(name: "fake_inlined_block", linkageName: "_fake_inlined_block", scope: null, file: !1, line: 82, type: !5, isLocal: false, isDefinition: true, scopeLine: 82, flags: DIFlagPrototyped, isOptimized: true, unit: !2, templateParams: !6, retainedNodes: !6)
!10 = distinct !DILocation(line: 84, scope: !8, inlinedAt: !11)
!11 = !DILocation(line: 42, scope: !4)
