#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034

#? ######################## .functions - functions for macOS with zsh
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc

	#* copyright (c) 2019 Michael Treanor
	#* MIT License - https://www.github.com/skeptycal

set -a

set_basic_colors() {
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
}

# ssm (standard script modules) is my main shell utilities setup
# this will either load that OR setup basic colors as needed

color_sample() {
    echo "${MAIN:-}MAIN  ${WARN:-}WARN  ${COOL:-}COOL  ${LIME:-}LIME  ${GO:-}GO  ${CHERRY:-}CHERRY  ${CANARY:-}CANARY  ${ATTN:-}ATTN  ${RAIN:-}RAIN  ${WHITE:-}WHITE  ${RESET:-}RESET"
	}

. $(which ssm) || set_basic_colors
(( SET_DEBUG == 1 )) && color_sample

unset set_basic_colors
