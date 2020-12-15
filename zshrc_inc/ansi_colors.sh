#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ###################### copyright (c) 2019 Michael Treanor #################
#? -----------------------------> table of contents ...
	#* timing functions available
		# ms, lap, lap_ms, lap_sec, lap_reset, timer_test, testdir

		# todo - make a script that puts a TOC at the end of the script and can print it out

	#* functions and constants available:
		# is_empty
		# exists
		# hr & br
		# CLICOLOR
		# TERM

	#* ANSI formatting styles
		# 		NORMAL, BOLD, DIM, ITALIC, UNDERLINE, REVERSED, STRIKEOUT

	#* ANSI foreground codes (use REVERSED for background)
		# 		ATTN, BLUE, GOLANG, CANARY, CHERRY, COOL, CYAN, DARKGREEN, DBLUE,
		#       GREEN, LIME, MAGENTA, MAIN, ORANGE, PINK, PURPLE, RAIN, RED,
		#       TANGERINE, WARN, WHITE, YELLOW, RESTORE, RESET1
		# 	   TRUE_COLOR & FALSE_COLOR

	#* functions for color terminal output
		# ce, eprint, me
		# warn, blue, cool, green, lime, cherry, canary, attn, purple, rain, white
		# dbecho, die

	#* color testing functions
		# color_sample, color_test, default_dircolors

#? -----------------------------> constants & utilities
	is_empty() { [ -z "$(ls -A $1)" ]; }
	exists() { command -v $1 > /dev/null 2>&1 ; }

