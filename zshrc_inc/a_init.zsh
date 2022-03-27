#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################
	SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green $(which mine)
		fi
		}
#? ###################### copyright (c) 2019 Michael Treanor #################

#? ############################# initial aliases

    # alias code="nocorrect code"
    alias mv='nocorrect mv'       # no spelling correction on mv
    alias cp='nocorrect cp'       # no spelling correction on cp
    alias mkdir='nocorrect mkdir' # no spelling correction on mkdir

    # Use NeoVim if available
    type "nvim" >/dev/null && alias vim='nvim '
    # alias git="git-achievements "
    alias mine="sudo chown -R \$(id -un):\$(id -gn) "

# TODO ########################################## works in progress
    # alias lsln='ls -AF | grep '@' | cut -d '@' -f 1 ' # will include
    # directories

	# charmap() { "$(perl -wE "print map chr, ${1:-0} .. ${2:-255}")" | xxd }
	# echo -n "$var" | xxd

	# ref: https://unix.stackexchange.com/a/417794/
	alias abs='cat -Abs '
    # ref: https://scriptingosx.com/2017/04/on-viewing-man-pages/
    preman() { man -t "$@" | open -f -a "Preview" ;}
    # alias c='code .'

#? ############################# handy stuff
    alias cls='clear'   # because 40 year old habits die hard
    alias dir='ls'      # and I'm stubborn
    alias del='rm -rf'   #! delete all the things now! (!CAREFUL!)
    alias pwdcopy='pwd | pbcopy'
    alias reload="exec \${SHELL} -l"

	#* Python 3.10 framework installation

	#* Run this to set the appropriate variables. This is a combination of the answers that have already been given here. Put it in your ~/.bash_profile to make it permanent.
	#* Reference: https://newbedev.com/how-to-make-python-use-ca-certificates-from-mac-os-truststore
	CERT_PATH=$(python -m certifi)
	export SSL_CERT_FILE=${CERT_PATH}
	export REQUESTS_CA_BUNDLE=${CERT_PATH}

	#* If you put the additional certificates in a PEM bundle file you can use these two environment variables to overwrite the default cert stores used by Python openssl and requests.
	# SSL_CERT_FILE=/System/Library/OpenSSL/cert.pem
	# REQUESTS_CA_BUNDLE=/System/Library/OpenSSL/cert.pem

	# pip search is deprecated ... using alternate scripts from:
	# https://github.com/jeffmm/pypi-simple-search
	# alias pip="pip-pss"
	alias sba='source ./.venv/bin/activate'
	alias sda='source ./.venv/bin/deactivate'

	# list all installed packages (name only, no headers)
		# Several optional ways to accomplish this ...
		# alias piplist="pip list | tail -n +3 | cut -d ' ' -f 1"
		# alias piplist="pip list | sed 1,2d | awk '{print $1}'"
		# alias piplist="pip list | awk 'NR>2 {print $1}'"
	piplist() { pip list | awk 'NR>2 {print $1}'; }

	# update all installed packages
	# alias pipup="pip list | awk 'NR>2 {print $1}' | xargs pip install -U"
	pipup() { piplist | xargs pip install -U; }

	alias brewup='brew list |xargs brew upgrade 2>/dev/null'

    # alias blog="cd ~/Work/blog && code . || attn 'no blog folder found ...'"
    # alias auto="cd ~/Documents/coding/python/autosys && code . || attn 'no autosys folder found ...'"

    alias nis="npm install --save "
    # alias cgr="composer global require"

    alias ssh='ssh -R 10999:localhost:22'
    alias nethack='telnet nethack.alt.org'

_debug_tests
true
#? ############################# CLICOLOR Details
    #   exfxcxdxbxegedabagacad
    #
    #       ls Attribute	Foreground color	Background color
    #       directory	            e	            x
    #       symbolic	            f	            x
    #       socket	                c	            x
    #       pipe	                d	            x
    #       executable              b	            x
    #       block	                e	            g
    #       character	            e	            d
    #       executable	            a	            b
    #       directory	            a	            c
    #       directory	            a	            d
