#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2230,2086

#? ######################## .functions - functions for macOS with zsh
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc

	#* copyright (c) 2019 Michael Treanor
	#* MIT License - https://www.github.com/skeptycal

#? ######################## system checks and reporting

	# recognize comments
	setopt interactivecomments

	# create 'realpath' function if none exists
	command -v realpath >/dev/null 2>&1 || (
		realpath() {
			if [[ $1 = /* ]]; then
				echo "$1"
			else # echo "$PWD/${1#./}"
				cd -P -- "$1" || return
				pwd -P
			fi
		}
	)



	sudo_env() { # Turn on SUDO for remainder of current script
		#   requires root authentication, of course

		#   (use _SUDO_ENV=0 to disable this in all scripts
		#       the default is to turn it on within the function
		#       this makes it implicit with a function call ...)

		declare -rx _SUDO_ENV=${_SUDO_ENV:-1}

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

	get_current_os_name() {
		local uname && uname=$(uname)
		if [ "$uname" = "Darwin" ]; then
			echo "macOS"
			return 0
		elif [ "$uname" = "FreeBSD" ]; then
			echo "freebsd"
			return 0
		elif [ "$uname" = "Linux" ]; then
			local linux_platform_name
			linux_platform_name="$(get_linux_platform_name)" || { echo "linux" && return 0; }

			if [[ "$linux_platform_name" == "rhel.6" ]]; then
				echo "$linux_platform_name"
				return 0
			elif [[ "$linux_platform_name" == alpine* ]]; then
				echo "linux-musl"
				return 0
			else
				echo "linux"
				return 0
			fi
		fi
	}

		#* ################################################
		# from oh-my-zsh install script (somewhat modified)
	which() { command -v "$1"; }                          # use command -v
	command_exists() { command -v "$@" >/dev/null 2>&1; } # pass all params
			exists() { command -v "$1" >/dev/null 2>&1; } # pass only $1
	runif() { exists "$1" && "$@"; }                      # run if $1 exists

	echo() {
		# more portable 'echo'
		if [ -n "$1" ]; then
			printf '%s' "$1"
			shift
		fi
		for arg in "$@"; do
			printf ' %s' "$arg"
		done
		printf '%s\n' ''
		}
	2echo() { ce "$@" >&2; }                              # echo to stderr
	error() { warn ${RED}"Error: $@"${RESET} >&2; }       # Red text to stderr
	#* ################################################

	timestamp() { printf "" $(date "+%D %T"); }

	db_echo() { [[ -n "$SET_DEBUG" ]] && warn "debug info ($(date "+%D %T")) - $*" >&2; }

	yes_no() {
		local yno
		# Accept a Yes/no (default Yes) user response to prompt ($1 or default)
		echo -n "${1:-[Yes/no]: }"
		read -r yno
		case "$yno" in
		[nN] | [nN][oO])
			return 1
			;;
		*) # default 'Yes' ... see function no_yes for default 'No'
			return 0
			;;
		esac
	}

	no_yes() {
		local yno
		# Accept a yes/No (default No) user response to prompt ($1 or default)
		echo -n "${1:-[No/yes]: }"
		read -r yno
		case "$yno" in
		[yY] | [Yy][Ee][Ss])
			return 1
			;;
		*) # default 'No' ... see function yes_no for default 'Yes'
			return 0
			;;
		esac
	}

	a() { alias | grep "$1"; }

KILLIT_USAGE=

	killit() {
		OPT=${1:-}
		SIG=${2:-}
		case $OPT in
			-h|--help)
				cat <<- KILLIT_USAGE
				Usage: ${LIME:-}killit${RESET:-} [OPTION] [SIGNAL] [PID]

				Mandatory arguments to long options are mandatory for short options too.

					-s, --signal=SIGNAL, -SIGNAL
									specify the name or number of the signal to be sent
					-l, --list       list signal names, or convert signal names to/from numbers
					-t, --table      print a table of signal information
						--help     display this help and exit
						--version  output version information and exit
				KILLIT_USAGE
                ;;
			-l)
				cat $KILL_DOC | grep $2
				;;
			-s)
				$(kill $1 $2)
				;;
			-t)
				cat $KILL_DOC | grep $2 | cut -d ' ' -f 2


		esac
	}

KILL_DOC=<<-KILL_DOC
 1 HUP    Hangup: 1
 2 INT    Interrupt: 2
 3 QUIT   Quit: 3
 4 ILL    Illegal instruction: 4
 5 TRAP   Trace/BPT trap: 5
 6 ABRT   Abort trap: 6
 7 EMT    EMT trap: 7
 8 FPE    Floating point exception: 8
 9 KILL   Killed: 9
10 BUS    Bus error: 10
11 SEGV   Segmentation fault: 11
12 SYS    Bad system call: 12
13 PIPE   Broken pipe: 13
14 ALRM   Alarm clock: 14
15 TERM   Terminated: 15
16 URG    Urgent I/O condition: 16
17 STOP   Suspended (signal): 17
18 TSTP   Suspended: 18
19 CONT   Continued: 19
20 CHLD   Child exited: 20
21 TTIN   Stopped (tty input): 21
22 TTOU   Stopped (tty output): 22
23 IO     I/O possible: 23
24 XCPU   Cputime limit exceeded: 24
25 XFSZ   Filesize limit exceeded: 25
26 VTALRM Virtual timer expired: 26
27 PROF   Profiling timer expired: 27
28 WINCH  Window size changes: 28
29 INFO   Information request: 29
30 USR1   User defined signal 1: 30
31 USR2   User defined signal 2: 31
KILL_DOC

ARCHIVED=<<-ARCHIVED

	allopen() { sudo lsof -i -P | grep "$1"; }
	anybar_message() { echo -n "$1" | nc -4u -w0 localhost "${2:-1738}"; }
	anyguard() {
		ANYBAR_PORT="$(jot -r 1 1700 1900)"
		ANYBAR_PORT="$ANYBAR_PORT" open -n /Applications/AnyBar.app
		sleep 0.5
		anybar orange "$ANYBAR_PORT"
		eval "$@"
		ret="$?"
		if [[ ret -eq 0 ]]; then
			anybar green "$ANYBAR_PORT"
		else
			anybar red "$ANYBAR_PORT"
		fi
		echo "Finished. Press [ENTER] to exit."
		# shellcheck disable=2034
		IFS="" read -r ENTER
		anybar quit "$ANYBAR_PORT"
		return "$ret"
	}

	get name for 'open' if linux or windows
	if [ ! "$(uname -s)" = 'Darwin' ]; then
		if grep -q Microsoft /proc/version; then
			alias open='explorer.exe'
		else
			alias open='xdg-open'
		fi
	fi


	export EX_USAGE=64                  # command line usage error
	export EX_DATAERR=65                # data format error

	hex_dump() { [[ -r "$1" ]] && od -A x -t x1z -v "$1"; }

	url_encode() {
		[[ -z "$1" ]] && return $EX_USAGE
		encoded=$(php -r "echo rawurlencode('$1');") && return 0 || return "$EX_DATAERR"
		}

	url_decode() {
		[[ -z "$1" ]] && return $EX_USAGE
		decoded=$(php -r "echo rawurldecode('$1');") && return 0 || return "$EX_DATAERR"
		}


	flasher () { while true; do printf "\\e[?5h"; sleep 0.1; printf "\\e[?5l"; read -rs -t1 && break; done; }

	space() {
		if [ -d $1 ]; then
			mnt=$1
		else
			mnt=''
		fi
		df $mnt -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -
		}

	root_space() { df -P | grep '\/$' | awk '{print $5}' | cut -d "%" -f1 -; }

#?######################## program control
	null_it () { eval "$@" 2>/dev/null; }
		To suppress the error message any output to standard error
		  is sent to /dev/null using 2>/dev/null.

	or_it () { eval "$@" || exit 0; }
		If a command fails an OR operation can be used to provide a fallback
		  (e.g. cat file.txt || exit 0. In this case an exit code of 0 is
		  returned even if tHERE is an error.

	die_now() { exit "$1"; }
#?######################## error reporting
	errcho(){ >&2 echo "$@"; }
		# REF: https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr


#?######################## program debugging / logging / trace functions

	exit_usage() {
		# Print script usage and exit
		# TODO replace with die()
		# Parameters:
		#   "$1" - specific message (e.g. 'file not found')
		#   "$2" - optional usage text
		die "$@"
		}

	show_exports() {
		for var in $(export -p); do
			if declare -p "$var"; then
				true
				# if the var exists, get the name of it ...
			fi
		done
		}
	get_function_list() {
		grep "$1" '() {' | sed 's/\(\.*\)*() {/\1/' | sed 's/function //' | sed 's/^[# ]*//' | sed 's/cat//' | cut -d ' ' -f1
		}

	l() {
		# added 'list' default parameter instead of 'help'
		eval "launchctl ${*:-list}"
		}


#?######################## error handling
	_set_traps() {
		cur_opts="$-"
		debug_opts="axET"
		set "-${cur_opts}${debug_opts}"
	}

	_trap_error() {
		me "ERR: $ERR"
		set "-${cur_opts}"
		# return 0
	}

	_trap_debug() {
		# return 0
		ce "Script source:$MAIN $SCRIPT_SOURCE$RESET_FG $* \n"
		attn "echo VARIABLE ($VARIABLE) is being used HERE."
	}

	_trap_exit() {
		# https://stackoverflow.com/a/50270940/9878098
		exitcode=$?
		printf 'error executing script...\n' 1>&2
		printf 'exit code returned: %s\n' "$exitcode"
		printf 'the command executing at the time of the error was: %s\n' "$BASH_COMMAND"
		printf 'command present on line: %d' "${BASH_LINENO[0]}"
		# Some more clean up code can be added HERE before exiting
		set "-${cur_opts}"
		exec 4>&- 5>&- 6>&-
		if [[ "$LOG" == '1' ]]; then
			LOG='0'
			exec 1>&4 2>&5
			exec 4>&- 5>&-
			attn "logging off ..."
		fi

		exit $exitcode
	}
ARCHIVED
