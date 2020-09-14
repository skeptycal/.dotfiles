#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
from pathlib import Path
from datetime import datetime as dt
# from dataclasses import dataclass
import typing as t
from os import PathLike
from pprint import pprint

from collections import Counter

# from loguru import logger

now: dt = dt.now()
year: int = now.year
author: str = 'Michael Treanor'

zsh_shebang: str = '''!/usr/bin/env zsh
-*- coding: utf-8 -*-
    shellcheck shell=bash
    shellcheck source=/dev/null
    shellcheck disable=2178,2128,2206,2034
'''


class FileManager(list):
    """ File manager for automatic addition modifications. """

    def __init__(self,
                 filename: PathLike,
                 template_end_flag: str = '@template_end',
                 comment_string: str = '#') -> None:
        super().__init__(self)
        self._name: str = self.path.name
        self.filename: PathLike = filename
        self._path: Path = None

        # if file does not exist, get rid of instance
        # # todo - find a better way ...
        # if self.path is None:
        #     del self

        self.end_flag: str = template_end_flag
        self.comment_str: str = comment_string

        # this sets length and also preloads text lines from file
        self._length: int = len(self.lines)

        # optionally used when the entire file is loaded as a single string
        self._data: t.AnyStr = ''

        # ... = self.header will preload _header
        self._header: t.List = []

    # * file operations for text file

    @property
    def path(self) -> Path:
        """ lazy determine and return path of file. """
        if not self._path:
            self._path = Path(self.filename).resolve()
        return self._path

    @property
    def name(self) -> t.AnyStr:
        if not self._name:
            self._name = self.path.name
        return self._name

    @property
    def lines(self) -> t.List[t.AnyStr]:
        """ lazy load lines from text file as needed """
        if not self:
            self.clear()
            with open(self.path) as _:
                self.extend(_.readlines())
        return self

    @property
    def refresh(self) -> t.List[t.AnyStr]:
        """ clear line list and reload from file """
        self.clear()
        return self.lines

    @property
    def data(self) -> t.AnyStr:
        """ lazy load text from text file as needed """
        if not self._data:
            with open(self.path) as _:
                self._data = _.read()
        return self._data

    def writelines(self) -> int:
        try:
            with open(self.path, mode='wt') as _:
                _.writelines(self.lines)
            return 0
        except OSError as e:
            logger.error(e)
            return 1
            # raise

    # * sorting and utility operations for text file

    @property
    def length(self) -> int:
        if not self._length:
            self._length = len(self.lines)
        return self._length

    def head(self, n: int = 5):
        return self[:n]

    def tail(self, n: int = 5):
        return self[-n:]

    def _count(self, needle: t.AnyStr) -> int:
        """ count occurrences of individual 'needle' strings in all lines """
        return sum(bool(x) for x in self if needle in x)

    def count_it(self, needle: t.AnyStr) -> int:
        """ count occurrences of 'needle' as complete, exact lines """
        return self.count(needle)

    def counter(self, needle: t.AnyStr) -> int:
        c = Counter(self)
        return c[needle]

    def word_count(self) -> int:
        return sum(x.count('') for x in self)

    # * edit header in text file

    @ property
    def header_index(self) -> int:
        ''' return index of header end flag or 0 if none is found '''
        for i, line in enumerate(self):
            if line == self.comment_str(self.end_flag):
                return i
        return 0

    @ property
    def header(self) -> t.List[t.AnyStr]:
        self._header = []

    def prune_header(self) -> t.List[t.AnyStr]:
        return self.lines[self.header_index()+1:]

    def get_header(self) -> t.List[t.AnyStr]:
        return self.lines[:self.header_index()]

    def place_header(self) -> t.List[t.AnyStr]:
        self.insert(0, self.header)
        return self

    # * edit lists of lines in text file

    def remove_comments(self) -> t.List[t.AnyStr]:
        return [x for x in self.lines if not x.startswith(self.comment_str)]

    def prune(self, _prune: t.AnyStr) -> t.List[t.AnyStr]:
        ''' remove 'prune' items '''
        return [x for x in self.lines if _prune in x]

    def purge(self, _keep: t.AnyStr) -> t.List[t.AnyStr]:
        ''' purge elements not containing 'keep' items '''
        return [x for x in self.lines if _keep in x]

    def blacklist(self, _blacklist: t.List) -> t.List[t.AnyStr]:
        ''' remove blacklisted items '''
        return [x for x in self.lines if x not in _blacklist]

    def whitelist(self, _whitelist: t.List) -> t.List[t.AnyStr]:
        ''' keep only whitelisted items '''
        return [x for x in self.lines if x in _whitelist]

    def starts(self, keep: bool = True) -> t.List[t.AnyStr]:
        pass

    # * edit individual lines in text file

    def make_comment(self, s: str):
        """ Add comment string to line. """
        return f"{self.comment_str}{s}"

    def undo_comment(self, s: str):
        """ Remove comment string at start of line. If comment string is
            not found at the start of the line (after removing whitespace),
            the original string is returned.
            """
        if s.rstrip().startswith(self.comment_str):
            return s.rstrip()[len(self.comment_str):]
        return s

        # class ZshHeader(Header):
        #     shebang: str = zsh_shebang
        #     comment_str: str = "#"


if __name__ == "__main__":
    template_flag: str = "#? ###################### copyright (c)"
    template_end: str = f"? ###################### copyright (c) {year} {author} #################"

    SAMPLE_FILE: str = 'test_zsh_boot.log'
    HEADER_FILE: str = "dotfiles_header.sh"

    def ls(path_name: PathLike = '.'):

        for _, _, files in os.walk(path_name):
            for f in files:
                print(f)

    # ls()

    print()
    fh = FileManager(SAMPLE_FILE)
    print(f"{fh.filename=}")
    print()
    # print(fh.head(2))
    # print()
    # print(fh.tail(2))
    # print()
    print(f"{fh._count('SUCCESS')=}")
    print(f"{fh._count('source')=}")
    print(f"{fh._count('zsh')=}")
    print(f"{fh._count('highlighter')=}")
    # print(fh._count('\n'))
    print(fh.counter('SUCCESS'))
    print(f"{fh.length=}")
    # print(fh.data)
    print(f"{fh.word_count()=}")

    print()
    # print(fh.make_comment('fdajd'))
    # pprint(fh.remove_comments())
    # print(fh.lines())
    pprint(fh)

# SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
# set - a

# _debug_tests() {
# 	if (( SET_DEBUG == 1 )); then
# 		printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${0##*/}${RESET:-}"
# 		color_sample
# 	fi
# }
#? ###################### copyright (c) 2019 Michael Treanor #################
