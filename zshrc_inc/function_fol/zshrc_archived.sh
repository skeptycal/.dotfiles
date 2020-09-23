#!/usr/bin/env false zsh
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

#? -----------------------------> Archived Commands (inactive)
    # get name for 'open' if linux or windows
    # if [ ! "$(uname -s)" = 'Darwin' ]; then
    #     if grep -q Microsoft /proc/version; then
    #         alias open='explorer.exe'
    #     else
    #         alias open='xdg-open'
    #     fi
    # fi

	# allopen() { sudo lsof -i -P | grep "$1"; }
	# anybar_message() { echo -n "$1" | nc -4u -w0 localhost "${2:-1738}"; }
	# anyguard() {
	# 	ANYBAR_PORT="$(jot -r 1 1700 1900)"
	# 	ANYBAR_PORT="$ANYBAR_PORT" open -n /Applications/AnyBar.app
	# 	sleep 0.5
	# 	anybar orange "$ANYBAR_PORT"
	# 	eval "$@"
	# 	ret="$?"
	# 	if [[ ret -eq 0 ]]; then
	# 		anybar green "$ANYBAR_PORT"
	# 	else
	# 		anybar red "$ANYBAR_PORT"
	# 	fi
	# 	echo "Finished. Press [ENTER] to exit."
	# 	# shellcheck disable=2034
	# 	IFS="" read -r ENTER
	# 	anybar quit "$ANYBAR_PORT"
	# 	return "$ret"
	# }

	# get name for 'open' if linux or windows
	# if [ ! "$(uname -s)" = 'Darwin' ]; then
	# 	if grep -q Microsoft /proc/version; then
	# 		alias open='explorer.exe'
	# 	else
	# 		alias open='xdg-open'
	# 	fi
	# fi


	# export EX_USAGE=64                  # command line usage error
	# export EX_DATAERR=65                # data format error

	# hex_dump() { [[ -r "$1" ]] && od -A x -t x1z -v "$1"; }

	# url_encode() {
	# 	[[ -z "$1" ]] && return $EX_USAGE
	# 	encoded=$(php -r "echo rawurlencode('$1');") && return 0 || return "$EX_DATAERR"
	# 	}

	# url_decode() {
	# 	[[ -z "$1" ]] && return $EX_USAGE
	# 	decoded=$(php -r "echo rawurldecode('$1');") && return 0 || return "$EX_DATAERR"
	# 	}


	# flasher () { while true; do printf "\\e[?5h"; sleep 0.1; printf "\\e[?5l"; read -rs -t1 && break; done; }

	# space() {
	# 	if [ -d $1 ]; then
	# 		mnt=$1
	# 	else
	# 		mnt=''
	# 	fi
	# 	df $mnt -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -
	# 	}

	# root_space() { df -P | grep '\/$' | awk '{print $5}' | cut -d "%" -f1 -; }

    # #?-----------------------------> program control
	# null_it () { eval "$@" 2>/dev/null; }
	# 	To suppress the error message any output to standard error
	# 	  is sent to /dev/null using 2>/dev/null.

	# or_it () { eval "$@" || exit 0; }
	# 	If a command fails an OR operation can be used to provide a fallback
	# 	  (e.g. cat file.txt || exit 0. In this case an exit code of 0 is
	# 	  returned even if tHERE is an error.

	# die_now() { exit "$1"; }
    # #?-----------------------------> error reporting
	# errcho(){ >&2 echo "$@"; }
	# 	# REF: https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr


    #?-----------------------------> program debugging / logging / trace functions

        # exit_usage() {
        # 	# Print script usage and exit
        # 	# TODO replace with die()
        # 	# Parameters:
        # 	#   "$1" - specific message (e.g. 'file not found')
        # 	#   "$2" - optional usage text
        # 	die "$@"
        # 	}

        # show_exports() {
        # 	for var in $(export -p); do
        # 		if declare -p "$var"; then
        # 			true
        # 			# if the var exists, get the name of it ...
        # 		fi
        # 	done
        # 	}
        # get_function_list() {
        # 	grep "$1" '() {' | sed 's/\(\.*\)*() {/\1/' | sed 's/function //' | sed 's/^[# ]*//' | sed 's/cat//' | cut -d ' ' -f1
        # 	}

        # l() {
        # 	# added 'list' default parameter instead of 'help'
        # 	eval "launchctl ${*:-list}"
        # 	}


    #?-----------------------------> error handling
        # _set_traps() {
        # 	cur_opts="$-"
        # 	debug_opts="axET"
        # 	set "-${cur_opts}${debug_opts}"
        # }

        # _trap_error() {
        # 	me "ERR: $ERR"
        # 	set "-${cur_opts}"
        # 	# return 0
        # }

        # _trap_debug() {
        # 	# return 0
        # 	ce "Script source:$MAIN $SCRIPT_SOURCE$RESET_FG $* \n"
        # 	attn "echo VARIABLE ($VARIABLE) is being used HERE."
        # }

        # _trap_exit() {
        # 	# https://stackoverflow.com/a/50270940/9878098
        # 	exitcode=$?
        # 	printf 'error executing script...\n' 1>&2
        # 	printf 'exit code returned: %s\n' "$exitcode"
        # 	printf 'the command executing at the time of the error was: %s\n' "$BASH_COMMAND"
        # 	printf 'command present on line: %d' "${BASH_LINENO[0]}"
        # 	# Some more clean up code can be added HERE before exiting
        # 	set "-${cur_opts}"
        # 	exec 4>&- 5>&- 6>&-
        # 	if [[ "$LOG" == '1' ]]; then
        # 		LOG='0'
        # 		exec 1>&4 2>&5
        # 		exec 4>&- 5>&-
        # 		attn "logging off ..."
        # 	fi

        # 	exit $exitcode
        # }

    #?-----------------------------> error handling
        # portslay () {
        #     kill -9 "$(lsof -i tcp:"$1" | tail -1 | awk '{ print $2;}')"
        #     }
        # exip () {
        #     # gather external ip address
        #     echo -n "Current External IP: "
        #     curl -s -m 5 http://myip.dk | grep "ha4" | sed -e 's/.*ha4">//g' -e 's/<\/span>.*//g'
        #     }
        # ipaddr () {
        #     # determine local IP address
        #     ifconfig | grep "inet " | awk '{ print $2 }'
        #     }

        # dataurl() {
        #     local mimeType
        #     mimeType=$(file -b --mime-type "$1")
        #     if [[ "$mimeType" == text/* ]]; then
        #         mimeType="${mimeType};charset=utf-8"
        #     fi
        #     echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
        #     }

        # digga() { dig +nocmd "$1" any +multiline +noall +answer; }
        # dist_hook() {
        #     # TODO not yet implemented
        #     return 0
        #     # https://stackoverflow.com/a/8969875
        #     # find -regextype posix-egrep -regex ".*(\.([chyl]|def|cpy|cob|conf|cfg)|(README|ChangeLog|AUTHORS|ABOUT-NLS|NEWS|THANKS|TODO|COPYING.*))$" -exec sed -i -e 's/\r*$/\r/' {} \;
        #     # OR
        #     # for F in Documents/*.{py,html}; do ...something with each '$F'... ; done
        #     }

        # getcertnames() {
        #     if [ -z "${1}" ]; then
        #         echo "ERROR: No domain specified."
        #         return 1
        #     fi
        #     local domain="${1}"
        #     echo "Testing ${domain}â€¦"
        #     echo ""
        #     local tmp
        #     local certText
        #     tmp=$(echo -e "GET / HTTP/1.0\nEOT" |
        #         openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)
        #     if [[ "${tmp}" == *"-----BEGIN CERTIFICATE-----"* ]]; then
        #         certText=$(echo "${tmp}" |
        #             openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
        #                 no_serial, no_sigdump, no_signame, no_validity, no_version")
        #         echo "Common Name:"
        #         echo ""
        #         echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
        #         echo ""
        #         echo "Subject Alternative Name(s):"
        #         echo ""
        #         echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
        #             sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
        #         return 0
        #     else
        #         echo "ERROR: Certificate not found."
        #         return 1
        #     fi
        #     }

        # replace() {
        #     if [[ -z "$1" ]]; then
        #         attn $'missing argument ...'
        #         me $'\nUsage: replace ORIGINAL [NEW] [FILES...]'
        #         exit "$EX_USAGE"
        #     fi
        #     ORIGINAL="$1"
        #     REPLACEMENT="${2:-}"
        #     FILES="${3:-'.'}"

        # # shellcheck disable=2013,2086
        # for word in $(grep -Fl $ORIGINAL $FILES)
        # do
        # # -------------------------------------
        # ex $word <<EOF
        #     :%s/$ORIGINAL/$REPLACEMENT/g
        #     :wq
        # EOF
        # # :%s is the "ex" substitution command.
        # # :wq is write-and-quit.
        # # -------------------------------------
        # done
        #     }

        # safe_split() {
        #     # use custom IFS for safe word splitting of oddly formatted strings
        #     if [ -z "$2" ]; then
        #         attn "Usage: safe_split <DELIMITER> <DATA (array | string | file)>"
        #     else
        #         IFS="$1"
        #         shift
        #         ce "$*"
        #     fi
        #     }

        # lower_file() {
        #     # set force_lower if first arg is '-f' else echo only

        #         # original
        #         #   t=$(echo $f | tr '[:upper:]' '[:lower:]')
        #         #   zsh uses ${file:l}
        #     local force_lower=0
        #     local file=
        #     if [[ $1 == '-f' ]]; then
        #         force_lower=1
        #         shift
        #     fi
        #     for file in "$@"; do
        #         if [[ $force_lower == 1 ]]; then
        #             mv -ub "$file" "${file:l}"
        #         else
        #             echo "$file" "${file:l}"
        #         fi
        #     done
        #     unset force_lower file
        #     }

        # prettier_here() {
        #     # $1 = path (default $PWD); $2 = filenames ( default '*')
        #     # OR
        #     # $1 = 'git'; $2 = "$files"
        #     if [[ "$1" == 'git' ]]; then
        #         FILES=$(git diff --cached --name-only | sed 's| |\\ |g')
        #         echo "${2:-$FILES}" | xargs prettier --write | grep -e '[[:space:]]\?[[:digit:]]\+ms'
        #     else
        #         find -L "${1:-$PWD}" -name "${2:-'*'}" -type f -print0 | xargs -0 prettier --write | grep -e '[[:space:]]\?[[:digit:]]\+ms'
        #     fi
        #     }
        # pretty() {
        #     # Use prettier to format all compatible selected files
        #     # Use $1 for pattern, -m (github diff) or default is '*'
        #     if [[ -z "$1" ]]; then
        #         echo "Making all the things pretty! (use pretty -h for help)"
        #         yes_no 'Make all of the things Prettier? (Y/n) '
        #         if [ "$?" ]; then
        #             ce "$_pretty_usage"
        #         else
        #             prettier_here
        #         fi
        #     else
        #         case "$1" in
        #         '-h' | '--help' | 'help')
        #             ce "$_pretty_usage"
        #             return "$EX_USAGE"
        #             ;;
        #         '-m' | '--commit-message' | 'commit')
        #             # echo "Making your git staged file pretty ..."
        #             # select stated files
        #             FILES=$(git diff --cached --name-only | sed 's| |\\ |g')
        #             # Prettify all selected files
        #             prettier_here
        #             # Add back the modified/prettified files to staging
        #             echo "$FILES" | xargs git add
        #             git commit -m "prettybot: $2"
        #             git status
        #             ;;
        #         *)
        #             prettier_here "$PWD" "$1"
        #             ;;
        #         esac
        #     fi
        #     }

        #? -----------------------------> Archived
        # space() {
        #     if [ -d $1 ]; then
        #         mnt=$1
        #     else
        #         mnt=''
        #     fi
        #     df $mnt -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -
        #     }

        # root_space() { df -P | grep '\/$' | awk '{print $5}' | cut -d "%" -f1 -; }

        # gather_del() {
        #     find . -name "${1:-*}" -type f -print0 | xargs -0 /bin/rm -f ;
        #     }
        # bak() {
        #     FILES="$*"
        #     [[ -d "$PWD/bak" ]] || mkdir "$PWD/bak"
        #     for file in $FILES; do
        #         [[ -d "$file" ]] && bak "$file"
        #         printf "Backup file %s " "$file"
        #         [[ -f "$file" ]] && cp -f "$file" "bak/${file}.bak" || echo -e "${WARN}backup unsuccessful - ${MAIN}${file}${RESET_FG}"
        #         echo ''
        #     done
        #     }

        # check_file() {
        #     #? ${VAR##*/}        - return only final element in path (program name)
        #     #? ${VAR%/*}         - return only path (without program name)
        #     filename=$(py_realpath $1)
        #     local name="${filename##*/}"
        #     local path="${filename%/*}"
        #     echo "name: $name"
        #     echo "path: $path"
        #     local tmp_chk=''
        #     [[ -e "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} exists"
        #     [[ -d "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} d"
        #     [[ -r "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk}-r"
        #     [[ -w "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk}-w"
        #     [[ -x "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk}-e"
        #     [[ -f "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} norm"
        #     [[ -L "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} link"
        #     [[ -s "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} size>0"
        #     [[ -O "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} mine"
        #     [[ -N "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} dirty"
        #     [[ -k "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
        #     tmp_chk="${tmp_chk} sticky$RESET"
        #     echo -e " ->$tmp_chk"
        #     echo ''
        #     }
        # fileop() {
        #     # TODO work in progress
        #     return 0
            # File counter, filter, and editor for word or line matches
            # Check 3 arguments are given #
            # if [ "$#" -lt 3 ]; then
            #     echo "Usage : $0 option pattern filename"
            #     return 1
            # fi
            # - # Check the given file is exist #
            # if [ ! -f "$3" ]; then
            #     echo "Filename given \"$3\" doesn't exist"
            #     return 1
            # fi
            # case "$1" in
            # - # Count number of lines matches
            # -i)
            #     echo "Number of lines matches with the pattern $2 :"
            #     fgrep -c -i $2 $3
            #     ;;
            # - # Count number of words matches
            # -c)
            #     echo "Number of words matches with the pattern $2 :"
            #     fgrep -o -i $2 $3 | wc -l
            #     ;;
            # - # print all the matched lines
            # -p)
            #     echo "Lines matches with the pattern $2 :"
            #     fgrep -i $2 $3
            #     ;;
            # - # Delete all the lines matches with the pattern
            # -d)
            #     echo "After deleting the lines matches with the pattern $2 :"
            #     sed -n "/$2/!p" $3
            #     ;;
            # *)
            #     echo "Invalid option"
            #     ;;
            # esac
            # }

        # fs() {
        #     if du -b /dev/null >/dev/null 2>&1; then
        #         local arg=-sbh
        #     else
        #         local arg=-sh
        #     fi
        #     if [[ -n "$*" ]]; then
        #         du $arg -- "$*"
        #     else
        #         du $arg .[^.]* ./*
        #     fi
        #     }
        # targz() {
        #     local tmpFile="${*%/}.tar"
        #     tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1
        #     size=$(
        #         stat -f"%z" "${tmpFile}" 2>/dev/null
        #         stat -c"%s" "${tmpFile}" 2>/dev/null
        #     )
        #     local cmd=""
        #     if ((size < 52428800)) && hash zopfli 2>/dev/null; then
        #         cmd="zopfli"
        #     else
        #         if hash pigz 2>/dev/null; then
        #             cmd="pigz"
        #         else
        #             cmd="gzip"
        #         fi
        #     fi
        #     echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`âŚ"
        #     "${cmd}" -v "${tmpFile}" || return 1
        #     [ -f "${tmpFile}" ] && rm "${tmpFile}"
        #     zippedSize=$(
        #         stat -f"%z" "${tmpFile}.gz" 2>/dev/null
        #         stat -c"%s" "${tmpFile}.gz" 2>/dev/null
        #     )
        #     echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
        #     }
        # tre() {
        #     tree -axC -I '.git|node_modules|bower_components' --dirsfirst "$@" -- | less -FRNX
        #     }
        # trw() {
        #     # TODO work in progress
        #     return 0
        #     # -     # trim leading and trailing whitespace
        #     #     local var="$*"
        #     #     var="${var#"${var%%[![:space:]]*}"}"
        #     #     var="${var#"${var&&[!'/']*}"}"
        #     #     var="${var%"${var##*[![:space:]]}"}"
        #     #     echo -n "$var"
        #     }
        # tt() {
        #     # alias treetop='tree -L 1'
        #     tree -L 1 -- "$@"
        #     }
        # tree_html() {
        #     tree -ahlsAFRHD --prune --du --si --dirsfirst >tree.html
        #     }
        # unpatch () {
        #   find . -name "*.orig" -o -name "*.rej"  -type f -exec rm {} \;
        #   find . -name "b" -type d -exec rm -rf {} \;
        #     }

        # py_realpath(){
        #     python3 -c "
        # from os.path import realpath
        # from sys import argv
        # for item in argv[1:]:
        #     print(f'{item} \'{realpath(item)}\'')
        # " "$@"
        #     }

        # shell () {
        #   # an odd alternative to using the $SHELL variable
        #   ps | grep "^$$" | awk '{ print $4 }' | cut -d '-' -f 2
        #     }
        # unegg () {
        #     unzip "$1" -d tmp || return
        #     rm "$1"
        #     mv tmp "$1"
        #     }
        # hardlink_dotfiles(){
        #     -  convert symlinks to hardlinks
        #     ls "$HOME/.dotfiles" -A | perl -nle 'print if -l and not -d;'

        #     while IFS="" read -r f || [ -n "$f" ]
        #     do
        #         f=
        #         printf '%s\n' "$p"
        #         unlink ""
        #         ln "$HOME/.dotfiles/$p" "$HOME"
        #     done < lsln.txt
        # }
        # ind() {
        #     lime Indirect Variable Tests

        #     value of

        #     me "echo tests"
        #     br
        #     # shellcheck disable=SC2016,SC2086
        #     ce '  var name (\$1):'"\t\t"            \$$1
        #     # shellcheck disable=SC2016,SC2086
        #     ce '  printf "$1":'"\t\t"           "$1"
        #     # shellcheck disable=SC2016,SC2086
        #     ce "  printf '\$1':""\t\t"          '$1'
        #     # shellcheck disable=SC2016,SC2086
        #     ce '  printf \$1:'"\t\t"         \$$1
        #     # shellcheck disable=SC2016,SC2086
        #     ce '  printf "\$$1":'"\t"       "\$$1"
        #     br
        #     me "eval tests"
        #     br
        #     # shellcheck disable=SC2016,SC2086
        #     attn '  printf $1:'"\t\t"
        #     # shellcheck disable=SC2016,SC2086
        #     eval echo -e $1
        #     # shellcheck disable=SC2016,SC2086
        #     attn '  printf "$1":'"\t"
        #     eval echo -e "$1"
        #     attn "  printf '\$1':""\t"
        #     eval echo -e '$1'
        #     # shellcheck disable=SC2016,SC2086
        #     attn '  printf \$1:'"\t\t"
        #     # shellcheck disable=SC2016,SC2086
        #     eval echo -e \$$1
        #     # shellcheck disable=SC2016,SC2086
        #     attn '  printf "\$$1":'"\t"
        #     eval echo -e "\$$1"
        #     }

        # time_script() {
        #     count=${1:-2}
        #     shift
        #     _t0=$(date +%s%3N)
        #     _t1=_t0
        #     for file_name in $@; do
        #         printf "  ${WARN}line${MAIN} (ms) / ${WARN}cummulative${MAIN} - code  (averaging $count trials)\n" 'line'
        #         printf "-------------------------------------------------------------\n"
        #         while read -r _line; do
        #             # process code here ...
        #             for ((i = 0 ; i <= count ; i++)); do
        #                 eval $_line &>/dev/null     # process code line
        #             done
        #             _tn=$(date +%s%3N)      # get time data
        #             _tt=$((_tn-_t1))       # time in this step
        #             _t21=$((_tt / count))
        #             _dt=$((_tn-_t0))        # time elapsed since start
        #             printf "${WARN}%8d${MAIN} ms / ${WARN}%8d${MAIN} ms - ${_line}\n" _t21 _dt
        #             _t1=$_tn
        #         done < $file_name
        #     done
        #     }
        # time_it() {
        #     _t0=$(date +%s%3N)
        #     # process code here ...
        #     eval "$@" #! this is stupid and dangerous

        #     _t1=$(date +%s%3N)
        #     _dt=$((_t1-_t0))
        #     printf "${MAIN}Code block took ${WARN}%.1f${MAIN}s to run.\n" $_dt
        #     }
