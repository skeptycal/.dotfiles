#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034

  # number of years the first commercial
  #   modem would take to transmit a movie: 42.251651342415241
  #   this is very nearly the time since I wrote my first program
  #   I'm glad I didn't watch that movie instead ...

#? -----------------------------> Shell Variables and Settings
    # Remove all aliases from random unexpected places
    unalias -a
    alias reload="exec \${SHELL} -l"

    set -a          # export all
    # set -v        # verbose
    # set -x        # show all commands

    # By default, zsh does not do word splitting for unquoted parameter
        # expansions. You can enable "normal" word splitting by setting the
        # SH_WORD_SPLIT option or by using the = flag on an individual expansion.
        # e.g. ls ${=args}

	if [[ ${SHELL##*/} == 'zsh' ]]; then
    	# setopt interactivecomments
        # setopt SH_WORD_SPLIT # 'BASH style' word splitting
        declare -x BASH_SOURCE=${(%):-%N}
    else
        declare -x BASH_SOURCE=${BASH_SOURCE:=$0}
    fi

    loggedInUserID=$( scutil <<< "show State:/Users/ConsoleUser"  | awk '/UID : / && ! /loginwindow/ { print $3 }' )

    loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

    HostName=$( scutil --get LocalHostName )

    stuff=$( )

    export BREW_PREFIX=/usr/local # $(brew --prefix) # is slow...
    export ZDOTDIR=$HOME/.dotfiles

    # use root defaults (they match most web server defaults)
    umask 022   #          !! possible security issue !!

#? -----------------------------> environment config
    declare -ix SET_DEBUG=0 # ${SET_DEBUG:-0}  # set to 1 for verbose testing

    # automatic and manual source directories
    DOTFILES_PATH="$HOME/.dotfiles"
    DOTFILES_INC="${DOTFILES_PATH}/zshrc_inc"
    DOTFILES_INC_MANUAL="${DOTFILES_PATH}/zshrc_inc_manual"

    # export BREW_PREFIX=$(brew --prefix) #! this takes a LONG time

    # setup PATH early
    source "${DOTFILES_INC_MANUAL}/ansi_colors.sh"
    source "${DOTFILES_INC_MANUAL}/zsh_set_path"

    # personal 'standard script modules' for macOS
    source "$HOME/bin/ssm"

#? -----------------------------> script timers
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
#? -----------------------------> logging
    # Set to an integer to add logging
    declare -ix SET_LOGGER=0

    if (( SET_LOGGER )); then
        # TODO - case SET_LOGGER ...

        # Path to log file e.g. ~/.bootlog_xxxxxxx.log
        if [[ -z $BOOT_LOG ]]; then
            LOG_PATH_PREFIX="$HOME/.bootlog_"
            LOG_PATH_SUFFIX='.log'
            BOOT_LOG="${LOG_PATH_TEMPLATE}$(ms)${LOG_PATH_SUFFIX}"
        fi
    fi
#? -----------------------------> script cleanup
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

#? -----------------------------> utilities
    .() { # source with debugging info and file read check
        local f
        f="$1"
        if [[ -r "$f" ]]; then
            # echo " 'source : $f"
            source "$f"
            (( $? )) && attn "ERROR: cannot source ${f##*/}" || blue "SUCCESS: source ${f##*/}"
            # (( SET_DEBUG > 0 )) && blue "SUCCESS: source ${f##*/}"
        fi
        }

    source_dir() { # 'source' all files in directory
        local f
        for f in $(find "$@" -type f -print; ); do
            if [[ -f "$f" ]]; then
                . "$f" || attn "ERROR: failed to source ${f##*/}"
                # (( SET_DEBUG > 0 )) && blue "SUCCESS: Directory ${f##*/}"
            fi
        done;
        unset f
        }
#? -----------------------------> timer in CLI prompt
    function preexec() { timer=$(ms); }
    function precmd() {
        if [ $timer ]; then
            elapsed=$(($(ms)-$timer))

            export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
            unset timer
        fi
        }

#? -----------------------------> load profile settings
    source_dir "$DOTFILES_INC"


    # if type brew &>/dev/null; then
    #     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    #     autoload -Uz compinit
    #     compinit
    # fi

    # . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    #   test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#? -----------------------------> oh-my-zsh config
	# Path to your oh-my-zsh installation.
    # oh-my-zsh config
    export ZSH=$HOME/.dotfiles/.oh-my-zsh

	# golang /Users/michaeltreanor/.dotfiles/ohmyzsh/plugins/golang/README.md
    plugins=( git copyfile cp django golang gpg-agent poetry colored-man-pages )

    unsetopt SH_WORD_SPLIT # 'BASH style' word splitting OFF

    # Using ZSH shell - http://zsh.sourceforge.net/

    # HISTORY options are set in zshrc_exports 'history' section
    setopt no_case_glob auto_cd correct correct_all



    setopt   notify globdots  pushdtohome cdablevars autolist
    setopt    recexact longlistjobs
    setopt   autoresume pushdsilent noclobber
    setopt   autopushd pushdminus extendedglob rcquotes mailwarning
    unsetopt autoparamslash bgnice


    # allexport
    # alwaystoend
    # autocd
    # noautoparamslash
    # autopushd
    # autoresume
    # nobgnice
    # nocaseglob
    # cdablevars
    # noclobber
    # combiningchars
    # completeinword
    # correct
    # correctall
    # extendedglob
    # extendedhistory
    # noflowcontrol
    # globdots
    # histexpiredupsfirst
    # histignoredups
    # histignorespace
    # histverify
    # interactive
    # interactivecomments
    # login
    # longlistjobs
    # mailwarning
    # monitor
    # promptsubst
    # pushdignoredups
    # pushdminus
    # pushdsilent
    # pushdtohome
    # rcquotes
    # recexact
    # sharehistory
    # shinstdin
    # shwordsplit
    # zle

    # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -a zsh/mapfile mapfile

    ZSH_THEME="spaceship"
	# ZSH_THEME="robbyrussell"
	CASE_SENSITIVE="false"
	COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"

    zstyle ':completion:*' menu select
    fpath+="$HOME/.zfunc"

	autoload -Uz compinit && compinit

    . $ZSH/plugins/git/git.plugin.zsh

    . $ZSH/oh-my-zsh.sh

    setopt SH_WORD_SPLIT # 'BASH style' word splitting ON

    alias ls='ls $colorflag'

#! -----------------------------> Install issues on macOS Big Sur
    # Reference: https://github.com/pyenv/pyenv/issues/1219

    BPO="${BREW_PREFIX}/opt/"
    export LDFLAGS="-L${BPO}readline/lib -L${BPO}openssl/lib -L${BPO}zlib/lib"
    export CFLAGS="-I${BPO}readline/include -I${BPO}openssl/include -I${BPO}zlib/include -I$(xcrun --show-sdk-path)/usr/include"
    export CPPFLAGS=${CFLAGS}
    export PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs2"

#? zsh notes

# ALL_EXPORT (-a, ksh: -a)
# All parameters subsequently defined are automatically exported.
# GLOBAL_EXPORT (<Z>)
# If this option is set, passing the -x flag to the builtins declare, float,
# integer, readonly and typeset (but not local) will also set the -g flag; hence
# parameters exported to the environment will not be made local to the enclosing
# function, unless they were already or the flag +g is given explicitly. If the
# option is unset, exported parameters will be made local in just the same way
# as any other parameter. This option is set by default for backward
# compatibility; it is not recommended that its behaviour be relied upon. Note
# that the builtin export always sets both the -x and -g flags, and hence its
# effect extends beyond the scope of the enclosing function; this is the most
# portable way to achieve this behaviour.

# default shell to handle /bin/sh shebangs reference:
# https://scriptingosx.com/2019/06/moving-to-zsh/
# As Apple’s support article mentions, Catalina also adds a new mechanism for
# users and admins to change which shell handles sh invocations. MacAdmins or
# users can change the symbolic link stored in /var/select/sh to point to a
# shell other than /bin/bash. This changes which shell interprets scripts the
# #!/bin/sh shebang or scripts invoked with sh -c. Changing the interpreter for
# sh should not, but may change the behavior of several crucial scripts in the
# system, management tools, and in installers, but may be very useful for
# testing purposes.

#? -----------------------------> END OF .ZSHRC
