"""
Test regression for Bug 25251.
"""

import os, time
import unittest2
import lldb
from lldbsuite.test.lldbtest import *
import lldbsuite.test.lldbutil as lldbutil

class BreakpointAfterJoinTestCase(TestBase):

    mydir = TestBase.compute_mydir(__file__)

    def setUp(self):
        # Call super's setUp().
        TestBase.setUp(self)
        # Find the line number for our breakpoint.
        self.breakpoint = line_number('ParallelTask.cpp', '// Set breakpoint here')
    
    @skipIfTargetAndroid(archs=["arm"]) # The android-arm compiler can't compile the inferior
                                        # because of an issue around std::future.
                                        # TODO: Change the test to don't depend on std::future<T>
    def test(self):
        """Test breakpoint handling after a thread join."""
        self.build(dictionary=self.getBuildFlags())

        exe = os.path.join(os.getcwd(), "a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        # This should create a breakpoint
        lldbutil.run_break_set_by_file_and_line (self, "ParallelTask.cpp", self.breakpoint, num_expected_locations=-1)

        # The breakpoint list should show 1 location.
        self.expect("breakpoint list -f", "Breakpoint location shown correctly",
            substrs = ["1: file = 'ParallelTask.cpp', line = %d, exact_match = 0" % self.breakpoint])

        # Run the program.
        self.runCmd("run", RUN_SUCCEEDED)

        # The stop reason of the thread should be breakpoint.
        self.expect("thread list", STOPPED_DUE_TO_BREAKPOINT,
            substrs = ['stopped',
                       'stop reason = breakpoint'])

        # This should not result in a segmentation fault
        self.expect("thread backtrace all", STOPPED_DUE_TO_BREAKPOINT,
            substrs = ["stop reason = breakpoint 1."])

        # Run to completion
        self.runCmd("continue")

if __name__ == '__main__':
    import atexit
    lldb.SBDebugger.Initialize()
    atexit.register(lambda: lldb.SBDebugger.Terminate())
    unittest2.main()
