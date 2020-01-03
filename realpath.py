#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
""" realpath - Print the resolved absolute file name of FILE(s)

    Usage:
        realpath FILE [-Rtz] [-q | -v] [--color COLOR] [--pattern PATTERN]
        realpath [--help | --version]

    Options:
        FILE(s)                 Search pattern to match
        -q, --quiet             suppress most error messages  [default: False]
        -R --recursive          Perform search recursively    [default: False]
        -t --test               Test mode for debugging       [default: False]
        -v --verbose            Display detailed progress     [default: False]
        -z, --zero              end each output line with NUL [default: False]

        -C COLOR --color COLOR  Highlight color for matches   [default: BLUE]
        -P PATTERN --pattern PATTERN    Pattern to highlight  [default: None]

        --version               Show version.
        -h --help               Show this screen.

    Exit status:

        0 if all file names were printed without issue.
        1 otherwise.

    """
# pylint: disable=using-constant-test, bare-except, line-too-long

import os
import sys
from random import randint
from pathlib import Path

from docopt import docopt

__version__ = '1.0.0'

# ?############################## CONSTANTS
if True:
    NL: str = os.linesep  # -or- chr(10)  # newline character
    NUL: str = chr(0)  # NUL character

    # ANSI colors for terminal output.
    MAIN = "\001\033[38;5;229m"
    WARN = "\001\033[38;5;203m"
    BLUE = "\001\033[38;5;38m"
    GO = "\001\033[38;5;28m"
    CHERRY = "\001\033[38;5;124m"
    CANARY = "\001\033[38;5;226m"
    ATTN = "\001\033[38;5;178m"
    RAIN = "\001\033[38;5;93m"
    WHITE = "\001\033[37m"
    RESTORE = "\001\033[0m\002"
    RESET = "\001\033[0m"

    DEFAULT_PRINT_COLOR = RESTORE
    DEFAULT_ERR_COLOR = WARN
    DEFAULT_SUCCESS_COLOR = GO
    DEFAULT_INFO_COLOR = BLUE

# ?############################## Utilities

# ?############################## RealPath class


class Verbose():
    ''' Handles various levels of messages to `stdout`, `stderr`, or `file`.

        >- 0 - quiet: only necessary feedback (really, just don't give me any messages!)
        >- 1 - normal: expected POSIX feedback (tell me only if I need to know!)
        >- 2 - verbose: detailed feedback and errors (let me know what's going on!)
        >- 3 - debugging: all plus variables and tests (dev level debugging output)
        >- 4 - exceptions: messages and trace info (emergency messages and exit codes)
        '''

    def __init__(self, v: int = 1, log=False):
        self.verbosity: int = v
        if log:
            # create logfile
            pass
        super().__init__()

    def unique_path(self, directory, name_pattern):
        counter = 0
        name_pattern = this_name + str(randint(10000, 99999))
        while True:
            counter += 1
            path = directory / name_pattern.format(counter)
            if not path.exists():
                return path

    @staticmethod
    def catch(func):
        def wrapper():
            print(f"{v=}")
            print(f"{func.__str__=}")
            print(f"{func.__class__=}")

        return wrapper

    def print_dec(self, func):
        def wrapper():
            print(f"{v=}")
            print(f"{func.__str__=}")
            print(f"{func.__class__=}")

        return wrapper

    @staticmethod
    def cprint(*args, color=DEFAULT_PRINT_COLOR, sep=' ', end=NL, file=sys.stdout, flush=False):
        ''' Prints 'args' in color using the keyword arg 'color' '''
        print(color, *args, RESET, sep=sep, end=end, file=file, flush=flush)

    @staticmethod
    def printvar(*args, color=DEFAULT_ERR_COLOR, file=sys.stderr):
        for arg in args:
            cprint(f"{arg=}", color=color, file=file)

    def vprint(self, *args, v=1, sep=sep, end=end, flush=False):
        """ Print based on chosen verbosity level of object.

            0 - quiet: only necessary feedback
            1 - normal: expected POSIX feedback
            2 - verbose: detailed feedback and errors
            3 - debugging: detailed dev info and errorss
            """
        if v == 3:
            printvars(*args, color=WARN, file=stderr, sep=sep, end=end, flush=flush)
            # for arg in args:
            #     cprint(f"{arg=}")
        elif v == 2:
            cprint(*args, color=ATTN, file=stderr, sep=sep, end=end, flush=flush)
        elif v == 1:
            cprint(*args, color=color, file=stdout, sep=sep, end=end, flush=flush)


