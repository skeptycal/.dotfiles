#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> .zshrc - main config for macOS with zsh
    #* Copyright (c) 2019 Michael Treanor
    #* MIT License
    #* https://www.github.com/skeptycal

    #* number of years the first commercial
    #*   modem would take to transmit a movie: 42.251651342415241
    #*   this is very nearly the time since I wrote my first program
    #*   I'm glad I didn't watch that movie instead ...

#? -----------------------------> parameter expansion tips
    #? ${PATH//:/\\n}    - replace all colons with newlines
    #? ${PATH// /}       - strip all spaces
    #? ${VAR##*/}        - return only final element in path (program name)
    #? ${VAR%/*}         - return only path (without program name)
#? -----------------------------> Shell Settings
    # Remove all aliases from unexpected places
    unalias -a

    # use root defaults (they match most web server defaults)
    umask 022   #          !! possible security issue !!

    export LANG=en_US.UTF-8

#? -----------------------------> ZSH compatibility
    # critical path environment variables
    # Path to oh-my-zsh configuration.
    export ZSH=~/.oh-my-zsh

    # Path to ZSH dotfiles directory
    export ZDOTDIR=~/.dotfiles

    # Older dotfiles path directory (for compatibility)
    # export DOTFILES_PATH=$ZDOTDIR

    # Path to include files
    export DOTFILES_INC=${ZDOTDIR}/zshrc_inc

#? -----------------------------> BASH compatibility
    # By default, zsh does not do word splitting for
        # unquoted parameter expansions. You can enable
        # "normal" word splitting by setting the
        # SH_WORD_SPLIT option or by using the = flag on an individual expansion.
        # e.g. ls ${=args}

	if [[ ${SHELL##*/} == 'zsh' ]]; then
    	setopt interactivecomments

        # 'SH style' word splitting
        setopt SH_WORD_SPLIT

        # Emulate some form of compatibility
        BASH_SOURCE="${(%):-%N}"
    fi
    BASH_SOURCE="${BASH_SOURCE:=$0}"

#? -----------------------------> Homebrew Path
    # HomeBrew path prefix (manually set - auto is slow)
    # BREW_PREFIX=/opt/homebrew
    # BREW_PREFIX=${BREW_PREFIX:=$(brew --prefix &>/dev/null)} # try this first ... slow
    BREW_PREFIX=${BREW_PREFIX:=/opt/homebrew} #backup ... brew --prefix is bugging out

    # GNU CoreUtils Path
    GNUBIN_PREFIX=$BREW_PREFIX/opt/coreutils/libexec/gnubin

#? -----------------------------> PATH utilities

    .() { # source with debugging info and file read check
        # echo " (source $1)"
        source "$1" || warn "cannot source '$1'"
        }

    # source_dir sources all .zsh files in \$1 directory
    # relative to $DOTFILES_INC for safety
    source_dir() {
        for f in $(find "${1:-"$PWD"}" -type f -print;); do
            # recursive ...
            [[ -d "$f" ]] && source_dir "$f" || . ${f}
        done
        }


    # one_or_pwd prints the value of $1.
    # If $1 is empty, it prints PWD
    one_or_pwd() {
        dirs=${1:-"$PWD"}
        echo $dirs
        }

    source_all_dirs() {

        # use PWD if $1 is empty ...
        # [[ -z "$1" ]] && warn "source_dir not found: '$1'"

        local dirs=$( one_or_pwd "$1"; )             # ${1:-"$PWD"}
        local dirs=$1
        # [[ -z $( ls -0 ${${DOTFILES_INC}/${1}:=$PWD}/* 2>/dev/null; ) ]] && return 1
        # for f in ${DOTFILES_INC}/${dirs} ; do
        for f in $(find "$dirs" -type f -print; ); do
            [[ -d $f ]] && echo $(source_dir "${f##*/}\n");
        done
        }


    # set up system $PATH (and $MANPATH)
    # . ~/.dotfiles/zshrc_inc/default/zsh_set_path.zsh
    . $DOTFILES_INC/zsh_set_path.zsh

#? -----------------------------> ansi utilities
    # ANSI colors and cli functions
    . /Users/skeptycal/.dotfiles/zshrc_inc/ansi_colors.sh
    # . ${DOTFILES_INC}/ansi_colors.sh

    # _fake_table contains examples of formatting options ...
    # https://linuxconfig.org/bash-printf-syntax-basics-with-examples
    _fake_table() {
        local _color=$ORANGE
        local _headercolor=$ORANGE
        local _reset=$RESET
        local divider="${_headercolor:-}=============================================================${_reset}"
        local header="\n${_color:-} %-10s %8s %10s %11s${_reset}\n"
        local format="${_color:-} %-10s %08d %10s %11.2f${_reset}\n"
        local width=55

        printf "$header" "ITEM NAME" "ITEM ID" "COLOR" "PRICE"

        printf "%.${width}s\n" "$divider"

        printf "$format" \
        Triangle 13  red 20 \
        Oval 204449 "dark blue" 65.656 \
        Square 3145 orange .7
        echo ""
    }

#? -----------------------------> debug (Dev / Production modes)
    # SET_DEBUG is set to zero for production mode
    # SET_DEBUG is set to non-zero for dev mode
    #   1 - Show debug info and log to $LOGFILE
    #   2 - #1 plus trace and run specific testsds
    #   3 - #2 plus display and log everything

    declare -ix SET_DEBUG=0 # ${SET_DEBUG:-0}

    dbecho "SET_DEBUG: $SET_DEBUG" #! debug
    if (( SET_DEBUG>0 )); then
        printf '%b\n' "${WARN:-}Debug Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "DEV mode ($SET_DEBUG) activated"
        trap 'echo "# $(realpath $0) (line $LINENO) Error Trapped: $?"' ERR
        trap 'echo "# $0: Exit with code: $?"' EXIT
    fi
    if (( SET_DEBUG>1 )); then
        printf '%b\n' "${WARN:-}Debug Test Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TEST mode ($SET_DEBUG) activated"
        setopt SOURCE_TRACE
        trap 'echo "# $0: Line Number: $LINENO"' DEBUG
    fi
    if (( SET_DEBUG>2 )); then
        printf '%b\n' "${WARN:-}Debug Trace Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TRACE mode ($SET_DEBUG) activated"
        setopt XTRACE # VERBOSE
    fi

    function noyes() {
        read "a?$1 [y/N] "
        if [[ $a == "N" || $a == "n" || $a = "" ]]; then
            return 0
        fi
        return 1
        }

    function breather() {
        local stuff
        read "stuff?${1:-'Continue? '} [Enter] "
        return 0
        }

#? -----------------------------> gpg install
    # recommendations from 'brew install gpg2'
    # ${PKG_CONFIG_PATH:-}
    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}:/usr/local/opt/libffi/lib/pkgconfig"
    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}:/usr/local/opt/readline/lib/pkgconfig"
    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}:/usr/local/opt/openssl@1.1/lib/pkgconfig"

    # guile
    # export GUILE_LOAD_PATH="${GUILE_LOAD_PATH:-}:/usr/local/share/guile/site/3.0"
    # export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH:-}:/usr/local/lib/guile/3.0/site-ccache"
    # export GUILE_SYSTEM_EXTENSIONS_PATH="${GUILE_SYSTEM_EXTENSIONS_PATH:-}:/usr/local/lib/guile/3.0/extensions"
    # export GUILE_TLS_CERTIFICATE_DIRECTORY=/usr/local/etc/gnutls/

    # ==> openssl@1.1
    # A CA file has been bootstrapped using certificates from the system
    # keychain. To add additional certificates, place .pem files in
    #   /usr/local/etc/openssl@1.1/certs

