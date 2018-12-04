//===-- main.c --------------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include <stdio.h>

void foo() {
    printf("testing\n");
}

int main (int argc, char const *argv[]) {
    foo();
    return 0;
}
