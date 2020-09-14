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
	set -a
	_debug_tests() {
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			color_sample
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################
