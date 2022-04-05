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

	weekday=$(date +%a)       					# Sun
	monthday=$(date +%d)      					# 23
	year=$(date +%Y)          					# 2020
	today=$(date +%F)         					# 2020-08-23
	now=$(date +%T)          					# 03:17:11
	nowdate=$(date +%m-%d-%Y)					# 09-12-2020
	week=$(date +%V)         					# 37
	seconds=$(date +%s)      					# 1600377174 s
	get_timestamp=$(date +%s%N)  				# 1600377060096604000 ns

	SCRIPT_NAME=${0##*/}
	ZDOTDIR=${ZDOTDIR:=$HOME/.dotfiles}

#? ######################## MAIN LOOP
	_main_() {
		_login_message
		_debug_tests
	}
#? ######################## ENTRY POINT
	_main_ "$@"
	true

#? ######################## References
	# 'find types' https://www.gnu.org/software/findutils/manual/html_mono/find.html#Type
	# pipe $2 with $1 using |&  https://unix.stackexchange.com/questions/128975/why-doesnt-grep-using-pipe-work-here
	# mkdir ref: https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

	# ref: get url of Chrome active tab:
	# https://www.cyberciti.biz/faq/linux-unix-sleep-bash-scripting/
