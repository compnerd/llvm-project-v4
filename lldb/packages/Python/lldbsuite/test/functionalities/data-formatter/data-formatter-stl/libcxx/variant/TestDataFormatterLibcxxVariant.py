"""
Test lldb data formatter subsystem.
"""

from __future__ import print_function


import os
import time
import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil

class LibcxxOptionalDataFormatterTestCase(TestBase):

    mydir = TestBase.compute_mydir(__file__)

    @add_test_categories(["libc++"])
    ## We are skipping clang version less that 5.0 since this test requires -std=c++17
    @skipIf(oslist=no_match(["macosx"]), compiler="clang", compiler_version=['<', '5.0'])
    ## We are skipping gcc version less that 5.1 since this test requires -std=c++17
    @skipIf(compiler="gcc", compiler_version=['<', '5.1'])

    def test_with_run_command(self):
        """Test that that file and class static variables display correctly."""
        self.build()

        (self.target, self.process, _, bkpt) = lldbutil.run_to_source_breakpoint(self, '// break here',
                lldb.SBFileSpec("main.cpp", False))

        self.runCmd( "frame variable has_variant" )

        output = self.res.GetOutput()

        ## The variable has_variant tells us if the test program
        ## detected we have a sufficient libc++ version to support variant
        ## false means we do not and therefore should skip the test
        if output.find("(bool) has_variant = false") != -1 :
            self.skipTest( "std::variant not supported" )

        lldbutil.continue_to_breakpoint(self.process, bkpt)

        self.expect("frame variable v1",
                substrs=['v1 =  Active Type = int  {',
                               'Value = 12',
                               '}'])

        self.expect("frame variable v1_ref",
                substrs=['v1_ref =  Active Type = int : {',
                               'Value = 12',
                               '}'])

        self.expect("frame variable v_v1",
                substrs=['v_v1 =  Active Type = std::__1::variant<int, double, char>  {',
                                 'Value =  Active Type = int  {',
                                   'Value = 12',
                                 '}',
                               '}'])

        lldbutil.continue_to_breakpoint(self.process, bkpt)

        self.expect("frame variable v1",
                substrs=['v1 =  Active Type = double  {',
                               'Value = 2',
                               '}'])

        lldbutil.continue_to_breakpoint(self.process, bkpt)

        self.expect("frame variable v2",
                substrs=['v2 =  Active Type = double  {',
                               'Value = 2',
                               '}'])

        self.expect("frame variable v3",
                substrs=['v3 =  Active Type = char  {',
                               'Value = \'A\'',
                               '}'])

        self.expect("frame variable v_no_value",
                    substrs=['v_no_value =  No Value'])
