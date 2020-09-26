#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> .functions - functions for macOS with zsh
#*	system functions
#*  tested on macOS Big Sur and zsh 5.8
#*	copyright (c) 2019 Michael Treanor
#*	MIT License - https://www.github.com/skeptycal
#? -----------------------------> https://www.github.com/skeptycal

#? -----------------------------> environment
    SCRIPT_NAME=${0##*/}
	set -a # export all
	declare -ix SET_DEBUG=${SET_DEBUG:-0}  		# set to 1 for verbose testing

#? -----------------------------> BASH compatibility
	if [[ ${SHELL##*/} == 'zsh' ]]; then
    	setopt interactivecomments
        setopt SH_WORD_SPLIT # 'BASH style' word splitting
        BASH_SOURCE=${(%):-%N}
    else
        BASH_SOURCE=${BASH_SOURCE:=$0}
    fi
#? -----------------------------> debug
	_debug_tests() {
        printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"

        # script specific debug info and tests
        green "timestamp: $(timestamp)"
        }
#? -----------------------------> copyright (c) 2019 Michael Treanor
    main() {
        (( SET_DEBUG > 0 )) && _debug_tests "$@"
    }
#? ###################### copyright (c) 2019 Michael Treanor #################

    # number of years the first commercial
    #   modem would take to transmit a movie: 42.251651342415241

#? -----------------------------> RealPath
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

    #? -----------------------------> git housekeeping (TODO)
    #TODO - wip ...
    _housekeeping () {
        git fetch -p && git branch -vv | awk '/: gone]/ {print $1}' | xargs git branch -d
        }

#? -----------------------------> cli utilities
    # Some References:
    # - utilities from https://justin.abrah.ms/dotfiles/zsh.html
    # from oh-my-zsh install script (somewhat modified)
	which() { command -v "$1"; }                          # use command -v
	command_exists() { command -v "$@" >/dev/null 2>&1; } # pass all params
			exists() { command -v "$1" >/dev/null 2>&1; } # pass only $1
	runif() { exists "$1" && "$@"; }                      # run if $1 exists
#? -----------------------------> stdout & stderr
	# echo() {
	# 	# more portable 'echo'
	# 	if [ -n "$1" ]; then
	# 		printf '%b' "$1"
	# 		shift
	# 	fi
	# 	for arg in "$@"; do
	# 		printf ' %b' "$arg"
	# 	done
	# 	printf '%b\n' ''
	# 	}
	2echo() { ce "$@" >&2; }
	error() { warn ${RED}"Error: $@"${RESET} >&2; }
	db_echo() { (( SET_DEBUG > 0 )) && warn "debug info ($(date +"%D %T")) - $*" >&2; }
    br() { echo ''; }
#? -----------------------------> Strings and arrays
    dict() { grep "$@" /usr/share/dict/words; }
    colon_list() { echo -e "${1//:/\\n}"; }
    in_str() { string=${@:2}; return $([ -z "${string##*$1*}" ]); }
    is_instr() { return $([[ "${@:2}" == *"$1"* ]]); }
    lower() { ce "${*:l}"; } # return all args as lowercase (zsh only)
    upper() { ce "${*:u}"; } # return all args as uppercase (zsh only)
#? -----------------------------> Functions
	a() { alias | grep "$1"; }
    _timestamp() { printf "%s\n" $(date +"%D %T"); }
    # log internet speedtest results over time (runs until stopped)
	speedlog() { while true; do speedtest --format=csv >>${1:-~/.speedtest.csv}; done; }
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




    azure_agent() {
        # svc.sh only seems to work when run from its own directory ...
        # added default parameter 'status'
        local temp_pwd="$PWD"
        cd "$AZURE_WORKING_DIR" || return
        "${AZURE_WORKING_DIR}/svc.sh" "${1:-'status'}"
        result="$?"
        cd "$temp_pwd" || return
        unset temp_pwd
        return $result
        }

#? -----------------------------> Directory Utilities
    # directory LS
    # lsd () { ls -la | grep "^d" | awk '{ print $9 }' | tr -d "/"; }
    mkd(){
        if [ $# -eq 0 ]; then
            echo "${LIME:-}$0: ${MAIN:-}(DIRNAME) [MODE - default=755]${RESET:-}"
        else
            local d="$1"               # get DIRNAME
            local m=${2:-0755}         # get MODE, set default to 0755
            # shellcheck disable=2174
            [ -r "$d" ] && { echo "${WARN:-}Error: '$d' already exists ..."; return 1; } || mkdir -pv -m "$m" "$d"
            cd $d
        fi
        }
    # path() { # TODO - work in progress ...
    #     path_usage() { lime "path ${GO:-}[-d 'DELIM'] [-f 'FIND'] [-r 'REPL'] [PATH string]"; }
    #     path_options() {
    #         (( $# < 2 )) && {path_usage && exit 1}
    #         while (( $# > 0 )); do
    #             case $1 in
    #                 -h|--help)
    #                     path_usage
    #                     exit 0
    #                     ;;
    #                 -d|--delimiter)
    #                     shift
    #                     DELIM="$1"
    #                     ;;
    #                 -f|--find)
    #                     shift
    #                     FIND="$1"
    #                     ;;
    #                 -r|--replace)
    #                     shift
    #                     REPL="$1"
    #                     ;;
    #                 *)
    #                     ARGS="${ARGS}:${1}" # temp delimiter is ':'
    #                     ;;
    #             esac
    #             shift
    #         done
    #         }

    #     ARGS=
    #     DELIM=':'
    #     FIND=
    #     REPL=
    #     HILT="${CANARY:-}${FIND}${RESET:-}"

    #     path_options

    #     path_param=${ARGS:-$PATH} # use PATH as default
    #     path_param="${path_param//\:/$DELIM}" # replace temp delimiter

    #     if [ -n $FIND ]; then
    #         if [ -n $REPL ]; then # if FIND and REPL are true -> replace stuff
    #             path_param="${path_param//$FIND/$REPL}" # replace FIND with REPL
    #         else # if FIND and NOT REPL -> highlight only
    #             HILT="${CANARY:-}${FIND}${RESET:-}"
    #             path_param="${path_param//$FIND/$HILT}" # replace FIND with HILT
    #         fi
    #     else
    #         if [ -n $REPL ]; then # if REPL and NOT FIND -> remove only
    #             path_param="${path_param//$REPL/}" # replace REPL with ''
    #         else # if neither FIND nor REPL are true -> remove duplicate DELIM's
    #             path_param="${path_param//${DELIM}${DELIM}/$DELIM}"
    #         fi
    #     fi

    #     echo $path_param
    #     # IFS="$'\n\t :'"
    #     IFS=$DELIM; for p in ${=path_param}; do
    #         # shellcheck disable=2015
    #         [[ -d "$p" ]] && green "$p" || attn "$p"
    #     done
    #     }
#? -----------------------------> Permissions Utilities
    psgrep() {
        if [ -n "$1" ] ; then
            echo "Grepping for processes matching $1..."
            ps aux | grep "$1" | grep -v grep
        else
            echo "!! Need name to grep for"
        fi
        }
    # Kills any process that matches a regexp passed to it
    killit() { ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill; }
    chmod_all() {
        # chmod matching files to given mode
        # $1 is path (default $PWD);
        # $2 is pattern (default '*');
        # $3 is mode (default '644' for files, '755' for directories)
        case "$1" in
        '-h' | '--help' | 'help')
            echo "Usage : $0 [path($PWD)] [pattern(*)] [mode(644)]"
            return "$EX_USAGE"
            ;;
        esac
        # Check the given file is exist #
        if [ ! -f "$3" ]; then
            echo "Filename given \"$3\" doesn't exist"
            return 1
        fi
        find -L "${1:-$PWD}" -name "${2:-'*'}" -type f -print0 | xargs -0 chmod "${3:-644}"
        }

    extract () {
        if [ -f "$1" ] ; then
            case $1 in
                *.tar.bz2)        tar xjf "$1"        ;;
                *.tar.gz)         tar xzf "$1"        ;;
                *.bz2)            bunzip2 "$1"        ;;
                *.rar)            unrar x "$1"        ;;
                *.gz)             gunzip "$1"         ;;
                *.tar)            tar xf "$1"         ;;
                *.tbz2)           tar xjf "$1"        ;;
                *.tgz)            tar xzf "$1"        ;;
                *.zip)            unzip "$1"          ;;
                *.Z)              uncompress "$1"     ;;
                *.7z)             7zr e "$1"          ;;
                *)                echo "'$1' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$1' is not a valid file"
        fi
        }

    find_broken() {
        # Find and delete all broken symbolic links in current directiry
        # use safety feature $1 == '-d' to actually delete them
        # interesting method:
        # https://stackoverflow.com/a/26887762/9878098

        if [ -z "$1" ]; then
            echo "Usage: $0 [-d]"
        else
            if [[ "$1" == "-d" ]]; then
                echo "Deleting Broken Symlinks ..."
                find -L "$PWD" -type l -exec rm -- {} +
            else
                echo "Listing Broken Symlinks (use -d to delete links)..."
                find -L ${1:-$PWD} -type l -print 2>&1
            fi
        fi
        }

    web_chmod() {
        # Set default permissions for a folder that will be uploaded to the web.
        # default directory is PWD
        # most files = 644; directories = 755
        [[ -d "$1" ]] && dir="$1" || dir=$PWD
        find -LX "$dir" -type f -print0 | xargs -0 chmod 644
        echo "Changing permissions of all regular files to 0644."
        find -LX "$dir" -type d -print0 | xargs -0 chmod 755
        echo "Changing permissions of all regular directories to 0755."
        # ls "$dir" -ARlh
        }
#? -----------------------------> main
main "$@"
true
