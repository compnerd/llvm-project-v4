# TestREPLBreakpoints.py
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
"""Test that we can define and use classes in the REPL"""

import os, time
import unittest2
import lldb
from lldbsuite.test.lldbrepl import REPLTest, load_tests
from lldbsuite.test.lldbtest import no_debug_info_test, expectedFailureLinux, swiftTest

class REPLBreakpointsTestCase (REPLTest):

    mydir = REPLTest.compute_mydir(__file__)

    @swiftTest
    @no_debug_info_test
    @expectedFailureLinux("rdar://23091701")
    def testREPL(self):
        REPLTest.testREPL(self)

    def doTest(self):
        self.command('''func foo() {
    print("hello")
}''', prompt_sync=False, patterns=['4>'])
        
        # Set a breakpoint
        function_pattern = '''foo \(\) -> \(\)'''
        source_pattern = 'at repl.swift:2'
        self.command(':b 2', prompt_sync=False, patterns=['Breakpoint 1', function_pattern, source_pattern, 'address = 0x', '4>'])
        self.command('foo()', prompt_sync=False, patterns=['Execution stopped at breakpoint', 'Process [0-9]+ stopped', 'thread #1: tid = 0x', 'foo\(\) -> \(\)', source_pattern, 'stop reason = breakpoint 1.1', '-> 2', '''print\("hello"\)'''])
