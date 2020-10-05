#? -----------------------------> ZSH modules

    # if type brew &>/dev/null; then
    #     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    #     autoload -Uz compinit
    #     compinit
    # fi

    # . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # zsh module descriptions:
    # http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html

    ############################################################
    # Autoload zsh modules when they are referenced
    # Standard scientific functions for use in mathematical evaluations.
    zmodload zsh/mathfunc

    # A builtin command interface to the stat system call.
    zmodload -a zsh/stat stat

    # A builtin for starting a command in a pseudo-terminal.
    zmodload -a zsh/zpty zpty

    # A module allowing profiling for shell functions.
    zmodload -a zsh/zprof zprof

    # Access to external files via a special associative array.
    zmodload -a zsh/mapfile mapfile

    ############################################################
    # key bindings
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search # Up
    bindkey "^[[B" down-line-or-beginning-search # Down

    # SHIFT-TAB
    bindkey '^[[Z' reverse-menu-complete

    zstyle ':completion:*' menu select
    fpath+="$HOME/.zfunc"

	autoload -Uz compinit && compinit
