#!/usr/bin/env python3
import datetime
import plistlib
import tempfile
import time
from os import PathLike
from typing import Dict, Union

pl = dict(
    aString="Doodah",
    aList=["A", "B", 12, 32.1, [1, 2, 3]],
    aFloat=0.1,
    anInt=728,
    aDict=dict(
        anotherString="<hello & hi there!>",
        aThirdString="M\xe4ssig, Ma\xdf",
        aTrueValue=True,
        aFalseValue=False,
    ),
    someData=b"<binary gunk>",
    someMoreData=b"<lots of binary gunk>" * 10,
    aDate=datetime.datetime.fromtimestamp(time.mktime(time.gmtime())),
)

test_file_name: PathLike = 'some.random.plist'


def write_plist(fileName: PathLike) -> bool:
    try:
        with open(fileName, 'wb') as fp:
            plistlib.dump(pl, fp)
        return False
    except:
        return True


def read_plist(fileName: PathLike) -> Union[Dict, None]:
    try:
        with open(fileName, 'rb') as fp:
            return plistlib.load(fp)
    except:
        return None


if __name__ == '__main__':
    write_plist(fileName=test_file_name)
    data = read_plist(fileName=test_file_name)
    plistlib.

# with tempfile.NamedTemporaryFile() as output_file:
#     plistlib. (d, output_file)
#     output_file.seek(0)
#     print(output_file.read())
