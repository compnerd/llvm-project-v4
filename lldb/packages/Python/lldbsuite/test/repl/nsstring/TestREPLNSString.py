# TestREPLNSString.py
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
"""Test that NSString is usable in the REPL."""

import os, time
import unittest2
import lldb
from lldbsuite.test.lldbrepl import REPLTest, load_tests
import lldbsuite.test.lldbtest as lldbtest

class REPLNSStringTestCase (REPLTest):

    mydir = REPLTest.compute_mydir(__file__)
    
    @lldbtest.swiftTest
    @lldbtest.skipUnlessDarwin
    @lldbtest.no_debug_info_test
    def testREPL(self):
        REPLTest.testREPL(self)

    def doTest(self):
        self.command('import Foundation', timeout=20)
        self.command('"hello world" as NSString', patterns=['\\$R0: NSString = "hello world"'], timeout=20)
        self.command('$R0.substringToIndex(5)', patterns=['\\$R1: String = "hello"'], timeout=20)
