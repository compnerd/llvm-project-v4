// -*- C++ -*-
//===-- header_inclusion_order_memory_1.pass.cpp --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "support/pstl_test_config.h"

#ifdef PSTL_STANDALONE_TESTS
#include "pstl/memory"
#include "pstl/execution"
#else
#include <memory>
#include <execution>
#endif // PSTL_STANDALONE_TESTS

int32_t
main()
{
    return 0;
}
