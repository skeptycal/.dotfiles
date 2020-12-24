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
	set -a
	_debug_tests() {
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green $(which ls)
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

# *############################################## directories
    alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/"
    alias cdc="cd $HOME/local_coding"
    alias cdgo="cd ${GOPATH:-~/go}/src/github.com/skeptycal"

    alias cdw="cd $HOME/Documents/work"
    alias cdd="cd $HOME/Sites"
    alias cdb="cd $HOME/Dropbox"
    alias dl="cd $HOME/Downloads"
    alias dt="cd $HOME/Desktop"

    # alias ls="ls --group-directories-first ${colorflag}"           # normal wide
    alias lsd="ls -1Adh ${colorflag} -- */"                        # dirs only
    alias l.="ls -lhFAd .* --group-directories-first ${colorflag}" # dotfiles
    alias la="ls -lhFA --group-directories-first ${colorflag}"     # all files
    alias lag="ls -lhFAgG --group-directories-first ${colorflag}"  # la - no names
    alias ll="ls -lhF --group-directories-first ${colorflag}"      # normal list
    alias lw="ls -hF --group-directories-first ${colorflag}"       # detailed wide
    alias lsa="ls -lhFArt ${colorflag}"                            # sort by date
    alias lss="ls -lhFArs ${colorflag}"                            # sort by size

	# directory LS
    # lsd () { ls -la | grep "^d" | awk '{ print $9 }' | tr -d "/"; }

    alias ftree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
    alias filetree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

# *############################################## search, filter, list
    alias ducks='du -ck * | sort -rn | head -20'
    alias toomuch='du -sh ~'
    alias howmuch='du -sh '
    alias treetotal='tree | tail -1' # needs 'brew install tree'

    ff() { find "$PWD" -type f -name "$1"; }
    fd() { find "$PWD" -type d -name "$1"; }

# *############################################## utilities
    alias hs="history | grep "
    alias map="xargs -n1"
    alias sudo="sudo "
    alias trim="sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g'"
    alias mount="mount | column -t"

    # alias allopen="sudo lsof -i -P | grep" # used function instead ...

    alias egrep="egrep ${colorflag}"
    alias fgrep="fgrep ${colorflag}"
    alias plistbuddy="/usr/libexec/PlistBuddy"
    # command -v grunt >/dev/null && alias grunt="grunt --stack"
    # command -v hd >/dev/null || alias hd="hexdump -C"
    # command -v md5sum >/dev/null || alias md5sum="md5"
    # command -v sha1sum >/dev/null || alias sha1sum="shasum"

# *###########################################################################
    # change directories (these functions are included in oh-my-zsh)
    alias -- -="cd -"
    alias -- -='cd -'
    alias .....="cd ../../../.."
    alias ....="cd ../../.."
    alias ...="cd ../.."
    alias ..="cd .."
    alias 1='cd -'
    alias 2='cd -2'
    alias 3='cd -3'
    alias 4='cd -4'
    alias 5='cd -5'
    alias 6='cd -6'
    alias 7='cd -7'
    alias 8='cd -8'
    alias 9='cd -9'

_debug_tests
true
alias campoy='cd /Users/skeptycal/go/src/campoy'
