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
			local INPUT="f^kd0@D_FJ\nic  df _ dw084&"
				green "cleanstring    $INPUT = $(cleanstring "$INPUT")"
				green "cleanerstring  $INPUT = $(cleanerstring "$INPUT")"
				green "containerclean $INPUT = $(containerclean "$INPUT")"
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

cleanstring() {
	# CLEANSTRING=${STRING//[^a-zA-Z0-9]/}
	echo ${1//[^a-zA-Z0-9]/}
}

cleanerstring() {
	# Sanitize $STRING but leave underscores
	CLEAN="${1//_/}" && \
	CLEAN="${CLEAN// /_}" && \
	CLEAN="${CLEAN//[^a-zA-Z0-9]/}" # && \
	# CLEAN="${CLEAN,,}"
	echo $CLEAN
}

containerclean() {
	# Sanitize $STRING for a container name
	CLEAN="${1//[^a-zA-Z0-9]/}" # && \
	#CLEAN="${CLEAN,,}"
	echo $CLEAN
}

# replaced with Go utility gitit
# gitit() {
# 	go mod tidy && go doc >|go.doc
# 	git add --all
# 	git commit -m "${1:-'GitBot: dev progress autosave'}"
# 	git push --set-upstream origin $(git_current_branch)
# }

# ------------------------- gitit -------------------------
#   Automatic repo pre-commit, commit, and push
#
#   Usage: gitit [message]
# ---------------------- Requirements ---------------------
#
#   gpg key generator:          git_gpg.php
#   default status message:     ~/.dotfiles/.stCommitMsg
#
#   example .stCommitMsg:
#       (Gitit Bot): minor updates and formatting.
#       https://www.github.com/skeptycal
# ---------------------------------------------------------
