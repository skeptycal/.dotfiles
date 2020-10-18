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
	cat <<-EOF
PATH(1)                            March 2020                          PATH(1)



$(red_wrap NAME)
	path - list PATH elements

$(red_wrap SYNOPSIS)
	path [$(lime_wrap OPTION)]...

$(red_wrap DESCRIPTION)
	List  information  about  the  current PATH elements.
	The defaults are:

	- use color if available
	- use the colon ':' as the initial delimiterr
	- use NEWLINE '\n' as the new delimiter
	- print the entire path names

	Mandatory arguments to long options are mandatory for short options too.

	$(red_wrap -c), $(red_wrap --color ) $(lime_wrap WHEN)
			  colorize  the  output; WHEN can be 'auto' (default if omitted),
			  'always', or 'never'

	$(red_wrap -d), $(red_wrap --delimiter ) $(lime_wrap DELIM)
		specify the initial delimiter (default = ':')

	$(red_wrap -n), $(red_wrap --new ) $(lime_wrap NEW)
		specify the new delimiter (default = '\n')

	$(red_wrap -w, --width) $(lime_wrap COLS)
		limit the max width of path names to COLS; 0 = unlimited

	$(red_wrap --help) display this help and exit

	$(red_wrap --version)
		output version information and exit

$(red_wrap Exit status:)
	   0      if OK,

	   1      if minor problems (e.g., cannot access subdirectory),

	   2      if serious trouble (e.g., cannot access command-line argument).

$(red_wrap AUTHOR)
	Written by Michael Treanor.

$(red_wrap REPORTING BUGS)
	path online help: <https://www.github.com/skeptycal/path>

$(red_wrap COPYRIGHT)
	Copyright  (C)  2020 Michael Treanor
	License: MIT <https://opensource.org/licenses/MIT>
	This is free software: you are  free  to  change  and  redistribute  it.
	There is NO WARRANTY, to the extent permitted by law.

$(red_wrap SEE ALSO)
	   Full documentation <https://www.github.com/skeptycal/path>



PATH(1)                            March 2020                          PATH(1)
EOF
}

#? ######################## PATH
# expand path with newlines
# single quotes force expansionn of PATH at use time instead of creation time
alias npath='echo ${PATH//:/\\n}'

function red_wrap() { echo "${RED:-}$@${RESET:-}"; }
function lime_wrap { echo "${LIME:-}$@${RESET:-}"; }
function path() { # just messing around ... color coded path list
    setopt SH_WORD_SPLIT
    local version='0.1.0'
    NL=$(print $'\n')

    local path_color=
    local path_old=
    local path_new=
    declare -i path_width=0

    while (( $# > 1 )); do
        case $1 in
            -h|--help)
                path_usage
                return 0
            ;;
            -v|--version)
                lime "path${RESET:=} version ${ORANGE:-}$version"
                return 0
            ;;
            -c,--color)
                shift
                path_color=${1:='auto'}
                shift
            ;;
            -d,--delimiter)
                shift
                path_old=${1:=':'}
                shift
            ;;
            -n|--new)
                shift
                path_new=${1:="$NL"}
                shift
            ;;
            -w|--width)
                shift
                [[ $1 -gt 0 ]] && path_width=${1:=0} || path_width=0
            ;;
            *)
                shift
            ;;
        esac
    done

    path_color=${path_color:-'auto'}
    path_old=${path_old:-':'}
    path_new=${path_new:-$NL}
    path_width=${path_width:-0}
    # path_ifs=${path_new[0]}
    path_ifs=${path_new:0}

    blue $path_ifs

    PATH_OUT=${PATH//"${path_old}"/"${path_new}"}
    PATH_OUT=${PATH//${path_old:-':'}/${path_ifs:-\\n}};

    blue $PATH_OUT

    IFS="${path_ifs}"
    for p in $PATH_OUT; do
        echo $p
        # [ -h $p ] && ce "${CYAN:-}$p"
        [ -d $p ] && lime $p || attn $p
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

declare -x PATH="\
/usr/local/opt/libxml2/bin:\
/usr/local/opt/libxml2/lib:\
$HOME/bin:\
/usr/local/go/bin:\
/usr/local/Cellar/python@3.8/3.8.6/Frameworks/Python.framework/Versions/3.8/bin:\
/Library/Frameworks/Python.framework/Versions/3.9/bin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/bin:\
/usr/local/opt:\
$HOME/.dotfiles/.oh-my-zsh:\
$HOME/.poetry/bin:\
/usr/local/opt/ruby/bin:\
/usr/local/opt/cython/bin:\
/bin:\
/usr/local:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/sbin:\
/usr/libexec:\
/usr/local/opt/sphinx-doc/bin:\
/Library/Apple/usr/bin:\
$HOME/.dotfiles:\
$HOME/.dotfiles/git-achievements:"
# '$PWD'

PATH="${PATH// /}" # remove spaces ... before adding VSCode path ...
PATH="${PATH//\\t/}" # remove spaces ... before adding VSCode path ...

# TODO - this has caused some odd problems ... I'm not sure why this helped ...
# vscode is kinda odd sometimes ... sometimes with spaces, sometimes not ???
#   so ... I'm putting the 'space remover' before it ...
# PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin:"
PATH=$PATH'/Applications/Visual Studio Code.app/Contents/Resources/app/bin:'

PATH="${PATH//::/:}" # remove double colons ... you know you've done it, too

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
MANPATH="${MANPATH// /}"
MANPATH="${MANPATH//\t/}"

export MANPATH

export INFOPATH="/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH"
