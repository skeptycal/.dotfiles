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
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green "_login_message(): "
			_login_message
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

	_login_message() { cat <<- EOF
		${CHERRY:-}
		================================================================== ${MAIN:-}
		os: ${LIME:-}$(/opt/homebrew/bin/guname -i) | $(sw_vers -productName) | $(sw_vers -productVersion)${MAIN:-}
		shell: ${ATTN:-}$(zsh --version | cut -d '(' -f 1)${MAIN:-}
		go: ${GOLANG:-}$(go version | cut -d ' ' -f 3 | cut -d 'o' -f 2)${MAIN:-}
		python: ${CANARY:-}$(python -V)${MAIN:-}

		CPU: ${LIME:-}${CPU} ${MAIN:-}-> ${CANARY:-}${number_of_cores}${MAIN:-} cores.${MAIN:-}
		LOCAL IP: ${COOL:-}${LOCAL_IP}  ${MAIN:-}SHLVL: ${WARN:-}${SHLVL}  ${MAIN:-}LANG: ${RAIN:-}${LANG}${CHERRY:-}
		==================================================================
		${CANARY}
		Selected recently added utilities:${RESET}${ITALIC}${DIM}
			# Reminders to try out the latest features ...${RESET}
			${LIME}
			recent              - see *more* utility additions / changes.${DARKGREEN}
			preman              - open man pages nicely formatted in Preview
			zsh_stats           - (from oh-my-zsh) list cli stats
			pipup               - update all global dependencies
			rebrew 				- update all brew modules
			mp 					- multipass${CHERRY:-}
		================================================================== ${RESET}
		EOF
		}

	_debug_tests
	true