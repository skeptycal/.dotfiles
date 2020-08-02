#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

    set -a

#? ############################# initial aliases
    # Use NeoVim if available
    if type "nvim" >/dev/null; then
        alias vim=nvim
    fi
    alias git="git-achievements"
    alias mine="sudo chown -R \$(id -un):\$(id -gn) "

# TODO ########################################## works in progress
    # alias lsln='ls -AF | grep '@' | cut -d '@' -f 1 ' # will include directories

#? ############################# handy stuff
    alias cls='clear'   # because 40 year old habits die hard
    alias dir='ls'      # and I'm stubborn
    alias del="rm -rf"   #! delete all the things now! (!CAREFUL!)
    alias pwdcopy='pwd | pbcopy'
    alias reload="exec \${SHELL} -l"
    # alias path='echo -e ${PATH//:/\\n}'

    alias blog="cd ~/Work/blog && code ."
    alias auto="cd ~/Documents/coding/python/autosys && code ."
    alias nis="npm install --save "
    alias cgr="composer global require"
    # alias code="nocorrect code"

    # alias mv='nocorrect mv'       # no spelling correction on mv
    # alias cp='nocorrect cp'       # no spelling correction on cp
    # alias mkdir='nocorrect mkdir' # no spelling correction on mkdir

    alias ssh='ssh -R 10999:localhost:22'
    alias nethack='telnet nethack.alt.org'

#? ############################# CLICOLOR Details
    #   exfxcxdxbxegedabagacad
    #
    #       ls Attribute	Foreground color	Background color
    #       directory	            e	            x
    #       symbolic	            f	            x
    #       socket	                c	            x
    #       pipe	                d	            x
    #       executable              b	            x
    #       block	                e	            g
    #       character	            e	            d
    #       executable	            a	            b
    #       directory	            a	            c
    #       directory	            a	            d
