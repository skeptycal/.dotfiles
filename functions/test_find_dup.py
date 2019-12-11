#!/usr/bin/env python3

import os
import sys

import pytest

import find_dup as fd

sys.path.append(os.path.join('.'))


def test_random_string():
    assert len(fd.random_string()) == fd.DEFAULT_STRING_LENGTH
    assert len(fd.random_string(10)) == 10
    # assert type(fd.random_string()) == '<class \'str\'>'


pytest.main()