#? -----------------------------> lines and borders
	NL='\n'

	DEFAULT_SCREEN_WIDTH=79
	BORDER_CHAR='*'

	# setup border template
	# reference: https://superuser.com/a/86353
	printf -v BORDER_TEMPLATE '%*s' $DEFAULT_SCREEN_WIDTH '';

	# yes, this is a fake <hr />
	hr() { printf '%s\n' ${BORDER_TEMPLATE// /${1:-$BORDER_CHAR}} }
	# yes, this is a fake <br />
	br() { printf $'\n'; }

	# todo - wip
	# side borders
	# sides() {
	# 	for line in ${*}; do
	# 		printf '|%b|\n' $line
	# 	done
	# }

#? -----------------------------> terminal setup
	export CLICOLOR=1

	# I use GNU core_utils; no need to test '-G'x
	# export colorflag='--color=always'

	# terminal identification
	if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
		declare -x TERM='gnome-256color';
	elif infocmp xterm-256color >/dev/null 2>&1; then
		declare -x TERM='xterm-256color';
	fi;

#? -----------------------------> ANSI colors
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		# commented codes are poorly supported
		# and generally not on ZSH

		# ANSI formatting styles
		NORMAL=$(printf '\033[0m')
		BOLD=$(printf '\033[1m')
		DIM=$(printf '\033[2m')
		ITALIC=$(printf '\033[3m')
		UNDERLINE=$(printf '\033[4m')
		REVERSED=$(printf '\033[7m')
		# CONCEAL=$(printf '\033[8m') # not available on macOS
		STRIKEOUT=$(printf '\033[9m')
		# FRAMED=$(printf '\033[51m') # not available on macOS
		# ENCIRCLED=$(printf '\033[52m') # not available on macOS
		# OVERLINED=$(printf '\033[53m') # not available on macOS

		# ANSI colors
		# BLUE=$(printf '\033[34m') # too dark
		ATTN=$(printf '\033[38;5;178m')
		BLUE=$(printf '\033[38;5;27m')
		GOLANG=$(printf '\033[38;5;51m')
		CANARY=$(printf '\033[38;5;226m')
		CHERRY=$(printf '\033[38;5;124m')
		COOL=$(printf '\033[38;5;27m')
		CYAN=$(printf '\033[38;5;51m')
		DARKGREEN=$(printf '\033[38;5;28m')
		DBLUE=$(printf '\033[38;5;20m')
		# GREEN=$(printf '\033[32m') # too bright ...
		# GREEN=$(printf '\033[38;5;22m') # too dim ...
		GREEN=$(printf '\033[38;5;46m') # too bright ...
		LIME=$(printf '\033[32;1m')
		MAGENTA=$(printf '\033[38;5;201m')
		MAIN=$(printf '\033[38;5;229m')
		ORANGE=$(printf '\033[38;5;208m')
		PINK=$(printf '\033[38;5;213m')
		PURPLE=$(printf '\033[38;5;93m')
		RAIN=$(printf '\033[38;5;93m')
		RED=$(printf '\033[31m')
		TANGERINE=$(printf '\033[38;5;202m')
		WARN=$(printf '\033[38;5;203m')
		WHITE=$(printf '\033[37m')
		YELLOW=$(printf '\033[33m')
		RESTORE=$(printf '\033[0m\002')
		RESET1=$(printf '\033[m')

		# GIT colors
		WS="$(git config --get-color color.diff.whitespace "blue reverse")"
		RESET="$(git config --get-color "" "reset")"

		# Highlight the user name when logged in as root.
		if [[ "$loggedInUserID" ]]; then
			userStyle="\${RED}"
		else
			userStyle="\${ATTN}"
		fi

	else
		NORMAL=
		BOLD=
		DIM=
		ITALIC=
		UNDERLINE=
		REVERSED=
		CONCEAL=
		STRIKEOUT=
		FRAMED=
		ENCIRCLED=
		OVERLINED=

		ATTN=
		BLUE=
		BOLD=
		CANARY=
		CHERRY=
		COOL=
		CYAN=
		DARKGREEN=
		GREEN=
		MAGENTA=
		LIME=
		MAIN=
		ORANGE=
		PURPLE=
		RAIN=
		RED=
		WARN=
		WHITE=
		YELLOW=
		RESTORE=
		RESET1=

		WS=
		RESET=
		userStyle=
	fi

	# color echo
	ce() { printf "%b\n" "${*:-}${RESET:-}" ; }
	# color echo with no reset or newline
	eprint() { printf "%b" "${*:-}" ; }
	me() { ce "${MAIN:-}${*:-}" ; }
	warn() { ce "${WARN:-}${*:-}" ; }
	blue() { ce "${BLUE:-}${*:-}" ; }
	cool() { ce "${COOL:-}${*:-}" ; }
	green() { ce "${DARKGREEN:-}${*:-}" ; }
	lime() { ce "${LIME:-}${*:-}" ; }
	cherry() { ce "${CHERRY:-}${*:-}" ; }
	canary() { ce "${CANARY:-}${*:-}" ; }
	attn() { ce "${ATTN:-}${*:-}" ; }
	purple() { ce "${PURPLE:-}${*:-}" ; }
	rain() { ce "${RAIN:-}${*:-}" ; }
	white() { ce "${WHITE:-}${*:-}" ; }

	dbecho(){ (( SET_DEBUG>0 )) && printf '%b\n' "${WARN:-}${REVERSED:-}${*}${RESET:-}"; }
	die() { dbecho ${*:-"die (pid = $$)"} && exit 1; }

	# todo - wip automatic coloring of output based on previous return code
	# colors used in tf color function
	TRUE_COLOR="$GREEN"
	FALSE_COLOR="$ATTN"

	# todo - not working ... probably because of variable scopes in functions?
	# colors output based on previous command
	# tfcolor() {
	# 	[ "$?" ] && ce "${TRUE_COLOR}$@"  || ce "${FALSE_COLOR}$@"
	# }
#? -----------------------------> color testing
	color_sample() {
		echo "${MAIN:-}C  ${WARN:-}O  ${COOL:-}L  ${LIME:-}O  ${GO:-}R  ${CHERRY:-}S  ${CANARY:-}A  ${ATTN:-}M  ${RAIN:-}P  ${WHITE:-}L  ${RESET:-}E"
		ce "${MAIN:-}MAIN  ${WARN:-}WARN  ${COOL:-}COOL  ${LIME:-}LIME  ${GO:-}GO  ${CHERRY:-}CHERRY  ${CANARY:-}CANARY  ${ATTN:-}ATTN  ${RAIN:-}RAIN  ${WHITE:-}WHITE  ${RESET:-}RESET";
		}

	color_test() {
		(( color_width = int($COLUMNS / 4) ))
		for j in {3..4}; do
			for i in {0..255};
				do printf '%b%03s ' "\033[${j}8;5;${i}m" "$i";
				(( (i+1) % color_width )) || echo "$RESET"
			done;
			echo "$RESET"
			br
			br
		done;
		# echo ''
		# for i in {0..255};
		# 	do printf '%b%03d ' "\033[48;5;${i}m" "$i";
		# 	do printf "\033[48;5;${i}m $i ";
		# 	(( (i+1) % color_width )) || echo $RESET
		# done;
		}

	default_dircolors() {cat <<- EOF
		${BLUE}Blue:${RESET} Directory
		${GREEN}Green:${RESET} Executable or recognized data file
		${CYAN}Cyan (Sky Blue):${RESET} Symbolic link file
		${LIME}${REVERSED} Green Reversed: Unsecured file (all permissions)
		${YELLOW}Yellow with black background:${RESET} Device
		${MAGENTA}${REVERSED}Magenta (Pink):${RESET} Graphic image file
		${RED}${REVERSED}Red:${RESET} Archive file
		${RED}Red with black background:${RESET} Broken link
		EOF
	}
#? -----------------------------> script timers
    ms() { printf '%i\n' "$(( $(gdate +%s%N) * 0.001 ))"; } # microseconds
    t0=$(ms) # initial timer mark
    lap() { # time milliseconds since last 'lap' call
        t1=$(ms)
        dt=$(( t1 - t0 ))
        t0="$t1"
        printf '%i\n' "$dt"
        }
    lap_ms() { printf '%i\n' "$(( $(lap) / 1000 ))"; }
    lap_sec() { printf '%i\n' "$(( $(lap) / 1000000 ))"; }
    lap_reset() { t0=$(ms); }
    lap_reset

    timer_test(){
        blue "timer_test - test timer functions"
        blue "  time delays are measured and posted with different levels of precision."
        blue "Press <ctrl>-C to end the timer test early..."
        t0=$(ms)
        for i in {1..10}; do
            sleep 1
            green "Assigned time: ${i}       actual time: $(lap) µs."
            t0=$(ms)
        done;
        for i in {1..10}; do
            sleep 1
            green "Assigned time: ${i}       actual time: $(lap_ms) ms."
            t0=$(ms)
        done;
        for i in {1..10}; do
            sleep 1
            green "Assigned time: ${i}       actual time: $(lap_sec) s."
            t0=$(ms)
        done;
    }
    testdir () {
        if (( $# > 0 )); then
            count="$1"
            shift
        else
            count=1000
        fi
        echo "count: $count"

        if (( $# > 0 )); then
            args="$@"
        else
            args="ls >/dev/null"
        fi
        echo "args: $args"

        $(lap_reset) # reset timer

        #stuff to time ...
        for i in {1..$count}
            do eval "$args"
        done

        printf "${GREEN:-}Script took ${BOLD:-}${ATTN:-}$(lap)${RESET:-}${GREEN:-} µs to run.${RESET:-}\n\n"
    }
