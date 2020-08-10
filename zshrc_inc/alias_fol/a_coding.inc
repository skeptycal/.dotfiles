#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

set -a

# *############################################## repo setup
alias please='sudo '
alias gi='cp ~/.dotfiles/.gitignore .'
alias sba='source .venv/bin/activate || source venv/bin/activate'
alias sda='deactivate'
alias d="docker "
alias pc='pre-commit '
alias pci='pre-commit install && pre-commit install-hooks && pre-commit autoupdate'

# *############################################## python
# change all .py files in current folder to executable
alias modpy='chmod +x *.py -c --preserve-root -- '

# list with only names of packages ... no headers or versions
alias piplist='pip list | tail -n +3 | cut -d " " -f 1'

alias py="python -m "
alias pyv="python -m venv .venv"

# *############################################## poetry
alias p="poetry "
alias pu="poetry update"
alias pb="poetry build"
alias pub="poetry publish --build"

# poetry init [--name <...>] [--description <...>] [--author <...>] [--dependency <...>] [--dev-dependency <...>] [-l <...>]
alias pi='poetry init'
alias pos='poetry show'
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

# ! these hide configuration errors where aliases are ignored in poetry
# alias python='python3 '
# alias pip='pip3 '

# *############################################## pipenv
# * I use Poetry instead of PipEnv for now
# alias pe='pipenv'
# alias pes='pipenv shell'
# alias pei='pipenv install'
# alias peg='pipenv graph'
# alias ve="virtualenv"
# alias vew="virtualenvwrapper"
