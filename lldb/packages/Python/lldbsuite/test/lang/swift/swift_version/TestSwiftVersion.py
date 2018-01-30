# TestSwiftVersion.py
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
# ------------------------------------------------------------------------------
"""
Test that LLDB can debug  code generated by the Swift compiler for different versions of the language
"""
import commands
import lldb
from lldbsuite.test.lldbtest import *
import lldbsuite.test.decorators as decorators
import lldbsuite.test.lldbutil as lldbutil
import os
import os.path
import time
import unittest2

class TestSwiftVersion(TestBase):

    mydir = TestBase.compute_mydir(__file__)

    @decorators.skipUnlessDarwin
    @decorators.swiftTest
    def test_cross_module_extension(self):
        """Test that LLDB can debug different Swift language versions"""
        self.buildAll()
        self.do_test()

    def setUp(self):
        TestBase.setUp(self)

    def buildAll(self):
        lldbutil.execute_command("make everything")

    def do_test(self):
        """Test that LLDB can debug different Swift language versions"""
        def cleanup():
            lldbutil.execute_command("make cleanup")
        self.addTearDownHook(cleanup)

        exe_name = "main"
        exe_path = self.getBuildArtifact(exe_name)

        tests = [
          { 'file' : "mod3.swift",
            'source_regex' : "break 3",
            'expr' : "S3().i",
            'substr' : "3" },
          { 'file' : "mod4.swift",
            'source_regex' : "break 4",
            'expr' : "S4().i",
            'substr' : "4" }
        ]

        # Create the target
        target = self.dbg.CreateTarget(exe_path)
        self.assertTrue(target, VALID_TARGET)

        for t in tests:
          source_name = t['file']
          source_spec = lldb.SBFileSpec(source_name)

          breakpoint = target.BreakpointCreateBySourceRegex(t['source_regex'], source_spec)
          self.assertTrue(breakpoint.GetNumLocations() > 0, "Breakpoint set sucessfully with file " + source_name + ", regex " + t['source_regex'])

        process = target.LaunchSimple(None, None, os.getcwd())
        self.assertTrue(process, PROCESS_IS_VALID)

        for t in tests:
          thread = process.GetSelectedThread()
          frame = thread.GetFrameAtIndex(0)
          val = frame.EvaluateExpression(t['expr'])
          self.assertTrue(t['substr'] in str(val.GetValue()), "Expression " + t['expr'] + " result " + val.GetValue() + " has substring " + t['substr'])
          process.Continue()

if __name__ == '__main__':
    import atexit
    lldb.SBDebugger.Initialize()
    atexit.register(lldb.SBDebugger.Terminate)
    unittest2.main()
