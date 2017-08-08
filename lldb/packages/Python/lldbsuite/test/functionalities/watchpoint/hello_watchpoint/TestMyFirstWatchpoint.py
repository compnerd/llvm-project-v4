"""
Test my first lldb watchpoint.
"""

from __future__ import print_function


import os
import time
import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil


class HelloWatchpointTestCase(TestBase):

    def getCategories(self):
        return ['basic_process']

    mydir = TestBase.compute_mydir(__file__)

    def setUp(self):
        # Call super's setUp().
        TestBase.setUp(self)
        # Our simple source filename.
        self.source = 'main.c'
        # Find the line number to break inside main().
        self.line = line_number(
            self.source, '// Set break point at this line.')
        # And the watchpoint variable declaration line number.
        self.decl = line_number(self.source,
                                '// Watchpoint variable declaration.')
        self.exe_name = 'a.out'
        self.d = {'C_SOURCES': self.source, 'EXE': self.exe_name}

    # Watchpoints not supported
    @expectedFailureAndroid(archs=['arm', 'aarch64'])
    @expectedFailureAll(
        oslist=["windows"],
        bugnumber="llvm.org/pr24446: WINDOWS XFAIL TRIAGE - Watchpoints not supported on Windows")
    @expectedFailureAll(
        oslist=["linux"],
        bugnumber="https://bugs.swift.org/browse/SR-5555 MyFirstWatchpoint test fails on Ubuntu 16.04")
    def test_hello_watchpoint_using_watchpoint_set(self):
        """Test a simple sequence of watchpoint creation and watchpoint hit."""
        self.build(dictionary=self.d)
        self.setTearDownCleanup(dictionary=self.d)

        exe = os.path.join(os.getcwd(), self.exe_name)
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        # Add a breakpoint to set a watchpoint when stopped on the breakpoint.
        lldbutil.run_break_set_by_file_and_line(
            self, None, self.line, num_expected_locations=1)

        # Run the program.
        self.runCmd("run", RUN_SUCCEEDED)

        # We should be stopped again due to the breakpoint.
        # The stop reason of the thread should be breakpoint.
        self.expect("thread list", STOPPED_DUE_TO_BREAKPOINT,
                    substrs=['stopped',
                             'stop reason = breakpoint'])

        # Now let's set a write-type watchpoint for 'global'.
        # There should be only one watchpoint hit (see main.c).
        self.expect(
            "watchpoint set variable -w write global",
            WATCHPOINT_CREATED,
            substrs=[
                'Watchpoint created',
                'size = 4',
                'type = w',
                '%s:%d' %
                (self.source,
                 self.decl)])

        # Use the '-v' option to do verbose listing of the watchpoint.
        # The hit count should be 0 initially.
        self.expect("watchpoint list -v",
                    substrs=['hit_count = 0'])

        self.runCmd("process continue")

        # We should be stopped again due to the watchpoint (write type), but
        # only once.  The stop reason of the thread should be watchpoint.
        self.expect("thread list", STOPPED_DUE_TO_WATCHPOINT,
                    substrs=['stopped',
                             'stop reason = watchpoint'])

        self.runCmd("process continue")

        # Don't expect the read of 'global' to trigger a stop exception.
        process = self.dbg.GetSelectedTarget().GetProcess()
        if process.GetState() == lldb.eStateStopped:
            self.assertFalse(
                lldbutil.get_stopped_thread(
                    process, lldb.eStopReasonWatchpoint))

        # Use the '-v' option to do verbose listing of the watchpoint.
        # The hit count should now be 1.
        self.expect("watchpoint list -v",
                    substrs=['hit_count = 1'])
