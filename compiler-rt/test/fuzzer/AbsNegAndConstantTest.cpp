// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.

// abs(x) < 0 and y == Const puzzle.
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  if (Size < 8) return 0;
  int x;
  unsigned y;
  memcpy(&x, Data, sizeof(x));
  memcpy(&y, Data + sizeof(x), sizeof(y));
  volatile int abs_x = abs(x);
  if (abs_x < 0 && y == 0xbaddcafe) {
    printf("BINGO; Found the target, exiting; x = 0x%x y 0x%x\n", x, y);
    fflush(stdout);
    exit(1);
  }
  return 0;
}

