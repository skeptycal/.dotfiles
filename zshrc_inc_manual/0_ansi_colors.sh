#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################
	set -a
	SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			color_sample
		fi
		}
#? ###################### copyright (c) 2019 Michael Treanor #################
	if [[ -z $MAIN ]]; then
		color_sample() {
			echo "${MAIN:-}C  ${WARN:-}O  ${COOL:-}L  ${LIME:-}O  ${GO:-}R  ${CHERRY:-}S  ${CANARY:-}A  ${ATTN:-}M  ${RAIN:-}P  ${WHITE:-}L  ${RESET:-}E"
			ce "${MAIN:-}MAIN  ${WARN:-}WARN  ${COOL:-}COOL  ${LIME:-}LIME  ${GO:-}GO  ${CHERRY:-}CHERRY  ${CANARY:-}CANARY  ${ATTN:-}ATTN  ${RAIN:-}RAIN  ${WHITE:-}WHITE  ${RESET:-}RESET";
			}
		set_color_functions() {
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
			}

		set_basic_colors
		set_color_functions
		_debug_tests
		unset set_basic_colors set_color_functions _debug_tests
	fi
