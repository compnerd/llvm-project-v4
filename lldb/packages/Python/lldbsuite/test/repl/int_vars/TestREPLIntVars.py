# TestREPLIntVars.py
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
"""Test that basic integer arithmetic works in the REPL."""

import os, time
import unittest2
import lldb
from lldbsuite.test.lldbrepl import REPLTest, load_tests
from lldbsuite.test.lldbtest import no_debug_info_test, expectedFailureLinux, swiftTest

class REPLIntVarsTestCase (REPLTest):

    mydir = REPLTest.compute_mydir(__file__)

    @swiftTest
    @no_debug_info_test
    @expectedFailureLinux("rdar://23081322")
    def testREPL(self):
        REPLTest.testREPL(self)

    def doTest(self):
        self.command('3 + 2', patterns=['\\$R0: Int = 5'])
        self.command('$R0 + 5', patterns=['\\$R1: Int = 10'])