class RealPath():
    ''' Returns absolute path of files matching FILE.

        ### Options:
        - verbose
        - quiet
        - nul termination
        - color highlighting

        ### Usage:

        `realpath FILE [-Rtz] [-q | -v] [--color COLOR] [--pattern PATTERN]`

        `realpath [--help | --version]`
        '''

    def __init__(self):
        self.args = docopt(__doc__, version=__version__)
        self.v = Verbose()
        self.verbosity = 3
        if self.args['FILE'] is None:
            self.die('FILE is REQUIRED.',
                     'realpath FILE [-qRvz] [--color COLOR]')
        self.file: str = self.args['FILE']
        self.verbosity: int = 1
        try:
            self.recursive: bool = self.args['--recursive']
            self.test: bool = self.args['--test']
            self.zero: bool = self.args['--zero']
            self.quiet: bool = self.args['--quiet']
            self.verbose: bool = self.args['--verbose']
            self.color: str = self.args['--color']
        except:
            self._print_args()
            self.die('Invalid options ...',
                     'realpath FILE [-qRvz] [--color COLOR]')
        if self.verbose:
            self.verbosity = 2
        if self.quiet:  # quiet overrides verbose
            self.verbosity = 0
        try:
            self.p = Path(self.file).cwd()
        except:
            # self.p = Path('*')  # ! TESTING
            self.die('FILE not valid.')
        if self.recursive:
            self.files = self.p.rglob(self.file)
        else:
            self.files = self.p.glob(self.file)
        if not self.zero:
            self.sep = NL
        else:
            self.sep = NUL
        super().__init__()

    @Verbose.catch()
    def die(self, *a, err: Exception = Exception):
        """
        Print error messages and exit.
        """
        vprint(2, *a, WARN)
        if self.verbosity > 1:
            sys.exit(err)
        else:
            sys.exit(1)

    def process(self):
        # print([_ for _ in self.files])
        p = Path()
        vprint(1)
        vprint(
            1, 'Realpath - resolved absolute path for file(s)', color=BLUE)
        vprint(1)
        for file in self.files:
            print(p(file).resolve(), end=self.sep)
        # add regex color (if)

    def _print_args(self):
        if self.verbosity > 1:
            print()
            print('command line arguments:')
            print(
                ''.join([f"\n\t{k}: \t{self.args[k]}" for k in self.args.keys()]))

    def _print_dir(self):
        if self.verbosity > 1:
            print()
            print('Methods:', end='')
            print(''.join([f"\n\t{d}" for d in self.__dir__()]))
            print()

    def _test(self):
        vprint(3)
        vprint(3, MAIN, 'Object: ', self)
        self._print_dir()
        self._print_args()


# ?############################## main()
def main():
    '''
    CLI script main entry point.
    '''
    this_name:str = __name__
    rp = RealPath()
    rp.process()
    rp._print_args()


# ?############################## CLI entry check
if __name__ == "__main__":
    main()

# ?############################## References

# re.sub(r'(car)', r'<b>\1</b>', the_string, flags=re.I)
# REF: https://stackoverflow.com/a/11765010

# def realpath(self, files: list = ['.'], pattern: str = '', COLOR: str = ansi_colors['BLUE']) -> list:
    #     try:
    #         hl_color = ansi_colors[COLOR]
    #         print([hl_color])
    #     except:
    #         hl_color = ansi_colors['BLUE']

    #     print(f"{files=}")
    #     if color_flag is True:
    #         files = set_highlight(
    #             hl_string=files,
    #             hl_pattern=pattern,
    #             COLOR=COLOR
    #         )
    #         print(realpath(os.path.realpath(item)))

# def set_highlight(self, hl_string: str = '.', hl_pattern: str = '', COLOR: str = BLUE) -> str:
    #     hl_repl = COLOR + hl_pattern + RESET_FG
    #     return re.sub(pattern=hl_pattern, repl=hl_repl, string=hl_string, flags=re.IGNORECASE)
