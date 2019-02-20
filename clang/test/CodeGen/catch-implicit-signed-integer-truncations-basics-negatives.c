// RUN: %clang_cc1 -fsanitize=implicit-signed-integer-truncation -fsanitize-recover=implicit-signed-integer-truncation -emit-llvm %s -o - -triple x86_64-linux-gnu | FileCheck %s -implicit-check-not="call void @__ubsan_handle_implicit_conversion" --check-prefixes=CHECK

// CHECK-DAG: @[[LINE_100_SIGNED_TRUNCATION:.*]] = {{.*}}, i32 100, i32 10 }, {{.*}}, {{.*}}, i8 2 }
// CHECK-DAG: @[[LINE_200_SIGNED_TRUNCATION:.*]] = {{.*}}, i32 200, i32 10 }, {{.*}}, {{.*}}, i8 2 }

// CHECK-LABEL: @blacklist_0_convert_signed_int_to_signed_char
__attribute__((no_sanitize("undefined"))) signed char blacklist_0_convert_signed_int_to_signed_char(signed int x) {
  // We are not in "undefined" group, so that doesn't work.
  // CHECK: call void @__ubsan_handle_implicit_conversion(i8* bitcast ({ {{{.*}}}, {{{.*}}}*, {{{.*}}}*, i8 }* @[[LINE_100_SIGNED_TRUNCATION]] to i8*)
#line 100
  return x;
}

// CHECK-LABEL: @blacklist_1_convert_signed_int_to_signed_char
__attribute__((no_sanitize("integer"))) signed char blacklist_1_convert_signed_int_to_signed_char(signed int x) {
  return x;
}

// CHECK-LABEL: @blacklist_2_convert_signed_int_to_signed_char
__attribute__((no_sanitize("implicit-conversion"))) signed char blacklist_2_convert_signed_int_to_signed_char(signed int x) {
  return x;
}

// CHECK-LABEL: @blacklist_3_convert_signed_int_to_signed_char
__attribute__((no_sanitize("implicit-integer-truncation"))) signed char blacklist_3_convert_signed_int_to_signed_char(signed int x) {
  return x;
}

// CHECK-LABEL: @blacklist_4_convert_signed_int_to_signed_char
__attribute__((no_sanitize("implicit-signed-integer-truncation"))) signed char blacklist_4_convert_signed_int_to_signed_char(signed int x) {
  return x;
}

// CHECK-LABEL: @blacklist_5_convert_signed_int_to_signed_char
__attribute__((no_sanitize("implicit-unsigned-integer-truncation"))) signed char blacklist_5_convert_signed_int_to_signed_char(signed int x) {
  // This is an signed truncation, not unsigned-one.
  // CHECK: call void @__ubsan_handle_implicit_conversion(i8* bitcast ({ {{{.*}}}, {{{.*}}}*, {{{.*}}}*, i8 }* @[[LINE_200_SIGNED_TRUNCATION]] to i8*)
#line 200
  return x;
}
