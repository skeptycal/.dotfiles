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
		if (( SET_DEBUG )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
            green $(which whichmac)
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

# *############################################## curl for useragents
    alias iecurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)\""
    alias ffcurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.0 (.NET CLR 3.5.30729)\""

# *############################################## macOS settings
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
    alias whichmac="uname -a"

# *############################################## network
    # alias watch="nodemon -L ~/Documents/sites"
    alias flush="sudo dscacheutil -flushcache && killall -HUP mDNSResponder"
    alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
    alias localip="ipconfig getifaddr en0"

    # declare -g method
    # for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
        # shellcheck disable=2139
    #     alias "${method}=lwp-request -m '${method}' "
    # done
    # unset method

    # alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
    # alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# *############################################## Applications
    alias mergepdf="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py"
    # alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
    alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
    # declare -g jscbin='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
    # [ -e "${jscbin}" ] && alias jsc="${jscbin}"
    # unset jscbin

_debug_tests
true
