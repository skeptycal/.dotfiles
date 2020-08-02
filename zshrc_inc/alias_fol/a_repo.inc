#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

    set -a

# *############################################## repo setup
alias gi='cp ~/.dotfiles/.gitignore .'
alias sba='source .venv/bin/activate || source venv/bin/activate'
alias sda='deactivate'
alias d="docker "
alias pe='pipenv'
alias pes='pipenv shell'
alias pei='pipenv install'
alias peg='pipenv graph'
alias ve="virtualenv"
alias vew="virtualenvwrapper"
