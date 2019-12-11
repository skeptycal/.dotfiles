#!/usr/bin/env python3
# pylint: disable=using-constant-test

import os
import sys
from typing import Any, List
from pathlib import Path
import random
import string
import hashlib

VERBOSE = 3  # 0 = quiet, 1 = feedback, 2 = testing / comments, 3 = errors
DEFAULT_STRING_LENGTH = 5

CSI = "\x1B["


class Ansi():
    """
    ANSI color strings
    """
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def print_ansi_format_table():
    """
    prints table of formatted text format options
    """
    for style in range(8):
        for fg in range(30, 38):
            s1 = ''
            for bg in range(40, 48):
                format = ';'.join([str(style), str(fg), str(bg)])
                s1 += '\x1b[%sm %s \x1b[0m' % (format, format)
            print(s1)
        print('\n')


if True:  # list test functions
    def random_string(l: int = 5) -> str:
        return ''.join(
            [random.choice(string.ascii_letters + string.digits) for _ in range(l)])

    def random_int(l: int = 5) -> int:
        return int(''.join(
            [random.choice(string.digits) for _ in range(l)]))

    def create_random_string_list(n: int = 5, l: int = 1) -> List[str]:
        return [random_string(l) for _ in range(n)]

    def create_random_int_list(n: int = 5, l: int = 1) -> List[int]:
        return [random_int(l) for _ in range(n)]


def hashfile(path, blocksize=65536):
    with open(path, 'rb') as f:
        hasher = hashlib.md5()
        buf = f.read(blocksize)
        while len(buf) > 0:
            hasher.update(buf)
            buf = f.read(blocksize)
    return hasher.hexdigest()


def find_dup(list1: List[Any]):
    """ Find duplicate values in 2 lists. """
    list1.sort()
    result = []
    for i, v in enumerate(list1):
        try:
            if v == list1[i + 1]:
                result.append(v)
        except IndexError:
            continue
    return list(set(result))


def ls(path: str = '.', pattern='*'):
    return Path(path).resolve().rglob(pattern=pattern)


def find_dup_files(file_list: List[str]):
    # Dups in format {hash:[names]}
    dups = {}
    for filename in fileList:
        # Get the path to the file
        path = os.path.join(dirName, filename)
        # Calculate hash
        file_hash = hashfile(path)
        # Add or append the file path
        if file_hash in dups:
            dups[file_hash].append(path)
        else:
            dups[file_hash] = [path]
    return dups


def error(e: Exception):
    if VERBOSE > 2:
        print(e)


def tprint(*args, **kwargs):
    if VERBOSE > 0:
        print(*args, **kwargs)


def main():
    n: int = DEFAULT_STRING_LENGTH
    if len(sys.argv) > 1:
        try:
            n = int(sys.argv[1])
        except TypeError as e:
            error(e)
    tprint("find_dup.py [length]")
    print("."*79)
    print("'find duplicates' for lists of python objects. ")
    print("  testing with strings and ints of length <n> (default 10)")
    l1 = create_random_string_list(n)
    i1 = create_random_int_list(n)
    # print()
    # print(f'String list {type(l1[0])} {l1}')
    # print()
    l1.sort()
    # print(f'Sorted string list {type(l1[0])} {l1}')
    # print("."*79)
    # print(f'Int list {type(i1[0])} {i1}')
    # print()
    i1.sort()
    # print(f'Sorted int list {type(i1[0])} {i1}')
    print()
    print('--> duplicate values in string list: ', find_dup(l1))
    print()
    print('--> duplicate values in int list:    ', find_dup(i1))
    print("."*79)
    print()
    print_ansi_format_table()


if __name__ == "__main__":
    main()
