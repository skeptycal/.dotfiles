#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

    set -a

# *############################################## python
# change all .py files in current folder to executable
alias modpy='chmod +x *.py -c --preserve-root -- '
alias piplist='pip list | tail -43 | cut -d " " -f 1'
alias pc='pre-commit '
alias pci='pre-commit install && pre-commit install-hooks && pre-commit autoupdate'

alias py="python -m "
alias pyv="python -m venv .venv"
alias pm="pygmentize"
alias dj="python3 manage.py runserver"

# *############################################## poetry
alias p="poetry "
alias pu="poetry update"
alias pb="poetry build"
alias pub="poetry publish --build"

# poetry init [--name <...>] [--description <...>] [--author <...>] [--dependency <...>] [--dev-dependency <...>] [-l <...>]
alias pi='poetry init'
alias pst="poetry show --tree"
alias prr='poetry export -f requirements.txt >requirements.txt'

export POETRY_CACHE_DIR=~/Library/Caches/pypoetry
export POETRY_VIRTUALENVS_PATH=${POETRY_CACHE_DIR}/virtualenvs
export POETRY_PYPI_TOKEN_PYPI=my-token


# *############################################## related
alias pret='prettier * --write --insert-pragma'
alias pm="pygmentize"

alias dj="python3 manage.py runserver"

alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias pypath='python -c "import sys; print(sys.path)" | tr "," "\n" | grep -v "egg"'
alias pycclean='find $PWD -name "*.pyc" -exec rm {} \; && find $PWD -name "__pycache__" -exec rm -rf {} \;'

# these hide configuration errors where aliases are ignored in poetry
# alias python='python3 '
# alias pip='pip3 '
