#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

# import autosys
import datetime as dt
from appdirs import AppDirs

APPNAME = "IsSunday"
APPAUTHOR = "Skeptycal"
VERSION = "1.0.0"


def which_day():
    return dt.datetime.now().isoweekday()


def is_day(day: int):
    return which_day() == day


def is_sunday() -> bool:
    return is_day(7)


def is_monday() -> bool:
    return is_day(1)


def do_sunday_tasks():
    pass


def do_monday_tasks():
    print("Monday")
    pass


def main():
    """
    CLI script main entry point.
    """

    print(which_day())

    if is_sunday():
        do_sunday_tasks()
    elif is_monday():
        do_monday_tasks()


if __name__ == "__main__":  # if script is loaded directly from CLI
    dirs = AppDirs(
        APPNAME, APPAUTHOR, version=VERSION, roaming=True, multipath=True
    )
    main()