#? -----------------------------> user and paths
    # UserID of currently logged in user
    loggedInUserID="$( scutil <<< "show State:/Users/ConsoleUser"  | awk '/UID : / && ! /loginwindow/ { print $3 }' )"

    # Username of currently logged in user
    loggedInUser="$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"

    # Current Hostname
    HostName="$( scutil --get LocalHostName )"

    # Path to template files
    DOTFILES_TEMPLATE="${ZDOTDIR}/template"

    # Path to template files that should be linked
    DOTFILES_TEMPLATE_LN=${DOTFILES_TEMPLATE}/ln

    # Path to template files that should be copied
    DOTFILES_TEMPLATE_CP=${DOTFILES_TEMPLATE}/cp

	autoload -Uz compinit && compinit

#? -----------------------------> load profile settings

    source_dir $DOTFILES_INC/_first
    source_dir $DOTFILES_INC/.secret
    # source_dir $DOTFILES_INC/default
    source_dir $DOTFILES_INC/aliases
    source_dir $DOTFILES_INC/options
    source_dir $DOTFILES_INC/functions
    source_dir $DOTFILES_INC/repo
    source_dir $DOTFILES_INC/other

#? -----------------------------> load OMZ!
    # OMZ config
    DISABLE_AUTO_TITLE="true"
	CASE_SENSITIVE="false"
	COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    ENABLE_CORRECTION="true"
    DISABLE_MAGIC_FUNCTIONS="true"
    # ZSH_THEME="spaceship"
	ZSH_THEME="robbyrussell"

    . "$ZSH/oh-my-zsh.sh"

#? -----------------------------> odds and ends
    # These seem to get lost somewhere ...

    # Helper to lookup commands from the zsh git plugin cheatsheet
    # function gx () {
    #     `fzf < ~/.dotfiles/zsh-git-plugin-cheatsheet.txt | cut -f3 -d'|' | tr _ ' '`
    # }

    # . "${DOTFILES_INC}/zsh_big_sur_hacks.zsh"
    # . "${DOTFILES_INC}/gomake_main.sh"

#? -----------------------------> script cleanup
    # cleanup and exit script
    echo ''

    # calculate and display script time
    printf "${GREEN:-}Script ${SCRIPT_NAME} took ${BOLD:-}${ATTN:-}$(lap_ms)${RESET:-}${GREEN:-} ms to load.${RESET:-}\n\n"

#? -----------------------------> zsh notes
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

#? -----------------------------> old sources

    # tokens and password functions
    # . "${DOTFILES_INC}/.tokens_private.sh"

    # setup shell logging
    # todo - wip ... still some work to do ...
    # . "${DOTFILES_INC}/zsh_logging.zsh"

    # zsh gpg setup
    # . "${DOTFILES_INC}/zshrc_gpg.zsh"

    # git functions and options
    # . "${DOTFILES_INC}/func_git.zsh"

    # zsh shell aliases
    # . "${DOTFILES_INC}/a_directories.zsh"
    # . "${DOTFILES_INC}/a_init.zsh"
    # . "${DOTFILES_INC}/a_network.zsh"

    # zsh environment variable exports
    # . "${DOTFILES_INC}/zshrc_exports.zsh"

    # zsh functions and options
    # . "${DOTFILES_INC}/func_sys.zsh"
    # . "${DOTFILES_INC}/func_tasks.zsh"

    # python settings and utilities
    # . "${DOTFILES_INC}/zshrc_python.zsh"

    # set zsh and OMZ options
    # . "${DOTFILES_INC}/zsh_options.zsh"
    # . "${DOTFILES_INC}/omz_plugins.zsh"
    # . "${DOTFILES_INC}/zsh_modules.zsh"

#? -----------------------------> END OF .ZSHRC
