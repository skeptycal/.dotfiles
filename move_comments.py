#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
# from dataclasses import dataclass, field, Field


class PathPackError(IOError):
    ''' Error processing PathPack path. '''


class PathPack(Path):
    ''' pathlib.Path subclass to encapsulate more common methods.
    '''
    path_name: (Path) = '.'
    # _path: Field = field(init=False)

    def __init__(self, path_name):
        super().__init__()
        self.path_name = path_name
        self._path: Path = Path(self.path_name)

    @property
    def path(self):
        if not self._path:
            self._path = Path(self.path_name)
        return self._path

    @path.setter
    def path(self, value):
        if isinstance(value, str):
            try:
                self._path = Path(value).resolve()
            except IOError:
                raise PathPackError(
                    f'Error converting {self.path_name} to Path.')
        if not self._path.exists():
            try:
                self._path().touch()
            except IOError:
                raise PathPackError(f'Error creating {self.path_name}')

    @property
    def path_str(self):
        return self.path.as_posix()

    def __str__(self):
        return self.path_str


p = PathPack('.')


script_path = Path(__file__).resolve().parents
here = Path().cwd()

print(f"script location: {str(script_path[0]):<55.55}")
print(f"current path:    {str(here):<55.55}")
print(p)


# with Path()
