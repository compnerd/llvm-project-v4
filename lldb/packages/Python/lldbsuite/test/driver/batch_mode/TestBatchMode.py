"""
Test that the lldb driver's batch mode works correctly.
"""

from __future__ import print_function


import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil
from lldbsuite.test.lldbpexpect import PExpectTest


class DriverBatchModeTest(PExpectTest):

    mydir = TestBase.compute_mydir(__file__)
    source = 'main.c'

    @skipIfRemote  # test not remote-ready llvm.org/pr24813
    @expectedFlakeyFreeBSD("llvm.org/pr25172 fails rarely on the buildbot")
    def test_batch_mode_run_crash(self):
        """Test that the lldb driver's batch mode works correctly."""
        self.build()

        exe = self.getBuildArtifact("a.out")
        module_cache = self.getBuildArtifact("module.cache")

        # Pass CRASH so the process will crash and stop in batch mode.
        extra_args = ['-b',
            '-o', "settings set symbols.clang-modules-cache-path '%s'"%module_cache,
            '-o', 'break set -n main',
            '-o', 'run',
            '-o', 'continue',
            '-k', 'frame var touch_me_not',
            '--', 'CRASH',
        ]
        self.launch(executable=exe, extra_args=extra_args)
        child = self.child

        # We should see the "run":
        child.expect_exact("run")
        # We should have hit the breakpoint & continued:
        child.expect_exact("continue")
        # The App should have crashed:
        child.expect_exact("About to crash")
        # The -k option should have printed the frame variable once:
        child.expect_exact('(char *) touch_me_not')
        # Then we should have a live prompt:
        self.expect_prompt()
        self.expect("frame variable touch_me_not", substrs='(char *) touch_me_not')

    @skipIfRemote  # test not remote-ready llvm.org/pr24813
    @expectedFlakeyFreeBSD("llvm.org/pr25172 fails rarely on the buildbot")
    def test_batch_mode_run_exit(self):
        """Test that the lldb driver's batch mode works correctly."""
        self.build()

        exe = self.getBuildArtifact("a.out")
        module_cache = self.getBuildArtifact("module.cache")

        # Now do it again, and make sure if we don't crash, we quit:
        extra_args = ['-b',
            '-o', "settings set symbols.clang-modules-cache-path '%s'"%module_cache,
            '-o', 'break set -n main',
            '-o', 'run',
            '-o', 'continue',
            '--', 'NOCRASH',
        ]
        self.launch(executable=exe, extra_args=extra_args)
        child = self.child

        # We should see the "run":
        child.expect_exact("run")
        # We should have hit the breakpoint & continued:
        child.expect_exact("continue")
        # The App should have not have crashed:
        child.expect_exact("Got there on time and it did not crash.")

        # Then lldb should exit.
        child.expect_exact("exited")
        import pexpect
        child.expect(pexpect.EOF)

    def closeVictim(self):
        if self.victim is not None:
            self.victim.close()
            self.victim = None

    @skipIfRemote  # test not remote-ready llvm.org/pr24813
    @expectedFlakeyFreeBSD("llvm.org/pr25172 fails rarely on the buildbot")
    @expectedFailureNetBSD
    def test_batch_mode_attach_exit(self):
        """Test that the lldb driver's batch mode works correctly."""
        self.build()
        self.setTearDownCleanup()

        exe = self.getBuildArtifact("a.out")
        module_cache = self.getBuildArtifact("module.cache")

        # Start up the process by hand, attach to it, and wait for its completion.
        # Attach is funny, since it looks like it stops with a signal on most Unixen so
        # care must be taken not to treat that as a reason to exit batch mode.

        # Start up the process by hand and wait for it to get to the wait loop.
        import pexpect
        self.victim = pexpect.spawn('%s WAIT' % (exe))
        if self.victim is None:
            self.fail("Could not spawn ", exe, ".")

        self.addTearDownHook(self.closeVictim)

        self.victim.expect("PID: ([0-9]+) END")
        victim_pid = int(self.victim.match.group(1))

        self.victim.expect("Waiting")

        extra_args = [
            '-b',
            '-o', "settings set symbols.clang-modules-cache-path '%s'"%module_cache,
            '-o', 'process attach -p %d'%victim_pid,
            '-o', "breakpoint set --file '%s' -p 'Stop here to unset keep_waiting' -N keep_waiting"%self.source,
            '-o', 'continue',
            '-o', 'break delete keep_waiting',
            '-o', 'expr keep_waiting = 0',
            '-o', 'continue',
        ]
        self.launch(executable=exe, extra_args=extra_args)
        child = self.child

        child.expect_exact("attach")

        child.expect_exact(self.PROMPT + "continue")

        child.expect_exact(self.PROMPT + "continue")

        # Then we should see the process exit:
        child.expect_exact("Process %d exited with status" % (victim_pid))

        self.victim.expect(pexpect.EOF)
        child.expect(pexpect.EOF)
