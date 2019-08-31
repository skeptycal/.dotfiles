#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#? ############################# skeptycal.com ################################
NAME="${BASH_SOURCE##*/:'standard_script_modules'}"
VERSION='0.1.2'
DESC='standard script modules for macOS catalina (Bash 5.0 with GNU coreutils)'
USAGE="source ${NAME:-}"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="Copyright (c) 2019 Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"
#? ############################################################################
set -a
# set -aET # ET - inherit traps
export SET_DEBUG=0 # set to 1 for verbose testing

exec 6>&1 # non-volatile stdout leaves return values of stdout undisturbed
# return 0
