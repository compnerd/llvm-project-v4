// RUN: %clang_cc1 -triple i686-unknown-windows-msvc -fdeclspec -emit-llvm %s -o - | FileCheck %s

void __attribute__((__swiftcall__)) f() {}
// CHECK-DAG: @"\01?f@@YSXXZ"

void (__attribute__((__swiftcall__)) *p)();
// CHECK-DAG: @"\01?p@@3P6SXXZA"

namespace {
void __attribute__((__swiftcall__)) __attribute__((__used__)) f() { }
// CHECK-DAG: "\01?f@?A@@YSXXZ"
}

namespace n {
void __attribute__((__swiftcall__)) f() {}
// CHECK-DAG: "\01?f@n@@YSXXZ"
}

struct __declspec(dllexport) S {
  S(const S &) = delete;
  S & operator=(const S &) = delete;
  void __attribute__((__swiftcall__)) m() { }
  // CHECK-DAG: "\01?m@S@@QASXXZ"
};

void f(void (__attribute__((__swiftcall__))())) {}
// CHECK-DAG: "\01?f@@YAXP6SXXZ@Z"

