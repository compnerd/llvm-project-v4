// RUN: %clang_cc1 %s -emit-llvm -fprofile-instrument=clang -fsanitize=thread -o - | FileCheck %s

// CHECK: define {{.*}}@foo
// CHECK-NOT: load {{.*}}foo
// CHECK: ret void
void foo() {}
