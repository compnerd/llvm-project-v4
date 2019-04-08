#
# modify-python-lldb.py
#
# This script modifies the lldb module (which was automatically generated via
# running swig) to support iteration and/or equality operations for certain lldb
# objects, implements truth value testing for certain lldb objects, and adds a
# global variable 'debugger_unique_id' which is initialized to 0.
#
# As a cleanup step, it also removes the 'residues' from the autodoc features of
# swig.  For an example, take a look at SBTarget.h header file, where we take
# advantage of the already existing doxygen C++-docblock and make it the Python
# docstring for the same method.  The 'residues' in this context include the c
# comment marker, the trailing blank (SPC's) line, and the doxygen comment start
# marker.
#
# In addition to the 'residues' removal during the cleanup step, it also
# transforms the 'char' data type (which was actually 'char *' but the 'autodoc'
# feature of swig removes ' *' from it) into 'str' (as a Python str type).

# System modules
import sys
import re
if sys.version_info.major >= 3:
    import io as StringIO
else:
    import StringIO

# import use_lldb_suite so we can find third-party and helper modules
import use_lldb_suite

# Third party modules
import six

# LLDB modules

if len(sys.argv) != 2:
    output_name = "./lldb.py"
else:
    output_name = sys.argv[1] + "/lldb.py"

# print "output_name is '" + output_name + "'"

#
# Residues to be removed.
#
c_comment_marker = "//------------"
# The pattern for recognizing the doxygen comment block line.
doxygen_comment_start = re.compile("^\s*(/// ?)")
# The demarcation point for turning on/off residue removal state.
# When bracketed by the lines, the CLEANUP_DOCSTRING state (see below) is ON.
toggle_docstring_cleanup_line = '        """'


def char_to_str_xform(line):
    """This transforms the 'char', i.e, 'char *' to 'str', Python string."""
    line = line.replace(' char', ' str')
    line = line.replace('char ', 'str ')
    # Special case handling of 'char **argv' and 'char **envp'.
    line = line.replace('str argv', 'list argv')
    line = line.replace('str envp', 'list envp')
    return line

#
# The one-liner docstring also needs char_to_str transformation, btw.
#
TWO_SPACES = ' ' * 2
EIGHT_SPACES = ' ' * 8
one_liner_docstring_pattern = re.compile(
    '^(%s|%s)""".*"""$' %
    (TWO_SPACES, EIGHT_SPACES))

class NewContent(StringIO.StringIO):
    """Simple facade to keep track of the previous line to be committed."""

    def __init__(self):
        StringIO.StringIO.__init__(self)
        self.prev_line = None

    def add_line(self, a_line):
        """Add a line to the content, if there is a previous line, commit it."""
        if self.prev_line is not None:
            self.write(self.prev_line + "\n")
        self.prev_line = a_line

    def del_line(self):
        """Forget about the previous line, do not commit it."""
        self.prev_line = None

    def del_blank_line(self):
        """Forget about the previous line if it is a blank line."""
        if self.prev_line is not None and not self.prev_line.strip():
            self.prev_line = None

    def finish(self):
        """Call this when you're finished with populating content."""
        if self.prev_line is not None:
            self.write(self.prev_line + "\n")
        self.prev_line = None

# The new content will have the iteration protocol defined for our lldb
# objects.
new_content = NewContent()

with open(output_name, 'r') as f_in:
    content = f_in.read()

# These define the states of our finite state machine.
NORMAL = 1
CLEANUP_DOCSTRING = 8

# Our FSM begins its life in the NORMAL state.  The state CLEANUP_DOCSTRING can
# be entered from the NORMAL.  While in this state, the FSM is fixing/cleaning
# the Python docstrings generated by the swig docstring features.
state = NORMAL

for line in content.splitlines():
    # If '        """' is the sole line, prepare to transition to the
    # CLEANUP_DOCSTRING state or out of it.

    if line == toggle_docstring_cleanup_line:
        if state & CLEANUP_DOCSTRING:
            # Special handling of the trailing blank line right before the '"""'
            # end docstring marker.
            new_content.del_blank_line()
            state ^= CLEANUP_DOCSTRING
        else:
            state |= CLEANUP_DOCSTRING

    if (state & CLEANUP_DOCSTRING):
        # Remove the comment marker line.
        if c_comment_marker in line:
            continue

        # Also remove the '\a ' and '\b 'substrings.
        line = line.replace('\a ', '')
        line = line.replace('\b ', '')
        # And the leading '///' substring.
        doxygen_comment_match = doxygen_comment_start.match(line)
        if doxygen_comment_match:
            line = line.replace(doxygen_comment_match.group(1), '', 1)

        line = char_to_str_xform(line)

        # Note that the transition out of CLEANUP_DOCSTRING is handled at the
        # beginning of this function already.

    # This deals with one-liner docstring, for example, SBThread.GetName:
    # """GetName(self) -> char""".
    if one_liner_docstring_pattern.match(line):
        line = char_to_str_xform(line)

    # Pass the original line of content to new_content.
    new_content.add_line(line)

# We are finished with recording new content.
new_content.finish()

with open(output_name, 'w') as f_out:
    f_out.write(new_content.getvalue())
