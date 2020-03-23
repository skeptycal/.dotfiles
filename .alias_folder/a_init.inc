# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

#? ############################# skeptycal.com
    # [[ $SET_DEBUG ]] && SET_DEBUG=0 # set to 1 for verbose testing
    BASH_SOURCE="${BASH_SOURCE:-$0}" # to ease the transition to zsh
    export CLICOLOR=1
    export colorflag='--color=auto' # I use GNU core_utils; no need to test '-G'

    # Use NeoVim if available
    if type "nvim" >/dev/null; then
    alias vim=nvim
    fi


    alias blog="cd ~/Work/blog && code ."

#? ############################# handy stuff
    alias cls='clear'   # because 40 year old habits die hard
    alias dir='ls'      # and I'm stubborn
    alias del="rm -rf"   #! delete all the things now! (!CAREFUL!)
    alias reload="exec ${SHELL} -l"
    # alias path='echo -e ${PATH//:/\\n}'
    alias nis="npm install --save "
    alias cgr="composer global require"
    alias mv='nocorrect mv'       # no spelling correction on mv
    alias cp='nocorrect cp'       # no spelling correction on cp
    alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
    alias git="git-achievements"
    alias mine="sudo chown -R $(id -un):$(id -gn) "
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


