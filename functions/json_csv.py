#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# pylint: disable=using-constant-test, unused-import, broad-except, unused-argument

if True:
    import argparse
    import csv
    import fileinput
    import math
    import os
    import re
    import sys

    from collections import OrderedDict
    from pathlib import Path
    from typing import Any, List

    try:
        import numpy as NP
        CAN_NP = True
    except ImportError:
        CAN_NP = False

    try:
        import pandas as PD
        CAN_PD = True
    except ImportError:
        CAN_PD = False

    # use faster 'ujson' if available
    try:
        import ujson as json
        FAST_JSON = True
    except ImportError:
        import json
        FAST_JSON = False

    # supported file types
    # 1st entry (*) marks default
    SUPPORTED_FILE_TYPES = [
        "json",
        "csv"
    ]

    # use xlsxwriter if available
    try:
        import xlsxwriter
        CAN_XLS = True
        SUPPORTED_FILE_TYPES.append('xls')
    except ImportError:
        CAN_XLS = False

    #  TODO: pdf support??

    DEFAULT_ARG_LIST = [
        '"path", type=str, help="path of files to convert"',
        '"-o", type=str, help="output format [' +
        ', '.join(SUPPORTED_FILE_TYPES) +
        '] (default = ' + SUPPORTED_FILE_TYPES[0] + ')"',
        '"-v", "--verbose", action="count", default=0, help="increase output verbosity"'
    ]


def set_opts(arg_list: List[str]) -> (argparse.ArgumentParser.parse_args, Exception):
    """
    Return an argparse namespace based on the given argument list
    """

    parser = argparse.ArgumentParser(
        prog='json2csv',
        description='File format conversions (' + ', '.join(SUPPORTED_FILE_TYPES) + ').')
    for arg in arg_list:
        try:
            eval('parser.add_argument(' + arg + ')')  # pylint: disable=eval-used
        except Exception as e:
            print(e)
            return e
    return parser.parse_args()


def main():
    # parser = argparse.ArgumentParser()

    args = set_opts(DEFAULT_ARG_LIST)
    if isinstance(args, Exception):
        print(args)
    VERBOSE = args.verbose
    print(type(args))
    print()
    print(args)
    # args = parser.parse_args()
    # print(args.counter + 1)

    # p = Path()

    # export data
    # if converted_file_type == "json":
    #     data_size = exportJSON(imported_data, export_filename)
    # elif converted_file_type == "csv":
    #     data_size = exportCSV(imported_data, export_filename)

    # if data_size > 1000000:
    #     print(
    #         f">> Records exported to: {export_filename} <{math.floor(data_size/1000)/10} MB>")
    # elif data_size > 0:
    #     print(
    #         f">> Records exported to: {export_filename} <{math.floor(data_size/10)/10} KB>")
    # else:
    #     print(">> Error, no file exported...")

    # supported file types
    # prompt user for file name
    # attempt to import based on file name
    # prompt user for export file name
    # export data

 ################################
 # IMPORT FUNCTIONS
 ################################


def get_file_text():
    for path in Path.cwd().rglob('*.py'):
        yield path.read_text()


def out(filename: str):
    with open(Path(filename), mode='wt') as f:
        f.write('# config goes here')


def parse_file_name(filename: str) -> (str, Exception):
    pass


def parse_file(filename: str) -> (str, Exception):
    pass


def importJSON(f):
    pass


def importCSV(f):
    pass

################################
# EXPORT FUNCTIONS
################################


def exportJSON(data, filename):
    pass


def exportCSV(data, filename):
    pass

# ----------


if __name__ == "__main__":
    main()
