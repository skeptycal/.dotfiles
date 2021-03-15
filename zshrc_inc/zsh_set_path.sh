#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
 #* copyright (c) 2019 Michael Treanor     -----     MIT License
 #* should not be run directly; called from .bash_profile / .bashrc / .zshrc
 #? ###################### https://www.github.com/skeptycal ##################
 # SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing

#? ###################### copyright (c) 2019 Michael Treanor #################
# ?########################################## parameter expansion tips
 #? ${PATH//:/\\n}    - replace all colons with newlines
 #? ${PATH// /}       - strip all spaces
 #? ${VAR##*/}        - return only final element in path (program name)
 #? ${VAR%/*}         - return only path (without program name)

functionn path_usage() {
	less <<EOF
PATH(1)                           March 2019                           PATH(1)


$(red_wrap NAME)
	$(lime_wrap path) - list \$PATH elements

$(red_wrap SYNOPSIS)
	${LIME:-}path ${GREEN:-}[--color WHEN] [--delimiter DELIM] [--new NEW] [--width COLS]${RESET:-}

$(red_wrap DESCRIPTION)
	List information about the current \$PATH elements.

	The defaults are:
		- use color if available
		- use the colon ':' as the initial delimiterr
		- use NEWLINE '\n' as the new delimiter
		- print the entire path names

	Mandatory arguments to long options are mandatory for short options too.

	$(red_wrap -c, --color ) $(lime_wrap WHEN)
		colorize  the  output; WHEN can be 'auto', 'always', or 'never'
					(default is 'auto')

	$(red_wrap -d, --delimiter ) $(lime_wrap DELIM)
		specify the initial delimiter
					(default = ':')

	$(red_wrap -n, --new ) $(lime_wrap NEW)
		specify the new delimiter
					(default = '\n')

	$(red_wrap -w, --width) $(lime_wrap COLS)
		limit the max width of path names to COLS; 0 = unlimited
					(default is 0 - unlimited)

	$(red_wrap --help) display this help and exit

	$(red_wrap --version)
		output version information and exit

$(red_wrap Exit status:)
	0      if OK,
	1      if minor problems (e.g., cannot access subdirectory),
	2      if serious trouble (e.g., cannot access command-line argument).

$(red_wrap AUTHOR)
	Written by Michael Treanor <skeptycal@gmail.com>.

$(red_wrap REPORTING BUGS)
	path online help: <https://www.github.com/skeptycal/path>

$(red_wrap LICENSE)

	Copyright  (C)  2019 Michael Treanor

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
	THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

PATH(1)                           March 2019                           PATH(1)
EOF
}

#? ######################## PATH
# expand path with newlines
# single quotes force expansion of PATH at use time instead of creation time

alias npath='echo ${PATH//:/\\n}'

function red_wrap() { echo "${RED:-}$@${RESET:-}"; }
function lime_wrap { echo "${LIME:-}$@${RESET:-}"; }
function path() { # just messing around ... color coded path list
	setopt SH_WORD_SPLIT
	local version='0.3.0'
	NL=$(print $'\n')

	local path_color='auto'
	local path_old=':'
	local path_new=$'\n'
	declare -i path_width=0

	# echo "\$#: $#"

	while (( $# > 0 )); do
		case $1 in
			-h|--help)
				path_usage
				return 0
			;;
			-v|--version)
				lime "path${RESET:-} version ${ORANGE:-}$version"
				return 0
			;;
			-c|--color)
				shift
				path_color=${1:-'auto'}
				shift
			;;
			-d|--delimiter)
				shift
				path_old=${1:-':'}
				shift
			;;
			-n|--new)
				shift
				path_new=${1:-"$NL"}
				shift
			;;
			-w|--width)
				shift
				[[ "$1" -gt 0 ]] && path_width=${1:-0} || path_width=0
			;;
			*)
				shift
			;;
		esac
	done

	PATH_OUT=${PATH//$path_old/$path_new}

	IFS=${path_new}
	for p in ${PATH_OUT[*]}; do
		if [ -h $p ]; then
			ce "${CYAN:-}$p"
		elif [ -d $p ]; then
			lime $p
		else
			attn $p
		fi
	done
	IFS=
	}
# list path elements with color coded (green is ok, orange is broken)
function checkpath() {
	IFS=':'
	for p in ${PATH[*]}; do
		[ -d $p ] && lime $p || attn $p
	done
	}

# /usr/local/lib/node_modules/bin:\
# /Library/Frameworks/Python.framework/Versions/3.9/bin:\

declare -x PATH="\
$GOPATH/bin:\
$HOME/bin:\
/usr/local/go/bin:\
/Library/Frameworks/Python.framework/Versions/Current/bin:\
/usr/local/opt/libxml2/bin:\
/usr/local/opt/libxml2/lib:\
/usr/local/MacGPG2/bin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/bin:\
/usr/local/opt:\
/usr/local:\
/usr/local/sbin:\
/bin:\
/usr/bin:\
/usr/sbin:\
/sbin:\
/usr/libexec:\
/usr/local/opt/sphinx-doc/bin:\
/Library/Apple/usr/bin:\
$HOME/.dotfiles/git-achievements:\
$ZDOTDIR:\
$ZSH:\
$DOTFILES_INC:"

# $PWD:

PATH=$(echo "${=PATH// /}")

PATH="${PATH// /}" # remove spaces ... before adding VSCode path ...
PATH="${PATH//::/:}" # remove double colons ... you know you've done it, too

export PATH
#? ######################## MANPATH
# /usr/local/opt/erlang/lib/erlang/man:\

declare -x MANPATH=" \
	/usr/local/man:\
	/usr/local/opt/coreutils/libexec/gnuman:\
	/usr/share/man:\
	/usr/local/share/man:\
	/Library/Frameworks/Python.framework/Versions/Current/share/man/man1:\
	/usr/local/texlive/2020/texmf-dist/doc/man:\
	"
MANPATH=$(echo "${=MANPATH// /}")
MANPATH="${MANPATH// /}"

export MANPATH

INFOPATH="/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH"
INFOPATH=$(echo "${=INFOPATH// /}")
INFOPATH="${INFOPATH// /}"
