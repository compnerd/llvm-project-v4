// RUN: %clang_cc1 -verify -fopenmp -std=c++11 -ferror-limit 100 -o - %s

// RUN: %clang_cc1 -verify -fopenmp-simd -std=c++11 -ferror-limit 100 -o - %s

void foo() {
}

bool foobool(int argc) {
  return argc;
}

struct S1; // expected-note 2 {{declared here}}

template <typename T, int C> // expected-note {{declared here}}
T tmain(T argc) {
  char **a;
#pragma omp target teams thread_limit(C)
  foo();
#pragma omp target teams thread_limit(T) // expected-error {{'T' does not refer to a value}}
  foo();
#pragma omp target teams thread_limit // expected-error {{expected '(' after 'thread_limit'}}
  foo();
#pragma omp target teams thread_limit( // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
#pragma omp target teams thread_limit() // expected-error {{expected expression}}
  foo();
#pragma omp target teams thread_limit(argc // expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
#pragma omp target teams thread_limit(argc)) // expected-warning {{extra tokens at the end of '#pragma omp target teams' are ignored}}
  foo();
#pragma omp target teams thread_limit(argc > 0 ? a[1] : a[2]) // expected-error {{expression must have integral or unscoped enumeration type, not 'char *'}}
  foo();
#pragma omp target teams thread_limit(argc + argc)
  foo();
#pragma omp target teams thread_limit(argc), thread_limit (argc+1) // expected-error {{directive '#pragma omp target teams' cannot contain more than one 'thread_limit' clause}}
  foo();
#pragma omp target teams thread_limit(S1) // expected-error {{'S1' does not refer to a value}}
  foo();
#pragma omp target teams thread_limit(-2) // expected-error {{argument to 'thread_limit' clause must be a strictly positive integer value}}
  foo();
#pragma omp target teams thread_limit(-10u)
  foo();
#pragma omp target teams thread_limit(3.14) // expected-error 2 {{expression must have integral or unscoped enumeration type, not 'double'}}
  foo();

  return 0;
}

int main(int argc, char **argv) {
#pragma omp target teams thread_limit // expected-error {{expected '(' after 'thread_limit'}}
  foo();

#pragma omp target teams thread_limit ( // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();

#pragma omp target teams thread_limit () // expected-error {{expected expression}}
  foo();

#pragma omp target teams thread_limit (argc // expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();

#pragma omp target teams thread_limit (argc)) // expected-warning {{extra tokens at the end of '#pragma omp target teams' are ignored}}
  foo();

#pragma omp target teams thread_limit (argc > 0 ? argv[1] : argv[2]) // expected-error {{expression must have integral or unscoped enumeration type, not 'char *'}}
  foo();

#pragma omp target teams thread_limit (argc + argc)
  foo();

#pragma omp target teams thread_limit (argc), thread_limit (argc+1) // expected-error {{directive '#pragma omp target teams' cannot contain more than one 'thread_limit' clause}}
  foo();

#pragma omp target teams thread_limit (S1) // expected-error {{'S1' does not refer to a value}}
  foo();

#pragma omp target teams thread_limit (-2) // expected-error {{argument to 'thread_limit' clause must be a strictly positive integer value}}
  foo();

#pragma omp target teams thread_limit (-10u)
  foo();

#pragma omp target teams thread_limit (3.14) // expected-error {{expression must have integral or unscoped enumeration type, not 'double'}}
  foo();

  return tmain<int, 10>(argc); // expected-note {{in instantiation of function template specialization 'tmain<int, 10>' requested here}}
}
