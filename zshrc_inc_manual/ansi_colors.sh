#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################
	set -a # export all
	SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG > 0 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			color_sample
		fi
		}
#? ###################### copyright (c) 2019 Michael Treanor #################
	# if [[ -z $MAIN ]]; then
        # I use GNU core_utils; no need to test '-G'
        export CLICOLOR=1
        export colorflag='--color=always'

        # alias ls="ls \$colorflag "

        # terminal identification
        if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
            declare -x TERM='gnome-256color';
        elif infocmp xterm-256color >/dev/null 2>&1; then
            declare -x TERM='xterm-256color';
        fi;

		if [ -t 1 ]; then
			export MAIN="\001\033[38;5;229m"
			export WARN="\001\033[38;5;203m"
			export COOL="\001\033[38;5;38m"
			export BLUE="\001\033[38;5;38m"
			export GO="\001\033[38;5;28m"
			export LIME="\001\033[32;1m"
			export CHERRY="\001\033[38;5;124m"
			export CANARY="\001\033[38;5;226m"
			export ATTN="\001\033[38;5;178m"
			export PURPLE="\001\033[38;5;93m"
			export RAIN="\001\033[38;5;93m"
			export WHITE="\001\033[37m"
			export RESTORE="\001\033[0m\002"
			export RESET="\001\033[0m"
		else
			export MAIN=
			export WARN=
			export COOL=
			export BLUE=
			export GO=
			export LIME=
			export CHERRY=
			export CANARY=
			export ATTN=
			export PURPLE=
			export RAIN=
			export WHITE=
			export RESTORE=
			export RESET=
		fi
        # GIT colors
        declare -x WS="$(git config --get-color color.diff.whitespace "blue reverse")"
        declare -x RESET="$(git config --get-color "" "reset")"

        # Highlight the user name when logged in as root.
        if [[ "${USER}" == "root" ]]; then
            declare -x userStyle="\${red}"
        else
            declare -x userStyle="\${orange}"
        fi

		br() { printf "\n" ; } # yes, this is a fake <br />
		eprint() { printf "%b\n" "${*:-}" ; }
		ce() { printf "%b\n" "${*:-}${RESET:-}" ; }
		me() { ce "${MAIN:-}${*:-}" ; }
		warn() { ce "${WARN:-}${*:-}" ; }
		blue() { ce "${COOL:-}${*:-}" ; }
		cool() { ce "${COOL:-}${*:-}" ; }
		green() { ce "${GO:-}${*:-}" ; }
		lime() { ce "${LIME:-}${*:-}" ; }
		cherry() { ce "${CHERRY:-}${*:-}" ; }
		canary() { ce "${CANARY:-}${*:-}" ; }
		attn() { ce "${ATTN:-}${*:-}" ; }
		purple() { ce "${PURPLE:-}${*:-}" ; }
		rain() { ce "${RAIN:-}${*:-}" ; }
		white() { ce "${WHITE:-}${*:-}" ; }
		
		dbecho() { (( SET_DEBUG==1 )) && echo "${ATTN:-}${@}${RESET:-}"; }
		die() { echo "${WARN:-}$@" && exit 1; }
		is_empty() { [ -z "$(ls -A $1)" ]; }
		exists() { command -v $1 > /dev/null 2>&1 ; }

		color_sample() {
			echo "${MAIN:-}C  ${WARN:-}O  ${COOL:-}L  ${LIME:-}O  ${GO:-}R  ${CHERRY:-}S  ${CANARY:-}A  ${ATTN:-}M  ${RAIN:-}P  ${WHITE:-}L  ${RESET:-}E"
			ce "${MAIN:-}MAIN  ${WARN:-}WARN  ${COOL:-}COOL  ${LIME:-}LIME  ${GO:-}GO  ${CHERRY:-}CHERRY  ${CANARY:-}CANARY  ${ATTN:-}ATTN  ${RAIN:-}RAIN  ${WHITE:-}WHITE  ${RESET:-}RESET";
			}

	# fi

_debug_tests
