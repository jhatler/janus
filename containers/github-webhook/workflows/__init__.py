"""
Event Workflows.
"""

# pylint: disable=duplicate-code
# jscpd:ignore-start

from glob import glob
from importlib import import_module
from os.path import basename, dirname, isfile, join

# add all the modules in this dir to __all__ so * imports them
__all__ = [
    basename(f)[:-3]
    for f in glob(join(dirname(__file__), "*.py"))
    if not f.endswith("__init__.py")
]
__mod__ = [import_module("." + m, package=__name__) for m in __all__ if isfile(m)]

# jscpd:ignore-end
