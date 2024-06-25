"""
Handle GitHub Events.
"""

import glob
import importlib
import os

# get all the modules in this directory
modules = glob.glob(os.path.join(os.path.dirname(__file__), "*.py"))

# add all the modules to __all__ so * imports them
__all__ = [ os.path.basename(f)[:-3] for f in modules if os.path.isfile(f) and not f.endswith('__init__.py')]

# import all the modules
for m in __all__:
    importlib.import_module('.' + m, package='handlers')
