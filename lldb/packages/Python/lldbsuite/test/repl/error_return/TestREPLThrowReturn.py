# TestREPLThrowReturn.py
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
# ------------------------------------------------------------------------------
"""Test that the REPL correctly handles the case that a called function throws."""

import os, time
import unittest2
import lldb
from lldbsuite.test.lldbrepl import REPLTest, load_tests
import lldbsuite.test.decorators as decorators

class REPLThrowReturnTestCase (REPLTest):

    mydir = REPLTest.compute_mydir(__file__)

    @decorators.swiftTest
    @decorators.skipUnlessDarwin
    @decorators.no_debug_info_test
    @decorators.expectedFlakey
    def testREPL(self):
        REPLTest.testREPL(self)

    def doTest(self):
        self.sendline('import Foundation; Data()')
        self.sendline('enum VagueProblem: Error { case SomethingWentWrong }; func foo() throws -> Int { throw VagueProblem.SomethingWentWrong }')
        self.promptSync()
        self.command('foo()', patterns=['\\$E0', 'SomethingWentWrong'])
