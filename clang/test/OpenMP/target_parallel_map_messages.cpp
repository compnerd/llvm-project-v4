// RUN: %clang_cc1 -verify -fopenmp -ferror-limit 100 %s -Wno-openmp-target -Wuninitialized

// RUN: %clang_cc1 -verify -fopenmp-simd -ferror-limit 100 %s -Wno-openmp-target -Wuninitialized

void foo() {
}

bool foobool(int argc) {
  return argc;
}

struct S1; // expected-note 2 {{declared here}}
extern S1 a;
class S2 {
  mutable int a;
public:
  S2():a(0) { }
  S2(S2 &s2):a(s2.a) { }
  static float S2s;
  static const float S2sc;
};
const float S2::S2sc = 0;
const S2 b;
const S2 ba[5];
class S3 {
  int a;
public:
  S3():a(0) { }
  S3(S3 &s3):a(s3.a) { }
};
const S3 c;
const S3 ca[5];
extern const int f;
class S4 {
  int a;
  S4();
  S4(const S4 &s4);
public:
  S4(int v):a(v) { }
};
class S5 {
  int a;
  S5():a(0) {}
  S5(const S5 &s5):a(s5.a) { }
public:
  S5(int v):a(v) { }
};

S3 h;
#pragma omp threadprivate(h) // expected-note 2 {{defined as threadprivate or thread local}}

typedef int from;

template <typename T, int I> // expected-note {{declared here}}
T tmain(T argc) {
  const T d = 5;
  const T da[5] = { 0 };
  S4 e(4);
  S5 g(5);
  T i, t[20];
  T &j = i;
  T *k = &j;
  T x;
  T y, z;
  T to, tofrom, always;
  const T (&l)[5] = da;


#pragma omp target parallel map // expected-error {{expected '(' after 'map'}}
  foo();
#pragma omp target parallel map( // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected expression}}
  foo();
#pragma omp target parallel map() // expected-error {{expected expression}}
  foo();
#pragma omp target parallel map(alloc) // expected-error {{use of undeclared identifier 'alloc'}}
  foo();
#pragma omp target parallel map(to argc // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected ',' or ')' in 'map' clause}}
  foo();
#pragma omp target parallel map(to:) // expected-error {{expected expression}}
  foo();
#pragma omp target parallel map(from: argc, // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
#pragma omp target parallel map(x: y) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}}
  foo();
#pragma omp target parallel map(l[-1:]) // expected-error 2 {{array section must be a subset of the original array}}
  foo();
#pragma omp target parallel map(l[:-1]) // expected-error 2 {{section length is evaluated to a negative value -1}}
  foo();
#pragma omp target parallel map(l[true:true])
  foo();
#pragma omp target parallel map(x, z)
  foo();
#pragma omp target parallel map(tofrom: t[:I])
  foo();
#pragma omp target parallel map(T: a) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}} expected-error {{incomplete type 'S1' where a complete type is required}}
  foo();
#pragma omp target parallel map(T) // expected-error {{'T' does not refer to a value}}
  foo();
#pragma omp target parallel map(I) // expected-error 2 {{expected expression containing only member accesses and/or array sections based on named variables}}
  foo();
#pragma omp target parallel map(S2::S2s)
  foo();
#pragma omp target parallel map(S2::S2sc)
  foo();
#pragma omp target parallel map(x)
  foo();
#pragma omp target parallel map(to: x)
  foo();
#pragma omp target parallel map(to: to)
  foo();
#pragma omp target parallel map(to)
  foo();
#pragma omp target parallel map(to, x)
  foo();
#pragma omp target parallel map(to x) // expected-error {{expected ',' or ')' in 'map' clause}}
  foo();
#pragma omp target parallel map(tofrom: argc > 0 ? x : y) // expected-error 2 {{expected expression containing only member accesses and/or array sections based on named variables}} 
  foo();
#pragma omp target parallel map(argc)
  foo();
#pragma omp target parallel map(S1) // expected-error {{'S1' does not refer to a value}}
  foo();
#pragma omp target parallel map(a, b, c, d, f) // expected-error {{incomplete type 'S1' where a complete type is required}}
  foo();
#pragma omp target parallel map(ba)
  foo();
#pragma omp target parallel map(ca)
  foo();
#pragma omp target parallel map(da)
  foo();
#pragma omp target parallel map(S2::S2s)
  foo();
#pragma omp target parallel map(S2::S2sc)
  foo();
#pragma omp target parallel map(e, g)
  foo();
#pragma omp target parallel map(h) // expected-error {{threadprivate variables are not allowed in 'map' clause}}
  foo();
#pragma omp target parallel map(k), map(k) // expected-error 2 {{variable already marked as mapped in current construct}} expected-note 2 {{used here}}
  foo();
#pragma omp target parallel map(k), map(k[:5]) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}} expected-note 2 {{used here}}
  foo();
#pragma omp target parallel map(da)
  foo();
#pragma omp target parallel map(da[:4])
  foo();
#pragma omp target data map(k, j, l) // expected-note 2 {{used here}}
#pragma omp target parallel map(k[:4]) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}}
  foo();
#pragma omp target parallel map(j)
  foo();
#pragma omp target parallel map(l) map(l[:5]) // expected-error 2 {{variable already marked as mapped in current construct}} expected-note 2 {{used here}}
  foo();
#pragma omp target data map(k[:4], j, l[:5]) // expected-note 2 {{used here}}
{
#pragma omp target parallel map(k) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}}
  foo();
#pragma omp target parallel map(j)
  foo();
#pragma omp target parallel map(l)
  foo();
}

#pragma omp target parallel map(always, tofrom: x)
  foo();
#pragma omp target parallel map(always: x) // expected-error {{missing map type}}
  foo();
#pragma omp target parallel map(tofrom, always: x) // expected-error {{incorrect map type modifier, expected 'always', 'close', or 'mapper'}} expected-error {{missing map type}}
  foo();
#pragma omp target parallel map(always, tofrom: always, tofrom, x)
  foo();
#pragma omp target parallel map(tofrom j) // expected-error {{expected ',' or ')' in 'map' clause}}
  foo();

  return 0;
}

