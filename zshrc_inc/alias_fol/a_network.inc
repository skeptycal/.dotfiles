#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

    set -a

# *############################################## php
alias comp='php /Users/skeptycal/bin/utilities/php/composer.phar '

#- ################################
# - utilities from https://justin.abrah.ms/dotfiles/zsh.html

# curl for useragents
    alias iecurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)\""
    alias ffcurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.0 (.NET CLR 3.5.30729)\""

# *############################################## macOS settings
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
    alias whichmac="uname -a"

# *############################################## network
    alias watch="nodemon -L ~/Documents/sites"
    alias flush="sudo dscacheutil -flushcache && killall -HUP mDNSResponder"
    alias localip="ipconfig getifaddr en0"
    declare -g method
    for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
        # shellcheck disable=2139
        alias "${method}=lwp-request -m '${method}' "
    done
    unset method
    alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
    alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
    alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# *############################################## Applications
    alias mergepdf="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py"
    # alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
    alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
    declare -g jscbin='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
    [ -e "${jscbin}" ] && alias jsc="${jscbin}"
    unset jscbin
