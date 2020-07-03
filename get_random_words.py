#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# get_random_words.py

if (
    False
):  # examples from: https://www.programcreek.com/python/example/5779/io.TextIOWrapper

    def _fopen(fname, mode):
        """
        Extend file open function, to support
            1) "-", which means stdin/stdout
            2) "$cmd |" which means pipe.stdout
        """
        if mode not in ["w", "r", "wb", "rb"]:
            raise ValueError("Unknown open mode: {mode}".format(mode=mode))
        if not fname:
            return None
        fname = fname.rstrip()
        if fname == "-":
            if mode in ["w", "wb"]:
                return sys.stdout.buffer if mode == "wb" else sys.stdout
            else:
                return sys.stdin.buffer if mode == "rb" else sys.stdin
        elif fname[-1] == "|":
            pin = pipe_fopen(fname[:-1], mode, background=(mode == "rb"))
            return pin if mode == "rb" else TextIOWrapper(pin)
        else:
            if mode in ["r", "rb"] and not os.path.exists(fname):
                raise FileNotFoundError(
                    "Could not find common file: {}".format(fname)
                )
            return open(fname, mode)

    def popen(cmd, mode="r", buffering=-1):
        # Helper for popen() -- a proxy for a file whose close waits for the process
        if not isinstance(cmd, str):
            raise TypeError(
                "invalid cmd type (%s, expected string)" % type(cmd)
            )
        if mode not in ("r", "w"):
            raise ValueError("invalid mode %r" % mode)
        if buffering == 0 or buffering is None:
            raise ValueError("popen() does not support unbuffered streams")
        import subprocess, io

        if mode == "r":
            proc = subprocess.Popen(
                cmd, shell=True, stdout=subprocess.PIPE, bufsize=buffering
            )
            return _wrap_close(io.TextIOWrapper(proc.stdout), proc)
        else:
            proc = subprocess.Popen(
                cmd, shell=True, stdin=subprocess.PIPE, bufsize=buffering
            )
            return _wrap_close(io.TextIOWrapper(proc.stdin), proc)

    def __iter__(self):
        import csv
        import subprocess
        from io import TextIOWrapper

        import sys

        if self.program.endswith(".py"):
            # If it is a python program, it's really nice, possibly required,
            # that the program be run with the same interpreter as is running this program.
            #
            # The -u option makes output unbuffered.  http://stackoverflow.com/a/17701672
            prog = [sys.executable, "-u", self.program]
        else:
            prog = [self.program]

        p = subprocess.Popen(
            prog + self.options,
            stdout=subprocess.PIPE,
            bufsize=1,
            env=self.env,
        )

        yield from csv.reader(
            TextIOWrapper(p.stdout, encoding="utf8", errors="replace")
        )

    def next_filehandle(self):
        """Go to the next file and retrun its filehandle or None (meaning no more files)."""
        filename = self.next_filename()
        if filename is None:
            fhandle = None
        elif filename == "-":
            fhandle = io.TextIOWrapper(
                sys.stdin.buffer, encoding=self.encoding
            )
        elif filename == "<filehandle_input>":
            fhandle = self.filehandle
        else:
            filename_extension = filename.split(".")[-1]
            if filename_extension == "gz":
                myopen = gzip.open
            elif filename_extension == "xz":
                myopen = lzma.open
            elif filename_extension == "bz2":
                myopen = bz2.open
            else:
                myopen = open
            fhandle = myopen(filename, "rt", encoding=self.encoding)
        self.filehandle = fhandle
        return fhandle

    def toprettyxml(self, indent="\t", newl="\n", encoding=None):
        if encoding is None:
            writer = io.StringIO()
        else:
            writer = io.TextIOWrapper(
                io.BytesIO(),
                encoding=encoding,
                errors="xmlcharrefreplace",
                newline="\n",
            )
        if self.nodeType == Node.DOCUMENT_NODE:
            # Can pass encoding only to document, to put it into XML header
            self.writexml(writer, "", indent, newl, encoding)
        else:
            self.writexml(writer, "", indent, newl)
        if encoding is None:
            return writer.getvalue()
        else:
            return writer.detach().getvalue()


with open("/usr/share/dict/words") as w:
    print(len(w))
    print(w.readline())
