#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034

  # number of years the first commercial
  #   modem would take to transmit a movie: 42.251651342415241
  #   this is very nearly the time since I wrote my first program
  #   I'm glad I didn't watch that movie instead ...

#? -----------------------------> Shell Settings
    # Remove all aliases from unexpected places
    unalias -a
    SOURCE_TRACE
    # use root defaults (they match most web server defaults)
    umask 022   #          !! possible security issue !!

    # By default, zsh does not do word splitting for unquoted parameter
        # expansions. You can enable "normal" word splitting by setting the
        # SH_WORD_SPLIT option or by using the = flag on an individual expansion.
        # e.g. ls ${=args}

	if [[ "${SHELL##*/}" == 'zsh' ]]; then

        # 'SH style' word splitting
        setopt SH_WORD_SPLIT

        # Emulate some form of compatibility
        BASH_SOURCE="${(%):-%N}"
    else

        # as a last resort, just use $0
        BASH_SOURCE="${BASH_SOURCE:=$0}"
    fi

    # ANSI colors and cli functions
    . $(which ssm) >/dev/null 2>&1 || . ${ZDOTDIR:-~/.dotfiles}/zshrc_inc/ansi_colors.sh

#? -----------------------------> debug (Dev / Production modes)
    # SET_DEBUG is set to zero for production mode
    # SET_DEBUG is set to non-zero for dev mode
    #   1 - Show debug info and log to $LOGFILE
    #   2 - #1 plus trace and run specific tests
    #   3 - #2 plus display and log everything

    declare -ix SET_DEBUG=1 # ${SET_DEBUG:-0}

    dbecho "SET_DEBUG: $SET_DEBUG" #! debug
    if (( SET_DEBUG>0 )); then
        printf '%b\n' "${WARN:-}Debug Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "DEV mode ($SET_DEBUG) activated"
        # trap 'echo "# $(realpath $0) (line $LINENO) Error Trapped: $?"' ERR
        trap 'echo "# $0: Exit with code: $?"' EXIT
    fi
    if (( SET_DEBUG>1 )); then
        printf '%b\n' "${WARN:-}Debug Test Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TEST mode ($SET_DEBUG) activated"
        setopt SOURCE_TRACE
        trap 'echo "# $0: Line Number: $LINENO"' DEBUG
    fi
    if (( SET_DEBUG>2 )); then
        printf '%b\n' "${WARN:-}Debug Trace Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TRACE mode ($SET_DEBUG) activated"
        setopt XTRACE # VERBOSE
    fi


function noyes() {
    read "a?$1 [y/N] "
    if [[ $a == "N" || $a == "n" || $a = "" ]]; then
        return 0
    fi
    return 1
}

function breather() {
    local stuff
    read "stuff?${1:-'Continue? '} [Enter] "
    return 0
}
#? -----------------------------> user and paths
    # Apple User Identification Reference:
        # https://developer.apple.com/library/archive/qa/qa1133/_index.html

        # Warning: The System Configuration framework mechanism for determining the
        # current console user has a number of important caveats:

        # - It assumes that the computer has a single GUI console. While that's true
        #   currently, it may not be true forever. If you use this technique you
        #   will have to change your code if this situation changes.
        # - It has no way of indicating that multiple users are logged in.
        # - It has no way of indicating that a user is logged in but has switched to
        #   the login window.

        # See 'Design Considerations' of Apple Daemons and Agents Technotes:
        # https://developer.apple.com/library/archive/technotes/tn2083/_index.html

        # Ref: https://erikberglund.github.io/2018/Get-the-currently-logged-in-user,-in-Bash/

    # UserID of currently logged in user
    loggedInUserID="$( scutil <<< "show State:/Users/ConsoleUser"  | awk '/UID : / && ! /loginwindow/ { print $3 }' )"

    # Username of currently logged in user
    loggedInUser="$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"

    # Current Hostname
    HostName="$( scutil --get LocalHostName )"

    # HomeBrew path prefix (manually set - auto is slow)
    BREW_PREFIX=/usr/local      # BREW_PREFIX=$(brew --prefix)  #! too slow...

    # Path to oh-my-zsh configuration.
    ZSH=$HOME/.dotfiles/.oh-my-zsh

    # Path to ZSH dotfiles directory
    ZDOTDIR=$HOME/.dotfiles

    # Older dotfiles path directory (for compatibility)
    DOTFILES_PATH=$ZDOTDIR

    # Path to include files
    DOTFILES_INC=${ZDOTDIR}/zshrc_inc

    # setup system $PATH (and $MANPATH)
    . ${DOTFILES_INC}/zsh_set_path.sh

