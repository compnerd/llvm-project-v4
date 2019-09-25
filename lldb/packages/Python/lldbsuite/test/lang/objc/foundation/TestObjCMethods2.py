"""
Test more expression command sequences with objective-c.
"""

from __future__ import print_function


import os
import time
import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil


@skipUnlessDarwin
class FoundationTestCase2(TestBase):

    mydir = TestBase.compute_mydir(__file__)

    NO_DEBUG_INFO_TESTCASE = True

    def test_expr_commands(self):
        """More expression commands for objective-c."""
        self.build()
        main_spec = lldb.SBFileSpec("main.m")

        (target, process, thread, bp) = lldbutil.run_to_source_breakpoint(
            self, "Break here for selector: tests", main_spec)
        
        # Test_Selector:
        self.expect("expression (char *)sel_getName(sel)",
                    substrs=["(char *)",
                             "length"])

        desc_bkpt = target.BreakpointCreateBySourceRegex("Break here for description test",
                                                          main_spec)
        self.assertEqual(desc_bkpt.GetNumLocations(), 1, "description breakpoint has a location")
        lldbutil.continue_to_breakpoint(process, desc_bkpt)
        
        self.expect("expression (char *)sel_getName(_cmd)",
                    substrs=["(char *)",
                             "description"])

        self.runCmd("process continue")

    def test_NSArray_expr_commands(self):
        """Test expression commands for NSArray."""
        self.build()
        exe = self.getBuildArtifact("a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        # Break inside Test_NSArray:
        line = self.lines[1]
        lldbutil.run_break_set_by_file_and_line(
            self, "main.m", line, num_expected_locations=1, loc_exact=True)

        self.runCmd("run", RUN_SUCCEEDED)

        # Test_NSArray:
        self.runCmd("thread backtrace")
        self.expect("expression (int)[nil_mutable_array count]",
                    patterns=["\(int\) \$.* = 0"])
        self.expect("expression (int)[array1 count]",
                    patterns=["\(int\) \$.* = 3"])
        self.expect("expression (int)[array2 count]",
                    patterns=["\(int\) \$.* = 3"])
        self.expect("expression (int)array1.count",
                    patterns=["\(int\) \$.* = 3"])
        self.expect("expression (int)array2.count",
                    patterns=["\(int\) \$.* = 3"])
        self.runCmd("process continue")

    def test_NSString_expr_commands(self):
        """Test expression commands for NSString."""
        self.build()
        exe = self.getBuildArtifact("a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        # Break inside Test_NSString:
        line = self.lines[2]
        lldbutil.run_break_set_by_file_and_line(
            self, "main.m", line, num_expected_locations=1, loc_exact=True)

        self.runCmd("run", RUN_SUCCEEDED)

        # Test_NSString:
        self.runCmd("thread backtrace")
        self.expect("expression (int)[str length]",
                    patterns=["\(int\) \$.* ="])
        self.expect("expression (int)[str_id length]",
                    patterns=["\(int\) \$.* ="])
        self.expect("expression (id)[str description]",
                    patterns=["\(id\) \$.* = 0x"])
        self.expect("expression (id)[str_id description]",
                    patterns=["\(id\) \$.* = 0x"])
        self.expect("expression str.length")
        self.expect('expression str = @"new"')
        self.runCmd("image lookup -t NSString")
        self.expect('expression str = (id)[NSString stringWithCString: "new"]')
        self.runCmd("process continue")

    @expectedFailureAll(archs=["i[3-6]86"], bugnumber="<rdar://problem/28814052>")
    def test_MyString_dump_with_runtime(self):
        """Test dump of a known Objective-C object by dereferencing it."""
        self.build()
        exe = self.getBuildArtifact("a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        line = self.lines[4]

        lldbutil.run_break_set_by_file_and_line(
            self, "main.m", line, num_expected_locations=1, loc_exact=True)

        self.runCmd("run", RUN_SUCCEEDED)

        self.expect(
            "expression --show-types -- *my",
            patterns=[
                "\(MyString\) \$.* = ",
                "\(MyBase\)"])
        self.runCmd("process continue")

    @expectedFailureAll(archs=["i[3-6]86"], bugnumber="<rdar://problem/28814052>")
    @expectedFailureAll(oslist=["macosx"], debug_info=["gmodules"],
                        bugnumber="rdar://28983234")
    def test_runtime_types(self):
        """Test commands that require runtime types"""
        self.build()
        exe = self.getBuildArtifact("a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        # Break inside Test_NSString:
        line = self.lines[2]
        lldbutil.run_break_set_by_source_regexp(
            self, "NSString tests")

        self.runCmd("run", RUN_SUCCEEDED)

        # Test_NSString:
        self.runCmd("thread backtrace")
        self.expect("expression [str length]",
                    patterns=["\(NSUInteger\) \$.* ="])
        self.expect("expression str.length")
        self.expect('expression str = [NSString stringWithCString: "new"]')
        self.expect(
            'po [NSError errorWithDomain:@"Hello" code:35 userInfo:@{@"NSDescription" : @"be completed."}]',
            substrs=[
                "Error Domain=Hello",
                "Code=35",
                "be completed."])
        self.runCmd("process continue")

    @expectedFailureAll(archs=["i[3-6]86"], bugnumber="<rdar://problem/28814052>")
    def test_NSError_p(self):
        """Test that p of the result of an unknown method does require a cast."""
        self.build()
        exe = self.getBuildArtifact("a.out")
        self.runCmd("file " + exe, CURRENT_EXECUTABLE_SET)

        line = self.lines[4]

        lldbutil.run_break_set_by_file_and_line(
            self, "main.m", line, num_expected_locations=1, loc_exact=True)

        self.runCmd("run", RUN_SUCCEEDED)

        self.expect("p [NSError thisMethodIsntImplemented:0]", error=True, patterns=[
                    "no known method", "cast the message send to the method's return type"])
        self.runCmd("process continue")
