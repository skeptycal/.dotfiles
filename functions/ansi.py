#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# based on ANSI standard ECMA-48
#   http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-048.pdf

# pylint: disable=using-constant-test

import time
from typing import Any, List
from collections import UserDict
try:
    import ujson as json
except ImportError:
    import json

VERBOSE = 3  # 0 = quiet, 1 = feedback, 2 = testing / comments, 3 = errors

CSI = "\x1B["  # ANSI ECMA-48 Control Sequence Introducer

COLOR_INFO = {}


def timeit(method):
    def timed(*args, **kw):
        ts = time.time()
        result = method(*args, **kw)
        te = time.time()
        if 'log_time' in kw:
            name = kw.get('log_name', method.__name__.upper())
            kw['log_time'][name] = int((te - ts) * 1000)
        else:
            print('%r  %2.2f ms' %
                  (method.__name__, (te - ts) * 1000))
        return result
    return timed


class Ansi(UserDict):
    """
    ANSI color magic 🦄
    """

    def __init__(self):
        super().__init__()

        self.CSI: str = "\x1B["
        self.CSI_SUFFIX: str = "m"
        self.PREFIX_8_BIT: str = '8;5;'
        self.RESET: str = self.CSI + '0' + self.CSI_SUFFIX
        self._load_colors()

        for (key, value) in self.items():
            def key_method(self, value=value):
                """
                Dynamic color methods for each ANSI code - generated from dictionary keys.
                """
                return value
            setattr(self.__class__, key, value)

    def _load_colors(self):
        # basic output colors
        self.add('HEADER', self.fg8('229'))
        self.add('OKBLUE', self.encode('94'))
        self.add('OKGREEN', self.encode('92'))
        self.add('WARNING', self.encode('93'))
        self.add('FAIL', self.encode('91'))

        # personal favorites
        self.add('MAIN', self.fg8('229'))
        self.add('WARN', self.fg8('203'))
        self.add('COOL', self.fg8('38'))
        self.add('BLUE', self.fg8('38'))
        self.add('GO', self.fg8('28'))
        self.add('CHERRY', self.fg8('124'))
        self.add('CANARY', self.fg8('226'))
        self.add('ATTN', self.fg8('178'))
        self.add('PURPLE', self.fg8('93'))
        self.add('RAIN', self.fg8('93'))
        self.add('LIME', self.encode('32;1'))
        self.add('WHITE', self.encode('37'))

        # various forms of 'RESET'
        self.add('RESTORE', self.encode('0'))
        self.add('RESET', self.encode('0'))

        # 4-bit effects
        self.add('ENDC', self.encode('0'))
        self.add('BOLD', self.encode('1'))
        self.add('FAINT', self.encode('2'))
        # 3 (ITALIC) - not widely supported - works with iTerm2 / macOS
        self.add('ITALIC', self.encode('3'))
        self.add('UNDERLINE', self.encode('4'))
        self.add('REVERSE', self.encode('7'))
        self.add('STRIKE', self.encode('9'))

        # 4-bit color foreground set
        self.add('Black', self.encode('30'))
        self.add('Red', self.encode('31'))
        self.add('Green', self.encode('32'))
        self.add('Yellow', self.encode('33'))
        self.add('Blue', self.encode('34'))
        self.add('Magenta', self.encode('35'))
        self.add('Cyan', self.encode('36'))
        self.add('White', self.encode('37'))
        self.add('BrightBlack', self.encode('90'))
        self.add('BrightRed', self.encode('91'))
        self.add('BrightGreen', self.encode('92'))
        self.add('BrightYellow', self.encode('93'))
        self.add('BrightBlue', self.encode('94'))
        self.add('BrightMagenta', self.encode('95'))
        self.add('BrightCyan', self.encode('96'))
        self.add('BrightWhite', self.encode('97'))

        # 4-bit color background set
        self.add('BBlack', self.encode('40'))
        self.add('BRed', self.encode('41'))
        self.add('BGreen', self.encode('42'))
        self.add('BYellow', self.encode('43'))
        self.add('BBlue', self.encode('44'))
        self.add('BMagenta', self.encode('45'))
        self.add('BCyan', self.encode('46'))
        self.add('BWhite', self.encode('47'))
        self.add('BBrightBlack', self.encode('100'))
        self.add('BBrightRed', self.encode('101'))
        self.add('BBrightGreen', self.encode('102'))
        self.add('BBrightYellow', self.encode('103'))
        self.add('BBrightBlue', self.encode('104'))
        self.add('BBrightMagenta', self.encode('105'))
        self.add('BBrightCyan', self.encode('106'))
        self.add('BBrightWhite', self.encode('107'))

        for _ in range(232):
            self.add('fg_' + str(_), self.fg8(str(_)))
            self.add('bg_' + str(_), self.bg8(str(_)))

        for _ in range(232, 256):
            self.add('fg_gray_' + str(_), self.fg8(str(_)))
            self.add('bg_gray_' + str(_), self.bg8(str(_)))

    def encode(self, color: int = 15) -> str:
        """
        Encode ANSI 4-bit text effects

        Effect              - effect code
        ENDC                - 0
        BOLD                - 1
        FAINT               - 2
        ITALIC              - 3 # not widely supported
        UNDERLINE           - 4
        BLINK               - 5
        REVERSE             - 7
        CONCEAL             - 8
        STRIKE              - 9
        FRAME               - 51
        CIRCLE              - 52
        OVERLINE            - 53

        encode ANSI 4-bit foreground color set
        ------------------------------------------------------
        Color               - foreground code
        Black	            - 30
        Red	                - 31
        Green	            - 32
        Yellow	            - 33
        Blue	            - 34
        Magenta	            - 35
        Cyan	            - 36
        White	            - 37
        BrightBlack	        - 90
        BrightRed	        - 91
        BrightGreen	        - 92
        BrightYellow	    - 93
        BrightBlue	        - 94
        BrightMagenta	    - 95
        BrightCyan	        - 96
        BrightWhite	        - 97

        encode ANSI 4-bit background color set
        ------------------------------------------------------
        Color               - background code
        BBlack              - 40
        BRed                - 41
        BGreen              - 42
        BYellow             - 43
        BBlue               - 44
        BMagenta            - 45
        BCyan               - 46
        BWhite              - 47
        BBrightBlack        - 100
        BBrightRed          - 101
        BBrightGreen        - 102
        BBrightYellow       - 103
        BBrightBlue         - 104
        BBrightMagenta      - 105
        BBrightCyan         - 106
        BBrightWhite        - 107
        """
        return self.CSI + str(color) + self.CSI_SUFFIX

    def fg8(self, color: int = 15) -> str:
        """
        # Encode ANSI 8-bit foreground color set
        ------------------------------------------------------
        foreground encoding - `ESC[ 38;5;⟨n⟩ m`

        color -
        -     0-7:        standard colors (e.g. 4-bit ESC [ 30–37 m)
        -    8-15:        high intensity colors (e.g. 4-bit ESC [ 90–97 m)
        -  16-231:        6 × 6 × 6 cube (216 colors): 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5)
        - 232-255:        grayscale from black to white in 24 steps
        """
        return self.CSI + '3' + self.PREFIX_8_BIT + str(color) + self.CSI_SUFFIX

    def bg8(self, color: int = 15) -> str:
        """
        # Encode ANSI 8-bit background color set
        ------------------------------------------------------
        background encoding - `ESC[ 48;5;⟨n⟩ m`

        color -
        -     0-7:        standard colors (e.g. 4-bit ESC [ 30–37 m)
        -    8-15:        high intensity colors (e.g. 4-bit ESC [ 90–97 m)
        -  16-231:        6 × 6 × 6 cube (216 colors): 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5)
        - 232-255:        grayscale from black to white in 24 steps
        """
        return self.CSI + '4' + self.PREFIX_8_BIT + str(color) + self.CSI_SUFFIX

    # personal favorites

    # def MAIN(self, *args, **kwargs):
    #     print(self['MAIN'], args, self['RESET'], **kwargs)

    # def WARN(self, *args, **kwargs):
    #     print(self['WARN'], *args, self['RESET'], **kwargs)

    # def COOL(self, *args, **kwargs):
    #     print(self['COOL'], *args, self['RESET'], **kwargs)

    # def BLUE(self, *args, **kwargs):
    #     print(self['BLUE'], *args, self['RESET'], **kwargs)

    # def GO(self, *args, **kwargs):
    #     print(self['GO'], *args, self['RESET'], **kwargs)

    # def CHERRY(self, *args, **kwargs):
    #     print(self['CHERRY'], *args, self['RESET'], **kwargs)

    # def CANARY(self, *args, **kwargs):
    #     print(self['CANARY'], *args, self['RESET'], **kwargs)

    # def ATTN(self, *args, **kwargs):
    #     print(self['ATTN'], *args, self['RESET'], **kwargs)

    # def PURPLE(self, *args, **kwargs):
    #     print(self['PURPLE'], *args, self['RESET'], **kwargs)

    # def RAIN(self, *args, **kwargs):
    #     print(self['RAIN'], *args, self['RESET'], **kwargs)

    # def LIME(self, *args, **kwargs):
    #     print(self['LIME'], *args, self['RESET'], **kwargs)

    # def WHITE(self, *args, **kwargs):
    #     print(self['WHITE'], *args, self['RESET'], **kwargs)

    def add(self, key: str, value: str):
        """
        Add key, value pair to dictionary.
        """
        self[key] = value

    def key_list(self) -> List[Any]:
        """
        Return a sorted list of dictionary keys.
        """
        return sorted([*self])

    def dict_out(self):
        return {key: value for (key, value) in self.items()}

    @timeit
    def json_out(self) -> str:
        result = '{\n'
        for key in self:
            value: str = self[key]  # [1:]
            value = value[1:]
            result += f'    \"{key}\": \"{value}\",\n'
        result = result[:-2]
        result += '\n}'
        return result

    @timeit
    def json_out2(self) -> str:
        result = '{\n'
        for _ in self:
            value: str = self[_]  # [1:]
            value = value[1:]
            result += '    \"' + _ + '\": \"' + value + '\",\n'
        result = result[:-2]
        result += '\n}'
        return result

    @timeit
    def json_out3(self) -> str:
        return json.dumps(self.dict_out(), indent=4)
        # result = '{\n'
        # for _ in self:
        #     value: str = self[_]  # [1:]
        #     value = value[1:]
        #     result += '    \"' + _ + '\": \"' + value + '\",\n'
        # result = result[:-2]
        # result += '\n}'
        # return result

    def value_list(self) -> List[Any]:
        """
        Return a sorted list of dictionary values.
        """
        return sorted(self.values())

    def sample(self, color: str = 'MAIN') -> str:
        return f"{self[color]}{color}{self['RESET']}"

    def print_color_samples(self):
        c: int = 0
        for color in self.key_list():
            print(f"{self[color]}{color:^16.16}{self['RESET']}", end='')
            if c > 6:
                print()
                c = 0
            else:
                c += 1


def _print_ansi_format_table():
    """
    Print table of formatted text format options.
    Used for testing. Not part of the Ansi class.
    """
    for style in range(10):
        for fg in range(30, 38):
            s1 = ''
            for bg in range(40, 48):
                fmt = ';'.join([str(style), str(fg), str(bg)])
                s1 += CSI + '%sm %s \x1b[0m' % (fmt, fmt)
            print(s1)
        print('\n')


def main():
    '''
    CLI script main entry point with examples
    '''
    a = Ansi()
    print(a.get('MAIN', 'WHITE'), 'MAIN color')
    print()
    # print(dir(a))
    print(dir(a.MAIN))
    print(a.MAIN)
    # a.MAIN('This is the MAIN color.')
    # a.BLUE('Feeling blue ...')
    # a.WARN('Warning...')
    # for color in a.key_list():
    #     print(f"{a[color]}{color}{a['RESET']} ", end='')
    # a.print_color_samples()
    json_data = a.json_out()
    json_data = a.json_out2()
    json_data = a.json_out3()


if __name__ == "__main__":  # if script is loaded directly from CLI
    main()
