// RUN: %clang_cc1 -std=c++1z -verify %s

void use_from_own_init() {
  auto [a] = a; // expected-error {{binding 'a' cannot appear in the initializer of its own decomposition declaration}}
}

// As a Clang extension, _Complex can be decomposed.
float decompose_complex(_Complex float cf) {
  static _Complex float scf;
  auto &[sre, sim] = scf;
  // ok, this is references initialized by constant expressions all the way down
  static_assert(&sre == &__real scf);
  static_assert(&sim == &__imag scf);

  auto [re, im] = cf;
  return re*re + im*im;
}

// As a Clang extension, vector types can be decomposed.
typedef float vf3 __attribute__((ext_vector_type(3)));
float decompose_vector(vf3 v) {
  auto [x, y, z] = v;
  auto *p = &x; // expected-error {{address of vector element requested}}
  return x + y + z;
}

struct S { int a, b; };
constexpr int f(S s) {
  auto &[a, b] = s;
  return a * 10 + b;
}
static_assert(f({1, 2}) == 12);

constexpr bool g(S &&s) { 
  auto &[a, b] = s;
  return &a == &s.a && &b == &s.b && &a != &b;
}
static_assert(g({1, 2}));

// FIXME: by-value array copies
// FIXME: code generation
