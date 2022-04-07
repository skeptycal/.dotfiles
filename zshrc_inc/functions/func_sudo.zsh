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
			green $(type -a git)
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

	not_root(){
		# the environment variable $EUID contains the 'effective user id'
		# it is locked by the shell and cannot be 'easily' changed
		#   example shell response:
		# % EUID = 0
		# zsh: failed to change effective user ID: operation not permitted

		# This is likely a safer method than shell programs such as 'id'
		return $(( EUID == 0 ));
		} >/dev/null 2>&1

	is_root() {
		# complementary function for 'not_root'
		return $(( EUID>0 ))
		} >/dev/null 2>&1

	userid_not_root(){
		# Using shell programs (whoami, uname, or id) to get username or userid and could easily be vulnerable to bypassing if they are replaced with a dummy file earlier in the path. Using scutil may be more difficult to fool, but is itself a shell program found on the path ...

		# It is interesting to realize that many secure macOS utilities (chown,
		# 	scutil, md5, halt, mount, kextload, fsck, launch_d, etc) are located
		#	in the /usr/sbin directory ... and scutil seems a less likely target
		# 	for attack than the ubiquitous 'id' program.

		# In any event, using the full path name is much safer. On a modern macOS
		# 	system, the /usr/bin directory is set to read only and this message
		# 	is the response to attempted changes:

		# 	mv: cannot move 'bin' to 'bin2': Read-only file system

		declare ix loggedInUserID="$( scutil <<< "show State:/Users/ConsoleUser"  | awk '/UID : / && ! /loginwindow/ { print $3 }' )"

		return $(( loggedInUserID=0 ))
		} >/dev/null 2>&1

	sudo_env() { # Turn on SUDO for remainder of current script
		#   requires root authentication, of course

		#   (use _SUDO_ENV=0 to disable this in all scripts
		#       the default is to turn it on within the function
		#       this makes it implicit with a function call ...)

		declare -x _SUDO_ENV=${_SUDO_ENV:-1}

		if [[ $_SUDO_ENV == 1 ]]; then
			warn "Using SUDO for this script ..." || echo "Using SUDO for this script ..."
			# Ask for the root password upfront
			/usr/bin/sudo -v

			# Keep-alive: update existing `sudo` time stamp until script has finished
			while true; do
				/usr/bin/sudo -n true
				/bin/sleep 60
				/bin/kill -0 "$$" || exit
			done 2>/dev/null &
		fi
		}
