// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -emit-llvm %s -o - | FileCheck %s
struct x { int a[100]; };

// CHECK-LABEL: @foo(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[P_ADDR:%.*]] = alloca %struct.x*, align 8
// CHECK-NEXT:    [[Q_ADDR:%.*]] = alloca %struct.x*, align 8
// CHECK-NEXT:    store %struct.x* [[P:%.*]], %struct.x** [[P_ADDR]], align 8
// CHECK-NEXT:    store %struct.x* [[Q:%.*]], %struct.x** [[Q_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load %struct.x*, %struct.x** [[P_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = load %struct.x*, %struct.x** [[Q_ADDR]], align 8
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast %struct.x* [[TMP0]] to i8*
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast %struct.x* [[TMP1]] to i8*
// CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[TMP2]], i8* align 4 [[TMP3]], i64 400, i1 false)
// CHECK-NEXT:    ret void
//
void foo(struct x *P, struct x *Q) {
  *P = *Q;
}

// CHECK: declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)

// CHECK-LABEL: @bar(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[P_ADDR:%.*]] = alloca %struct.x*, align 8
// CHECK-NEXT:    [[Q_ADDR:%.*]] = alloca %struct.x*, align 8
// CHECK-NEXT:    store %struct.x* [[P:%.*]], %struct.x** [[P_ADDR]], align 8
// CHECK-NEXT:    store %struct.x* [[Q:%.*]], %struct.x** [[Q_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load %struct.x*, %struct.x** [[P_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast %struct.x* [[TMP0]] to i8*
// CHECK-NEXT:    [[TMP2:%.*]] = load %struct.x*, %struct.x** [[Q_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast %struct.x* [[TMP2]] to i8*
// CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[TMP1]], i8* align 4 [[TMP3]], i64 400, i1 false)
// CHECK-NEXT:    ret void
//
void bar(struct x *P, struct x *Q) {
  __builtin_memcpy(P, Q, sizeof(struct x));
}
