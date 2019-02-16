; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -memcpyopt -S %s | FileCheck %s

; memset -> memcpy forwarding, if memcpy is larger than memset, but trailing
; bytes are known to be undef.


%T = type { i64, i32, i32 }

define void @test_alloca(i8* %result) {
; CHECK-LABEL: @test_alloca(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

define void @test_alloca_with_lifetimes(i8* %result) {
; CHECK-LABEL: @test_alloca_with_lifetimes(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[B]])
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* [[B]])
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %b)
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %b)
  ret void
}

define void @test_malloc_with_lifetimes(i8* %result) {
; CHECK-LABEL: @test_malloc_with_lifetimes(
; CHECK-NEXT:    [[A:%.*]] = call i8* @malloc(i64 16)
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[A]])
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* [[A]])
; CHECK-NEXT:    call void @free(i8* [[A]])
; CHECK-NEXT:    ret void
;
  %a = call i8* @malloc(i64 16)
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %a)
  call void @llvm.memset.p0i8.i64(i8* align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %a, i64 16, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %a)
  call void @free(i8* %a)
  ret void
}

; memcpy size is larger than lifetime, don't optimize.
define void @test_copy_larger_than_lifetime_size(i8* %result) {
; CHECK-LABEL: @test_copy_larger_than_lifetime_size(
; CHECK-NEXT:    [[A:%.*]] = call i8* @malloc(i64 16)
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 12, i8* [[A]])
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 12, i8* [[A]])
; CHECK-NEXT:    call void @free(i8* [[A]])
; CHECK-NEXT:    ret void
;
  %a = call i8* @malloc(i64 16)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* %a)
  call void @llvm.memset.p0i8.i64(i8* align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %a, i64 16, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* %a)
  call void @free(i8* %a)
  ret void
}

; The trailing bytes are not known to be undef, we can't ignore them.
define void @test_not_undef_memory(i8* %result, i8* %input) {
; CHECK-LABEL: @test_not_undef_memory(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[INPUT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[INPUT]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* align 8 %input, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %input, i64 16, i1 false)
  ret void
}

; Memset is volatile, memcpy is not. Can be optimized.
define void @test_volatile_memset(i8* %result) {
; CHECK-LABEL: @test_volatile_memset(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 12, i1 true)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 12, i1 true)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

; Memcpy is volatile, memset is not. Cannot be optimized.
define void @test_volatile_memcpy(i8* %result) {
; CHECK-LABEL: @test_volatile_memcpy(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[B]], i64 16, i1 true)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 true)
  ret void
}

; Write between memset and memcpy, can't optimize.
define void @test_write_between(i8* %result) {
; CHECK-LABEL: @test_write_between(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    store i8 -1, i8* [[B]]
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[B]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 12, i1 false)
  store i8 -1, i8* %b
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of the memset region.
; We could optimize this, but currently don't, because the used memory location is imprecise.
define void @test_write_before_memset_in_memset_region(i8* %result) {
; CHECK-LABEL: @test_write_before_memset_in_memset_region(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    store i8 -1, i8* [[B]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[B]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  store i8 -1, i8* %b
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 8, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of the memcpy (but not memset) region.
; This cannot be optimized.
define void @test_write_before_memset_in_memcpy_region(i8* %result) {
; CHECK-LABEL: @test_write_before_memset_in_memcpy_region(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[T]], %T* [[A]], i64 0, i32 2
; CHECK-NEXT:    store i32 -1, i32* [[C]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[B]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  %c = getelementptr inbounds %T, %T* %a, i64 0, i32 2
  store i32 -1, i32* %c
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 8, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of both the memset and memcpy regions.
; This cannot be optimized.
define void @test_write_before_memset_in_both_regions(i8* %result) {
; CHECK-LABEL: @test_write_before_memset_in_both_regions(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[B:%.*]] = bitcast %T* [[A]] to i8*
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[T]], %T* [[A]], i64 0, i32 1
; CHECK-NEXT:    store i32 -1, i32* [[C]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[B]], i8 0, i64 10, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[RESULT:%.*]], i8* align 8 [[B]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %b = bitcast %T* %a to i8*
  %c = getelementptr inbounds %T, %T* %a, i64 0, i32 1
  store i32 -1, i32* %c
  call void @llvm.memset.p0i8.i64(i8* align 8 %b, i8 0, i64 10, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %result, i8* align 8 %b, i64 16, i1 false)
  ret void
}

declare i8* @malloc(i64)
declare void @free(i8*)

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1)

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture)
