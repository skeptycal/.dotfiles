#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> repo_tools.sh - tools for repo management for macOS with zsh
	#*	system functions
	#*  tested on macOS Big Sur and zsh 5.8
	#*	copyright (c) 2021 Michael Treanor
	#*	MIT License - https://www.github.com/skeptycal
#? -----------------------------> https://www.github.com/skeptycal
#? -----------------------------> environment
    . "${DOTFILES_INC}/ansi_colors.sh" || . $(which ansi_colors.sh)
	. "${DOTFILES_INC}/github_config_secret.sh" || . $(which github_config_secret.sh)

    SCRIPT_NAME=${0##*/}
#? -----------------------------> debug info
	declare -ix SET_DEBUG=${SET_DEBUG:-0}  		# set to 1 for verbose testing

	_debug_tests() {
		if (( SET_DEBUG > 0 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green "Today is $today"
			# _test_args "$@"
			dbecho "DEBUG mode is enabled. Set it to 0 to disable these messages."
			dbecho ""
			dbecho "ANSI colors active: $(which ansi_colors.sh)"
		fi
		}

#? -----------------------------> parameter expansion tips
 #? ${PATH//:/\\n}    - replace all colons with newlines
 #? ${PATH// /}       - strip all spaces
 #? ${VAR##*/}        - return only final element in path (program name)
 #? ${VAR%/*}         - return only path (without program name)

#? -----------------------------> repo management


	: <<-'DISABLED'
		#/ gi() is defined in the zsh .gitignore plugin as:
		# function gi() { curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}" }

		gi () {
			curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}"
			}
	DISABLED

	gi () { curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}"; }


	# File test operators
		# The test command includes the following FILE operators that allow you to test for particular types of files:

		# -b FILE - True if the FILE exists and is a special block file.
		# -c FILE - True if the FILE exists and is a special character file.
		# -d FILE - True if the FILE exists and is a directory.
		# -e FILE - True if the FILE exists and is a file, regardless of type (node, directory, socket, etc.).
		# -f FILE - True if the FILE exists and is a regular file (not a directory or device).
		# -G FILE - True if the FILE exists and has the same group as the user running the command.
		# -h FILE - True if the FILE exists and is a symbolic link.
		# -g FILE - True if the FILE exists and has set-group-id (sgid) flag set.
		# -k FILE - True if the FILE exists and has a sticky bit flag set.
		# -L FILE - True if the FILE exists and is a symbolic link.
		# -O FILE - True if the FILE exists and is owned by the user running the command.
		# CANARY -p FILE - True if the FILE exists and is a pipe.
		# -r FILE - True if the FILE exists and is readable.
		# PURPLE -S FILE - True if the FILE exists and is a socket.
		# -s FILE - True if the FILE exists and has nonzero size.
		# -u FILE - True if the FILE exists, and set-user-id (suid) flag is set.
		# -w FILE - True if the FILE exists and is writable.
		# -x FILE - True if the FILE exists and is executable.

	checkdir() {
		OFS=$IFS
		IFS=$'\n'
		local files=$(ls -1A ${1:-.});
		local file=
		for file in $files; do
			_color="${ATTN:-}"
			if [ ! -e "$file" ]; then _color="${WARN:-}";			# does not exist
			elif [ -h ${file} ]; then _color="${CYAN:-}"; 			# symbolic link
			# elif [[ -r ${file} && -w ${file} && -x ${file} ]]; then _color="${DARKGREEN:-}${REVERSED:-}"; 		# unprotectedd file
			elif [ -d ${file} ]; then _color="${BLUE:-}"; 			# directory
			elif [ -p ${file} ]; then _color="${PINK:-}";  			# pipe
			elif [ -S ${file} ]; then _color="${PURPLE:-}";  		# socket
			elif [ -c ${file} ]; then _color="${CANARY:-}";  		# special character file
			elif [ -b ${file} ]; then _color="${ORANGE:-}";  		# special block file
			elif [ -x ${file} ]; then _color="${GREEN:-}"; 			# executable file
			elif [ -e ${file} ]; then _color="${WHITE:-}"; 			# exists
			fi
			ce "${_color:-}${file}"
		done;
		IFS=$OFS
	}

	git_current_branch () {
		local ref
		ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
		local ret=$?
		if [[ $ret != 0 ]]
		then
			[[ $ret == 128 ]] && return
			ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return
		fi
		echo ${ref#refs/heads/}
	}

	is_empty_dir() {
		[ -z "$(ls -A ${1:-$PWD})" ]
	}

	get_timestamp() { printf "%16.16s\n" $(date +"%s%N"); }

	ip_lookup() {
		# www.example.com
		nslookup "$1" | tail -n 2 | cut -d ' ' -f 2
	}

	ping_log() {
		#/ ######### Example:
		# PING www.example.com (93.184.216.34): 56 data bytes
		# --- www.example.com ping statistics ---
		# 1 packets transmitted, 1 packets received, 0.0% packet loss
		# round-trip min/avg/max/stddev = 30.113/30.113/30.113/0.000 ms
		_max_trials=100000
		_SLEEP_DELAY=60
		_counter=0
		_quiet=
		_datestamp=$(date +'%m%Y')

		# Usage ping_log [n] [url] [quiet?]
		_N=${1:=5}
		_URL="${2:='http://www.example.com'}"
		[[ -n "$3" ]] && _quiet="shhh"
		_pinglog=~/.pinglog_$_datestamp

		# file format: CSV
		# timestamp, packet-loss, min, avg, max, stddev, n, url
		[ ! -f $_pinglog ] && echo "timestamp, packet-loss, min, avg, max, stddev, n, url" >$_pinglog

		while (( $_counter < $_max_trials )); do

			_timestamp=$(get_timestamp)
			p_run=$(ping -q -c 3 www.example.com)
			p_loss=$( echo $p_run | grep 'round-trip' | cut -d ' ' -f 18; )
			p_nums=$( echo $p_run | grep 'round-trip' | cut -d ' ' -f 24; )
			p_min=$(echo $p_nums | cut -d '/' -f 1; )
			p_avg=$(echo $p_nums | cut -d '/' -f 2; )
			p_max=$(echo $p_nums | cut -d '/' -f 3; )
			p_sd=$(echo $p_nums | cut -d '/' -f 4; )

			printf "%s, %s, %s, %s, %s, %s, %s, %s\n" $_timestamp $p_loss $p_min $p_avg $p_max $p_sd $_N $_URL >>$_pinglog

			 [[ -z $_quiet ]]  && printf "%s, %s, %s, %s, %s, %s, %s, %s\n" $_timestamp $p_loss $p_min $p_avg $p_max $p_sd $_N $_URL

			_counter=$(( $_counter + 1 ))

			sleep $_SLEEP_DELAY
		done
	}

	#* custom file header for Go, Python, etc.
	#* Usage: _file_blurb [comment_char] [shebang]
	_file_blurb() {
		# if a different comment string is desired, pass as $1
		# The default // is used for Go
		_comment=${1:='//'}
		# _shebang=
		# echo "\$2: $2"
		# exists "$2" && _shebang='#!/usr/bin/env '"${2}\\n"
		# echo "\$_shebang: $_shebang"
		# echo ""

		cat <<-EOF
			${_comment} Copyright (c) $( date +"%Y" ) ${AUTHOR}
			${_comment} ${AUTHOR_URL}
			${_comment} ${LICENSE} License

		EOF
	}

	#* combine personal .gitignore items with the api defaults
	makeGI() {
		cat >|.gitignore <<-EOF
			############################################
			$( _file_blurb '#' )

			### Personal ###
			**/[Bb]ak/
			**/*.bak
			**/*temp
			**/*tmp
			**/.waka*

			### Repo Specific ###
			**/idea.md

			### Security ###
			**/*[Tt]oken*
			**/*[Pp]rivate*
			**/*[Ss]ecret*
			*history*
			*hst*

			############################################
		EOF
		# modified on 1/24/2022 - some endpoints are no longer available:
		#   VSCODE NUXT
		# gi macos linux windows ssh vscode go zsh node vue nuxt python django flask yarn laravel git >>.gitignore
		gi macos linux windows ssh go zsh node vue python django flask yarn laravel git >>.gitignore
	}

	gac() { # Usage: gac [message] # git add, commit, push
		local message=${1:=$_default_commit_message}
		git add --all #>/dev/null 2>&1
		git commit -m "${message}" #>/dev/null 2>&1
		# (( $? )) && warn "error with git commit ${message}"
		git push origin --all #>/dev/null 2>&1
		# (( $? )) && warn "error with git push"
	}
	_gh_auth_username() {
		_gh_user=$( gh auth status 2>&1 | grep "Logged in to github.com as" | awk '{ print $7 }'; )
	}

#? -----------------------------> main
	(( SET_DEBUG > 0 )) && _debug_tests "$@"
	true