int main(int argc, char **argv) {
  const int d = 5;
  const int da[5] = { 0 };
  S4 e(4);
  S5 g(5);
  int i;
  int &j = i;
  int *k = &j;
  int x;
  int y;
  int to, tofrom, always;
  const int (&l)[5] = da;
#pragma omp target parallel map // expected-error {{expected '(' after 'map'}}
  foo();
#pragma omp target parallel map( // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected expression}}
  foo();
#pragma omp target parallel map() // expected-error {{expected expression}}
  foo();
#pragma omp target parallel map(alloc) // expected-error {{use of undeclared identifier 'alloc'}}
  foo();
#pragma omp target parallel map(to argc // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected ',' or ')' in 'map' clause}}
  foo();
#pragma omp target parallel map(to:) // expected-error {{expected expression}}
  foo();
#pragma omp target parallel map(from: argc, // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
#pragma omp target parallel map(x: y) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}}
  foo();
#pragma omp target parallel map(l[-1:]) // expected-error {{array section must be a subset of the original array}}
  foo();
#pragma omp target parallel map(l[:-1]) // expected-error {{section length is evaluated to a negative value -1}}
  foo();
#pragma omp target parallel map(l[true:true])
  foo();
#pragma omp target parallel map(x)
  foo();
#pragma omp target parallel map(to: x)
  foo();
#pragma omp target parallel map(to: to)
  foo();
#pragma omp target parallel map(to)
  foo();
#pragma omp target parallel map(to, x)
  foo();
#pragma omp target parallel map(to x) // expected-error {{expected ',' or ')' in 'map' clause}}
  foo();
#pragma omp target parallel map(tofrom: argc > 0 ? argv[1] : argv[2]) // expected-error {{expected expression containing only member accesses and/or array sections based on named variables}}
  foo();
#pragma omp target parallel map(argc)
  foo();
#pragma omp target parallel map(S1) // expected-error {{'S1' does not refer to a value}}
  foo();
#pragma omp target parallel map(a, b, c, d, f) // expected-error {{incomplete type 'S1' where a complete type is required}}
  foo();
#pragma omp target parallel map(argv[1])
  foo();
#pragma omp target parallel map(ba)
  foo();
#pragma omp target parallel map(ca)
  foo();
#pragma omp target parallel map(da)
  foo();
#pragma omp target parallel map(S2::S2s)
  foo();
#pragma omp target parallel map(S2::S2sc)
  foo();
#pragma omp target parallel map(e, g)
  foo();
#pragma omp target parallel map(h) // expected-error {{threadprivate variables are not allowed in 'map' clause}}
  foo();
#pragma omp target parallel map(k), map(k) // expected-error {{variable already marked as mapped in current construct}} expected-note {{used here}}
  foo();
#pragma omp target parallel map(k), map(k[:5]) // expected-error {{pointer cannot be mapped along with a section derived from itself}} expected-note {{used here}}
  foo();
#pragma omp target parallel map(da)
  foo();
#pragma omp target parallel map(da[:4])
  foo();
#pragma omp target data map(k, j, l) // expected-note {{used here}}
#pragma omp target parallel map(k[:4]) // expected-error {{pointer cannot be mapped along with a section derived from itself}}
  foo();
#pragma omp target parallel map(j)
  foo();
#pragma omp target parallel map(l) map(l[:5]) // expected-error 1 {{variable already marked as mapped in current construct}} expected-note 1 {{used here}}
  foo();
#pragma omp target data map(k[:4], j, l[:5]) // expected-note 1 {{used here}}
{
#pragma omp target parallel map(k) // expected-error {{pointer cannot be mapped along with a section derived from itself}}
  foo();
#pragma omp target parallel map(j)
  foo();
#pragma omp target parallel map(l)
  foo();
}

#pragma omp target parallel map(always, tofrom: x)
  foo();
#pragma omp target parallel map(always: x) // expected-error {{missing map type}}
  foo();
#pragma omp target parallel map(tofrom, always: x) // expected-error {{incorrect map type modifier, expected 'always', 'close', or 'mapper'}} expected-error {{missing map type}}
  foo();
#pragma omp target parallel map(always, tofrom: always, tofrom, x)
  foo();
#pragma omp target parallel map(tofrom j) // expected-error {{expected ',' or ')' in 'map' clause}}
  foo();

  return tmain<int, 3>(argc)+tmain<from, 4>(argc); // expected-note {{in instantiation of function template specialization 'tmain<int, 3>' requested here}} expected-note {{in instantiation of function template specialization 'tmain<int, 4>' requested here}}
}

