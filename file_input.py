#!/usr/bin/env python3
import sys
import pathlib
from stat import *


class FileList():
    """ process command line file list """

    # @classmethod
    def check_file(self, s: str):
        return pathlib.Path(s).is_file()

    def stat_file(self, s: str):
        return pathlib.Path(s).stat()

    def __init__(self):
        self.file_list: Tuple(str) = sys.argv[1:]
        # self.file_data: Dict(str, list(str)) =

        # (_ for _ in sys.argv[1:].sort() if pathlib.Path(_).is_file())
        # self.file_count: int = len(self.file_list)

    def ls(self):
        return self.file_list
        # for file in self.file_list:
        #     print(file)

    # def test_list(self):
    #     for file in self.file_list:
    #         assert self.check_file(file) == True


f = FileList
# for file in iter(f()):
#     print(file)

list1 = f().ls()
for x in list1:
    stat = pathlib.Path(x).stat()
    for field in stat:
        print(x, '  ', stat)