#? -----------------------------> source utilities
    .() { # source with debugging info and file read check
        source "$1"
        if (( $? )); then
            dbecho "ERROR: cannot source ${1##*/}"
        else
            (( SET_DEBUG )) && blue "SUCCESS: source ${1##*/}"
        fi
        }
    source_dir() { # 'source' all files in directories
        # echo "$(find . -type f -print | sort -f)"
        for f in $(find "$@" -type f -print; ); do
        # for f in "$(find "$@" -type f -print | sort -f)"; do
            [[ -r "$f" ]] && . "$f"
        done;
        }

#? -----------------------------> script timers
    ms() { printf '%i\n' "$(( $(gdate +%s%N) * 0.001 ))"; } # microseconds
    t0=$(ms) # initial timer mark
    lap() { # time milliseconds since last 'lap' call
        if [[ $1 = 'reset' ]]; then
            # reset the lap timer initial value
            t0=$(ms)
            return 0
        else
            t1=$(ms)
            dt=$(( t1 - t0 ))
            t0=$(ms)
            printf '%i\n' "$dt"
        fi
        }
    lap_ms() { printf '%i\n' "$(( $(lap) / 1000 ))"; }
    lap_sec() { printf '%i\n' "$(( $(lap) / 1000000 ))"; }

    timer_test(){
        blue "timer_test - test timer functions"
        blue "Increasing time delays are measured and posted."
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
#? -----------------------------> timer in CLI prompt
    # function preexec() { pre_timer=$(ms); }
    # function precmd() {
    #     if [ $timer ]; then
    #         elapsed=$(($(ms)-$pre_timer))

    #         RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
    #         unset timer
    #     fi
    #     }

#? -----------------------------> load profile settingss

    if [ -x dircolors ]; then
        eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.ansi-dark`
    fi

    # tokens and password functions
    . "${DOTFILES_INC}/.tokens_private.sh"

    # setup shell logging
    # todo - wip ... still some work to do ...
    # . "${DOTFILES_INC}/zsh_logging.zsh"

    # zsh gpg setup
    . "${DOTFILES_INC}/zshrc_gpg.zsh"

    # git functions and options
    . "${DOTFILES_INC}/func_git.zsh"

    # ansi colors and formatting
    . "${DOTFILES_INC}/ansi_colors.sh"

    # zsh shell aliases
    . "${DOTFILES_INC}/a_directories.zsh"
    . "${DOTFILES_INC}/a_init.zsh"
    . "${DOTFILES_INC}/a_network.zsh"

    # zsh environment variable exports
    . "${DOTFILES_INC}/zshrc_exports.zsh"

    # zsh functions and options
    . "${DOTFILES_INC}/func_sys.zsh"
    . "${DOTFILES_INC}/zsh_big_sur_hacks.zsh"
    . "${DOTFILES_INC}/func_tasks.zsh"

    # python settings and utilities
    . "${DOTFILES_INC}/zshrc_python.zsh"

    # set zsh and OMZ options
    . "${DOTFILES_INC}/zsh_options.zsh"
    . "${DOTFILES_INC}/omz_plugins.zsh"
    . "${DOTFILES_INC}/zsh_modules.zsh"

#? -----------------------------> per host config
    # per-host
    # _HOSTNAME=$(hostname)
    # HOSTRC="~/.dotfiles/zshrc.${_HOSTNAME}"
    # if [ -r "$HOSTRC" ]; then
    #     source "$HOSTRC"
    # fi
    # if [ -r ~/.zshrc.host ]; then
    #     source ~/.zshrc.host
    # fi

#? -----------------------------> load OMZ!
    # OMZ config
    DISABLE_AUTO_TITLE="true"
	CASE_SENSITIVE="false"
	COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    ENABLE_CORRECTION="true"
    DISABLE_MAGIC_FUNCTIONS="true"
    ZSH_THEME="spaceship"
	# ZSH_THEME="robbyrussell"

    . "$ZSH/oh-my-zsh.sh"

#? -----------------------------> odds and ends
    # common shell config
    # if [ -r ~/.commonshrc ]; then
    #     source ~/.commonshrc
    # fi

    # export FPATH="$HOME/.dotfiles/docked-node/zfuncs:$FPATH"
    # autoload docked-node

    # Helper to lookup commands from the zsh git plugin cheatsheet
    function gx () {
        `fzf < ~/.dotfiles/zsh-git-plugin-cheatsheet.txt | cut -f3 -d'|' | tr _ ' '`
    }

    # reset the colorflag ... it seems to get lost somewhere ...
    # alias ls="ls --color=tty --group-directories-first"
    # colorflag="--color=tty"
    # alias ls="ls $colorflag --group-directories-first"

#? -----------------------------> important utilities
    # test -e "${HOME}/.iterm2_shell_integration.zsh" && . "${HOME}/.iterm2_shell_integration.zsh"

    # The next line updates PATH for the Google Cloud SDK.
    # if [ -r ~/apps/google-cloud-sdk/path.zsh.inc ]; then . ~/apps/google-cloud-sdk/path.zsh.inc; fi

    # The next line enables shell command completion for gcloud.
    # if [ -r ~/apps/google-cloud-sdk/completion.zsh.inc ]; then . ~/apps/google-cloud-sdk/completion.zsh.inc; fi

#? -----------------------------> script cleanup
    # cleanup and exit script
    echo ''

    # calculate and display script time
    printf "${GREEN:-}Script ${SCRIPT_NAME} took ${BOLD:-}${ATTN:-}$(lap_ms)${RESET:-}${GREEN:-} ms to load.${RESET:-}\n\n"


#? -----------------------------> zsh notes
    # ALL_EXPORT (-a, ksh: -a)
    # All parameters subsequently defined are automatically exported.
    # GLOBAL_EXPORT (<Z>)
    # If this option is set, passing the -x flag to the builtins declare, float,
    # integer, readonly and typeset (but not local) will also set the -g flag; hence
    # parameters exported to the environment will not be made local to the enclosing
    # function, unless they were already or the flag +g is given explicitly. If the
    # option is unset, exported parameters will be made local in just the same way
    # as any other parameter. This option is set by default for backward
    # compatibility; it is not recommended that its behaviour be relied upon. Note
    # that the builtin export always sets both the -x and -g flags, and hence its
    # effect extends beyond the scope of the enclosing function; this is the most
    # portable way to achieve this behaviour.

    # default shell to handle /bin/sh shebangs reference:
    # https://scriptingosx.com/2019/06/moving-to-zsh/
    # As Apple’s support article mentions, Catalina also adds a new mechanism for
    # users and admins to change which shell handles sh invocations. MacAdmins or
    # users can change the symbolic link stored in /var/select/sh to point to a
    # shell other than /bin/bash. This changes which shell interprets scripts the
    # #!/bin/sh shebang or scripts invoked with sh -c. Changing the interpreter for
    # sh should not, but may change the behavior of several crucial scripts in the
    # system, management tools, and in installers, but may be very useful for
    # testing purposes.

#? -----------------------------> END OF .ZSHRC
