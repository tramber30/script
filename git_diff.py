#!/usr/bin/python
# Use meld as diff tool for git
# Add section in ~/.gitconfig:
#
#   [diff]
#        external = ~/git_diff.py
#

# compatibility workaround for python2.x
from __future__ import print_function
import sys
import os

print("Diff on", sys.argv[5])
os.system('/usr/bin/meld "%s" "%s" 2>/dev/null' % (sys.argv[2], sys.argv[5]))
