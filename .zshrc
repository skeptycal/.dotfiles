#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034

  # number of years the first commercial
  #   modem would take to transmit a movie: 42.251651342415241
  #   this is very nearly the time since I wrote my first program
  #   I'm glad I didn't watch that movie instead ...

#? ######################## Shell Variables and Settings
    # profile start time
    t0=$(date "+%s.%n")

    # use root defaults (they match web server defaults)
    umask 022   #            !! possible security issue !!

    # Remove all aliases from random unexpected places
    unalias -a

    # standard script modules for macOS
    . ~/bin/ssm

#? ######################## Config
    export SET_DEBUG=${SET_DEBUG:-0}  # set to 1 for verbose testing
    [[ ${SHELL##*/} = 'zsh' ]] && BASH_SOURCE=${(%):-%N} || "${BASH_SOURCE:-$0}"
    export BASH_SOURCE

    # Warn on global variable creation
    # setopt WARN_CREATE_GLOBAL
    set -a
    # set -x

    ZDOTDIR=$HOME/.dotfiles
#? ######################## MANPATH
    declare -x MANPATH=" \
        /usr/local/opt/coreutils/libexec/gnuman:\
        /usr/share/man:\
        /usr/local/share/man:\
        /usr/local/opt/erlang/lib/erlang/man:\
        /Library/Frameworks/Python.framework/Versions/3.8/share/man/man1:\
        "
    MANPATH="${MANPATH// /}"

#? ######################## PATH
    # /usr/local/Cellar/python@3.8/3.8.5/Frameworks/Python.framework/Versions/3.8/bin/:\

    declare -x PATH="\
        /usr/local/Cellar/gnupg/2.2.21/bin/:\
        /usr/local/opt/coreutils/libexec/gnubin:\
        $HOME/bin:\
        /usr/local/bin:\
        /usr/local/opt:\
        $HOME/.poetry/bin:\
        $HOME/Library/Python/3.8/bin:\
        /usr/local/lib/node_modules/bin:\
        /usr/local/Cellar/ruby/2.7.1_2/bin:\
        /usr/local/opt/cython/bin:\
        /bin:\
        /usr/local:\
        /usr/local/sbin:\
        /usr/bin:\
        /usr/sbin:\
        /sbin:\
        /usr/libexec:\
        /usr/local/opt/sphinx-doc/bin:\
        $HOME/.dotfiles:\
        $HOME/.dotfiles/git-achievements:\
        $PWD:\
        "

    # PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin:"
    PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:"

    PATH="${PATH// /}" # remove spaces
    PATH="${PATH//::/:}" # remove double colons ... you know you've done it, too

    export PATH

#? ######################## Utilities
    .() { # source with debugging info and file read check
        if [[ -r $1 ]]; then
            source "$1"
            [[ $SET_DEBUG = 1 ]] && blue "SUCCESS: << source $1 >>"
        else
            attn "ERROR: << source >> command => cannot locate $1"
        fi
        }

    source_dir() { # 'source' all files in directory
        if [[ -d $1 ]]; then
            local f
            [[ $SET_DEBUG = 1 ]] && blue "Source Directory $1"
            for f in "$1"/*; do
                . "$f"
            done
            unset f
        else
            attn "Source Directory error for $1"
        fi
    }

#? ######################## Load Profile settings
    source_dir "$DOTFILES_INC"

#? ######################## script cleanup
    # profile end time
    t1=$(date "+%s.%n")
    # display script time
    printf "${ATTN:-}Profile took ${WARN:-}%.1f${ATTN:-} second(s) to load.\n" $((t1-t0))
    printf "${MAIN:-}CPU: ${LIME:-}${CPU} ${MAIN:-}-> ${CANARY:-}${number_of_cores}${MAIN:-} cores. \n"
    printf "${MAIN:-}LOCAL IP: ${COOL:-}${LOCAL_IP}  ${MAIN:-}SHLVL: ${WARN:-}${SHLVL}  ${MAIN:-}LANG: ${RAIN:-}${LANG}${RESET:-}\n"
    unset t1 t0

 #? ######################## End of .zshrc
