#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ###################### copyright (c) 2019 Michael Treanor #################
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
	# I use GNU core_utils; no need to test '-G'
	export CLICOLOR=1
	export colorflag='--color=always'

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
		ATTN=$(printf '\033[38;5;178m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		CANARY=$(printf '\033[38;5;226m')
		CHERRY=$(printf '\033[38;5;124m')
		COOL=$(printf '\033[38;5;38m')
		CYAN=$(printf '\033[38;5;51m')
		DARKGREEN=$(printf '\033[38;5;28m')
		GREEN=$(printf '\033[32m')
		MAGENTA=$(printf '\033[38;5;201m')
		LIME=$(printf '\033[32;1m')
		MAIN=$(printf '\033[38;5;229m')
		ORANGE=$(printf '\033[38;5;202m')
		PURPLE=$(printf '\033[38;5;93m')
		RAIN=$(printf '\033[38;5;93m')
		RED=$(printf '\033[31m')
		WARN=$(printf '\033[38;5;203m')
		WHITE=$(printf '\033[37m')
		YELLOW=$(printf '\033[33m')
		RESTORE=$(printf '\033[0m\002')
		RESET1=$(printf '\033[m')

		# GIT colors
		WS="$(git config --get-color color.diff.whitespace "blue reverse")"
		RESET="$(git config --get-color "" "reset")"

		# Highlight the user name when logged in as root.
		if [[ "loggedInUserID" ]]; then
			userStyle="\${RED}"
		else
			user1Style="\${ATTN}"
		fi

		# color echo
		ce() { printf "%b\n" "${*:-}${RESET:-}" ; }
		# color echo with no reset or newline
		eprint() { printf "%b" "${*:-}" ; }
		me() { ce "${MAIN:-}${*:-}" ; }
		warn() { ce "${WARN:-}${*:-}" ; }
		blue() { ce "${COOL:-}${*:-}" ; }
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
	else
		NL=

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
		user1Style=
	fi

#? -----------------------------> color testing
	color_sample() {
		echo "${MAIN:-}C  ${WARN:-}O  ${COOL:-}L  ${LIME:-}O  ${GO:-}R  ${CHERRY:-}S  ${CANARY:-}A  ${ATTN:-}M  ${RAIN:-}P  ${WHITE:-}L  ${RESET:-}E"
		ce "${MAIN:-}MAIN  ${WARN:-}WARN  ${COOL:-}COOL  ${LIME:-}LIME  ${GO:-}GO  ${CHERRY:-}CHERRY  ${CANARY:-}CANARY  ${ATTN:-}ATTN  ${RAIN:-}RAIN  ${WHITE:-}WHITE  ${RESET:-}RESET";
		}

	color_test() {
		for i in {0..255}; do printf "\033[38;5;${i}m $i "; done;
		echo ''
		for i in {0..255}; do printf "\033[48;5;${i}m $i "; done;
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
