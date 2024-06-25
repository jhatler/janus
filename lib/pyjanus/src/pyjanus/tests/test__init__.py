"""pyJanus __init__ tests"""

import pytest
import pyjanus


def test_add():
    """Test add function."""
    assert pyjanus.add(1, 2) == 3

def test_divide():
    """Test add function."""
    assert pyjanus.divide(132, 12) == 11

def test_divide_zero():
    with pytest.raises(ZeroDivisionError):
        pyjanus.divide(1, 0)
