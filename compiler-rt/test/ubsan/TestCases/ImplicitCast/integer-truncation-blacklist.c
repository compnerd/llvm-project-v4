// RUN: rm -f %tmp
// RUN: echo "[implicit-integer-truncation]" >> %tmp
// RUN: echo "fun:*implicitTruncation*" >> %tmp
// RUN: %clang -fsanitize=implicit-integer-truncation -fno-sanitize-recover=implicit-integer-truncation -fsanitize-blacklist=%tmp -O0 %s -o %t && not %run %t 2>&1
// RUN: %clang -fsanitize=implicit-integer-truncation -fno-sanitize-recover=implicit-integer-truncation -fsanitize-blacklist=%tmp -O1 %s -o %t && not %run %t 2>&1
// RUN: %clang -fsanitize=implicit-integer-truncation -fno-sanitize-recover=implicit-integer-truncation -fsanitize-blacklist=%tmp -O2 %s -o %t && not %run %t 2>&1
// RUN: %clang -fsanitize=implicit-integer-truncation -fno-sanitize-recover=implicit-integer-truncation -fsanitize-blacklist=%tmp -O3 %s -o %t && not %run %t 2>&1

unsigned char implicitTruncation(unsigned int argc) {
  return argc; // BOOM
}

int main(int argc, char **argv) {
  return implicitTruncation(~0U);
}
