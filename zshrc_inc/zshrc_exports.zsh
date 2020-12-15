#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#?-----------------------------> .zshrc Exports
    #*	    Colors ... shortcuts ... the pathway to an easier life ...
    #*      tested on macOS Big Sur and zsh 5.8
    #*	    copyright (c) 2019 Michael Treanor
    #*	    MIT License - https://www.github.com/skeptycal
#?-----------------------------> .zshrc debug info
	export SET_DEBUG=${SET_DEBUG:-0}  		# set to 1 for verbose testing

	SCRIPT_NAME=${0##*/}

	# compatibility with many 'bash' scripts
	if [[ ${SHELL##*/} == 'zsh' ]]; then
        set -o shwordsplit 	# 'BASH style' word splitting
        BASH_SOURCE=${(%):-%N}
    else
        BASH_SOURCE=${BASH_SOURCE:=$0}
    fi

	_debug_tests() {
        printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        green "\$LANG is set to $LANG."
        green "\$LOCAL_IP is set to and exported as $LOCAL_IP."
        }
    (( SET_DEBUG > 0 )) && _debug_tests "$@"

#? -----------------------------> copyright (c) 2019 Michael Treanor
#? ----------------------------->## zsh history
    # HISTORY options reference:
    # https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/

        setopt extendedhistory
        setopt histexpiredupsfirst
        setopt histfindnodups
        setopt histignoredups
        setopt histignorespace
        setopt histreduceblanks
        setopt histverify
        setopt sharehistory

    export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
    export HISTSIZE=524288 # 32768
    export HISTFILESIZE="${HISTSIZE}"
    export HISTCONTROL='ignoreboth'
    export SAVEHIST=32768

#? ----------------------------->## Shell settings
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # default shell editor for standard and ssh sessions
    [[ -n $SSH_CONNECTION ]] && export EDITOR='nano' || export EDITOR='nano'

    export SH_KEY_PATH="${HOME}/.ssh/rsa_id"

	export CLASH_PATH=/Users/skeptycal/local_coding/user_bin_dir_repo
    export LOCAL_IP="$(ipconfig getifaddr en0)"
    export LANG="en_US.UTF-8"
    export ARCHFLAGS="-arch x86_64"
    export CPU_STRING=$(sysctl -n machdep.cpu.brand_string)
    export number_of_cores=$(sysctl -n hw.ncpu)
	export MEMORY_CAP=$(system_profiler SPHardwareDataType | grep "  Memory:" | cut -d ':' -f 2)

    # support colors in less
    export LESS_TERMCAP_mb && LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md && LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me && LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se && LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so && LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue && LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us && LESS_TERMCAP_us=$'\E[01;32m'

#? ----------------------------->## Go
    export GOPATH="$HOME/go"

#? ----------------------------->## Program settings

    #   export TESSDATA_PREFIX="${HOME}/Documents/GitHub/tesseract/tessdata"

    #   export AZURE_WORKING_DIR="${HOME}/myagent"
    #   start Azure
    #   cd $AZURE_WORKING_DIR
    #   ./svc.sh start
    #   cd -

    #   export MAGICK_HOME="/usr/local/Cellar/imagemagick/7.0.8-68"

    # export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

    # export RUBY_CONFIGURE_OPTS && RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
    # eval "$(rbenv init -)"

    # brew install jump
    # https://github.com/gsamokovarov/jump
    #   eval "$(jump shell)"

#? ----------------------------->## Google Cloud SDK
    #   google cloud SDK
    #   The next line updates PATH for the Google Cloud SDK.
    # [ -f '/Users/skeptycal/google-cloud-sdk/path.zsh.inc' ] && . '/Users/skeptycal/google-cloud-sdk/path.zsh.inc'

    #   The next line enables shell command completion for gcloud.
    # [ -f '/Users/skeptycal/google-cloud-sdk/completion.zsh.inc' ] && . '/Users/skeptycal/google-cloud-sdk/completion.zsh.inc'

#? ----------------------------->## emsdk
    # Emscripten is a toolchain for compiling to asm.js and WebAssembly, built using LLVM,
    #   that lets you run C and C++ on the web at near-native speed without plugins.
    #   https://emscripten.org/
    #   export EMSDK
    #   EMSDK="/Users/skeptycal/emsdk"
    #   export EM_CONFIG
    #   EM_CONFIG="/Users/skeptycal/.emscripten"
    #   export EMSDK_NODE
    #   EMSDK_NODE="/Users/skeptycal/emsdk/node/12.9.1_64bit/bin/node"

#? ----------------------------->## Java
    # export JAVA_HOME
    # JAVA_HOME="$(/usr/libexec/java_home)"
    # export M2_HOME
    # M2_HOME="/usr/share/apache-maven-3.6.0"

#? ----------------------------->## Node
    export NODE_REPL_HISTORY="${HOME}/.node_history"
    export NODE_REPL_HISTORY_SIZE=32768
    export NODE_REPL_MODE='sloppy'

#? ----------------------------->## Perl
    #   export PERL_MM_OPT && PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
    #   eval "$(perl -I"$HOME"/perl5/lib/perl5 -Mlocal::lib="$HOME"/perl5)"

#? ----------------------------->## Postgres setup
    #   export DATABASE_URL="postgres://$(whoami)"

#? ----------------------------->## Ruby setup
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
true
