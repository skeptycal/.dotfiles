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
    # Remove all aliases from random unexpected places
    unalias -a

    # By default, zsh does not do word splitting for unquoted parameter
        # expansions. You can enable "normal" word splitting by setting the
        # SH_WORD_SPLIT option or by using the = flag on an individual expansion.
        # e.g. ls ${=args}

    setopt SH_WORD_SPLIT

    # Warn on global variable creation
    # setopt WARN_CREATE_GLOBAL

    set -a # export all
    # set -v # verbose
    # set -x # show all commands

    declare -ix SET_DEBUG=0 # ${SET_DEBUG:-0}  # set to 1 for verbose testing

    # setup PATH early
    . ~/.dotfiles/zshrc_inc_manual/zsh_set_path

    # personal 'standard script modules' for macOS
    . $(which ssm)

    # millisecond timer at this instant
    ms() { echo $(( $(gdate +%s%0N)/1000000 )) }

    # log to ~/.bootlog_xxxxxxx
    [[ -z $BOOT_LOG ]] && BOOT_LOG="$HOME/.bootlog_$(ms).log"

    # use root defaults (they match most web server defaults)
    umask 022   #          !! possible security issue !!

#? ######################## script timers
    ms() { echo $(( $(gdate +%s%0N)/1000000 )) }
    lap() {
        # report nanoseconds (ns) passed since last 'lap_n' call
        t1=$(gdate +%s%0N)
        dt=$(( t1-t0 ))
        t0=$(gdate +%s%0N)
        echo $dt
        }
    lap_ms() { echo (( $(lap)/1000000 )); } # report milliseconds (ms) passed since last 'lap' call
    lap_sec() { echo (( $(lap)/1000000000 )); } # report seconds (s) passed since last 'lap' call
#? ######################## script cleanup
    script_exit_cleanup() {
        # cleanup and exit script

        # calculate and display script time
		# sleep 1 # timer test for ~ 1 second (1000 ms)
        dt=$(lap_ms)
        printf '\n%b %d %b\n\n' "${GREEN:-}Script ${SCRIPT_NAME} took" ${dt} "ms to load.${RESET:-}"
        printf "${ATTN:-}Profile took ${WARN:-}%d${ATTN:-} ms to load.\n" $dt
        unset t0 t1 dt

        printf "${MAIN:-}CPU: ${LIME:-}${CPU} ${MAIN:-}-> ${CANARY:-}${number_of_cores}${MAIN:-} cores. \n"
        printf "${MAIN:-}LOCAL IP: ${COOL:-}${LOCAL_IP}  ${MAIN:-}SHLVL: ${WARN:-}${SHLVL}  ${MAIN:-}LANG: ${RAIN:-}${LANG}${RESET:-}\n"
        }
    trap script_exit_cleanup EXIT
#? ######################## config
    [[ ${SHELL##*/} = 'zsh' ]] && BASH_SOURCE=${(%):-%N} || "${BASH_SOURCE:-$0}"

    export BASH_SOURCE
    # export BREW_PREFIX=$(brew --prefix) #! this takes a LONG time

    export ZDOTDIR=$HOME/.dotfiles
#? ######################## utilities
    .() { # source with debugging info and file read check
        if [[ -r $1 ]]; then
            source "$1"
            (( SET_DEBUG > 0 )) && blue "SUCCESS: source ${1##*/}"
        else
            attn "ERROR: cannot source ${1##*/}"
        fi
        }

    source_dir() { # 'source' all files in directory
        local f
        if [[ -d $1 ]]; then
            for f in "$@"/*; do
                . "$f"
            done
            (( SET_DEBUG > 0 )) && blue "SUCCESS: Directory ${1##*/}"
        else
            attn "ERROR: cannot source ${1##*/}"
        fi
        unset f
        }
#? ######################## timer in CLI prompt
    function preexec() { timer=$(ms); }
    function precmd() {
        if [ $timer ]; then
            elapsed=$(($(ms)-$timer))

            export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
            unset timer
        fi
        }

#? ######################## load profile settings
    source_dir "$DOTFILES_INC"

    # if type brew &>/dev/null; then
    #     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    #     autoload -Uz compinit
    #     compinit
    # fi

    # . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#! ######################## Install issues on macOS Big Sur
    # Reference: https://github.com/pyenv/pyenv/issues/1219

    export LDFLAGS="-L$(brew --prefix readline)/readline/lib -L$(brew --prefix openssl)/openssl/lib -L$(brew --prefix zlib)/zlib/lib"
    export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix zlib)/include -I$(brew --prefix openssl)/openssl/include -I$(xcrun --show-sdk-path)/usr/include"
    export CPPFLAGS=${CFLAGS}
    export PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs2"
    # pyenv install -v 3.6.0

 #? ######################## End of .zshrc
