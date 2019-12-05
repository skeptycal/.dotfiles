#!/usr/bin/env python3

import pytest
import functions.find_dup as fd


@pytest.mark.random_string
def test_random_string():
    assert len(fd.random_string()) == fd.DEFAULT_STRING_LENGTH
    assert len(fd.random_string(10)) == 10
    assert type(fd.random_string()) == '<str>'


pytest.main()
