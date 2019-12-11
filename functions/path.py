#!/usr/bin/env python3
import sys
from stat import *
from pathlib import Path
from typing import Any, List, Sequence, Tuple


class FileList(Path):
    """ process command line file list """

    FILTER_TEMPLATE = {
        "name": ["*"],


    }
    # @classmethod

    def is_file(self, s: str):
        return pathlib.Path(s).is_file()

    def stat_file(self, s: str):
        return pathlib.Path(s).stat()

    def set_file_list(self):
        pass

    def __init__(self):
        self.filter: str = sys.argv[1:] or '*'

        # self.set_file_list(self)
        # self.file_data: Dict(str, list(str)) =

        # (_ for _ in sys.argv[1:].sort() if pathlib.Path(_).is_file())
        # self.file_count: int = len(self.file_list)

    def ls(self, filter: str = self.filter) -> Sequence[Path]:
        return self.iterdir(ls(self.filter))

    def print_listing(self, filter: str = '*', wide: str = True, pretty: str = True):
        for file in self.ls:
            print(file)

    # def get_dirs(self):
    #     return [x for x in self.file_list]
    # def test_list(self):
    #     for file in self.file_list:
    #         assert self.check_file(file) == True


if __name__ == "__main__":
    f = FileList
    # for file in iter(f()):
    #     print(file)

    list1 = f().ls()
    for x in list1:
        stat = pathlib.Path(x).stat()
        for field in stat:
            print(x, '  ', stat)
