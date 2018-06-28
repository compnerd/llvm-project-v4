// RUN: %check_clang_tidy %s misc-unused-parameters %t -- \
// RUN:   -config="{CheckOptions: [{key: StrictMode, value: 1}]}" --

// Warn on empty function bodies in StrictMode.
namespace strict_mode {
void f(int foo) {}
// CHECK-MESSAGES: :[[@LINE-1]]:12: warning: parameter 'foo' is unused [misc-unused-parameters]
// CHECK-FIXES: {{^}}void f(int  /*foo*/) {}{{$}}
class E {
  int i;

public:
  E(int j) {}
// CHECK-MESSAGES: :[[@LINE-1]]:9: warning: parameter 'j' is unused
// CHECK-FIXES: {{^}}  E(int  /*j*/) {}{{$}}
};
class F {
  int i;

public:
  F(int j) : i() {}
// CHECK-MESSAGES: :[[@LINE-1]]:9: warning: parameter 'j' is unused
// CHECK-FIXES: {{^}}  F(int  /*j*/) : i() {}{{$}}
};
}
