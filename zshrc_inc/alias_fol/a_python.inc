#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

    set -a

# *############################################## python
# change all .py files in current folder to executable
alias modpy='chmod +x *.py -c --preserve-root -- '
alias python='python3 '
# alias pip='/usr/local/opt/python@3.8/bin/pip3 '
alias py="python -m "
alias pret='prettier * --write --insert-pragma'
# alias pwdcopy='pwd | pbcopy'
alias piplist='pip list | tail -43 | cut -d " " -f 1'

alias pm="pygmentize"
alias dj="python3 manage.py runserver"

# nifty extras
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias pypath='python -c "import sys; print(sys.path)" | tr "," "\n" | grep -v "egg"'
alias pycclean='find $PWD -name "*.pyc" -exec rm {} \; && find $PWD -name "__pycache__" -exec rm -rf {} \;'
