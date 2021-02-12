from hypothesis import given, settings
from hypothesis import strategies as st


@given(st.text())
@settings(max_examples=10000)
def test_string_identity(s):
    assert s == s


@given(st.integers())
@settings(max_examples=10000)
def test_int_identity(i):
    assert i == i
