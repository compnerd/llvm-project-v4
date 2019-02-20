// RUN: %clang_cc1 -std=c++11 -triple x86_64-linux-gnu -emit-llvm %s -o - | FileCheck %s --check-prefix=LINUX
// RUN: %clang_cc1 -std=c++11 -triple x86_64-windows-pc -emit-llvm %s -o - | FileCheck %s --check-prefix=WINDOWS

int __attribute__((target("sse4.2"))) foo_overload(int) { return 0; }
int __attribute__((target("arch=sandybridge"))) foo_overload(int);
int __attribute__((target("arch=ivybridge"))) foo_overload(int) {return 1;}
int __attribute__((target("default"))) foo_overload(int) { return 2; }
int __attribute__((target("sse4.2"))) foo_overload(void) { return 0; }
int __attribute__((target("arch=sandybridge"))) foo_overload(void);
int __attribute__((target("arch=ivybridge"))) foo_overload(void) {return 1;}
int __attribute__((target("default"))) foo_overload(void) { return 2; }

int bar2() {
  return foo_overload() + foo_overload(1);
}

// LINUX: @_Z12foo_overloadv.ifunc = ifunc i32 (), i32 ()* ()* @_Z12foo_overloadv.resolver
// LINUX: @_Z12foo_overloadi.ifunc = ifunc i32 (i32), i32 (i32)* ()* @_Z12foo_overloadi.resolver

// LINUX: define i32 @_Z12foo_overloadi.sse4.2(i32)
// LINUX: ret i32 0
// LINUX: define i32 @_Z12foo_overloadi.arch_ivybridge(i32)
// LINUX: ret i32 1
// LINUX: define i32 @_Z12foo_overloadi(i32)
// LINUX: ret i32 2
// LINUX: define i32 @_Z12foo_overloadv.sse4.2()
// LINUX: ret i32 0
// LINUX: define i32 @_Z12foo_overloadv.arch_ivybridge()
// LINUX: ret i32 1
// LINUX: define i32 @_Z12foo_overloadv()
// LINUX: ret i32 2

// WINDOWS: define dso_local i32 @"?foo_overload@@YAHH@Z.sse4.2"(i32)
// WINDOWS: ret i32 0
// WINDOWS: define dso_local i32 @"?foo_overload@@YAHH@Z.arch_ivybridge"(i32)
// WINDOWS: ret i32 1
// WINDOWS: define dso_local i32 @"?foo_overload@@YAHH@Z"(i32)
// WINDOWS: ret i32 2
// WINDOWS: define dso_local i32 @"?foo_overload@@YAHXZ.sse4.2"()
// WINDOWS: ret i32 0
// WINDOWS: define dso_local i32 @"?foo_overload@@YAHXZ.arch_ivybridge"()
// WINDOWS: ret i32 1
// WINDOWS: define dso_local i32 @"?foo_overload@@YAHXZ"()
// WINDOWS: ret i32 2

// LINUX: define i32 @_Z4bar2v()
// LINUX: call i32 @_Z12foo_overloadv.ifunc()
// LINUX: call i32 @_Z12foo_overloadi.ifunc(i32 1)

// WINDOWS: define dso_local i32 @"?bar2@@YAHXZ"()
// WINDOWS: call i32 @"?foo_overload@@YAHXZ.resolver"()
// WINDOWS: call i32 @"?foo_overload@@YAHH@Z.resolver"(i32 1)

// LINUX: define i32 ()* @_Z12foo_overloadv.resolver() comdat
// LINUX: ret i32 ()* @_Z12foo_overloadv.arch_sandybridge
// LINUX: ret i32 ()* @_Z12foo_overloadv.arch_ivybridge
// LINUX: ret i32 ()* @_Z12foo_overloadv.sse4.2
// LINUX: ret i32 ()* @_Z12foo_overloadv

// WINDOWS: define dso_local i32 @"?foo_overload@@YAHXZ.resolver"() comdat
// WINDOWS: call i32 @"?foo_overload@@YAHXZ.arch_sandybridge"
// WINDOWS: call i32 @"?foo_overload@@YAHXZ.arch_ivybridge"
// WINDOWS: call i32 @"?foo_overload@@YAHXZ.sse4.2"
// WINDOWS: call i32 @"?foo_overload@@YAHXZ"

// LINUX: define i32 (i32)* @_Z12foo_overloadi.resolver() comdat
// LINUX: ret i32 (i32)* @_Z12foo_overloadi.arch_sandybridge
// LINUX: ret i32 (i32)* @_Z12foo_overloadi.arch_ivybridge
// LINUX: ret i32 (i32)* @_Z12foo_overloadi.sse4.2
// LINUX: ret i32 (i32)* @_Z12foo_overloadi

// WINDOWS: define dso_local i32 @"?foo_overload@@YAHH@Z.resolver"(i32) comdat
// WINDOWS: call i32 @"?foo_overload@@YAHH@Z.arch_sandybridge"
// WINDOWS: call i32 @"?foo_overload@@YAHH@Z.arch_ivybridge"
// WINDOWS: call i32 @"?foo_overload@@YAHH@Z.sse4.2"
// WINDOWS: call i32 @"?foo_overload@@YAHH@Z"

// LINUX: declare i32 @_Z12foo_overloadv.arch_sandybridge()
// LINUX: declare i32 @_Z12foo_overloadi.arch_sandybridge(i32)

// WINDOWS: declare dso_local i32 @"?foo_overload@@YAHXZ.arch_sandybridge"()
// WINDOWS: declare dso_local i32 @"?foo_overload@@YAHH@Z.arch_sandybridge"(i32)
