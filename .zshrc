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

    # use root defaults (they match most web server defaults)
    umask 022   #          !! possible security issue !!

    set -a        # export all (zsh default)

    # By default, zsh does not do word splitting for unquoted parameter
        # expansions. You can enable "normal" word splitting by setting the
        # SH_WORD_SPLIT option or by using the = flag on an individual expansion.
        # e.g. ls ${=args}

	if [[ "${SHELL##*/}" == 'zsh' ]]; then

        # Allow comments even in interactive shells.
    	setopt interactivecomments

        # 'BASH style' word splitting
        setopt SH_WORD_SPLIT

        # Emulate some form of compatibility
        BASH_SOURCE="${(%):-%N}"
    else

        # as a last resort, just use $0
        BASH_SOURCE="${BASH_SOURCE:=$0}"
    fi

#? -----------------------------> constants
    # ANSI colors and cli functions
    . ~/bin/ssm || . ${ZDOTDIR:-~/.dotfiles}/zshrc_inc_manual/ansi_colors.sh

    # SET_DEBUG is set to zero for production mode
    # SET_DEBUG is set to non-zero for dev mode
    #   1 - Show debug info and log to $LOGFILE
    #   2 - #1 plus run specific tests
    #   3 - #2 plus display and log everything

    declare -ix SET_DEBUG=0 # ${SET_DEBUG:-0}

    lime "SET_DEBUG: $SET_DEBUG"
    if (( SET_DEBUG>0 )); then
        printf '%b\n' "${WARN:-}Debug Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "DEV mode ($SET_DEBUG) activated"
        # trap 'echo "# $(realpath $0) (line $LINENO) Error Trapped: $?" >>~./.bootlog.log' ERR
        trap 'echo "# $0: Exit with code: $?"' EXIT
    fi
    if (( SET_DEBUG>1 )); then
        printf '%b\n' "${WARN:-}Debug Test Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TEST mode ($SET_DEBUG) activated"
        setopt SOURCE_TRACE
        # trap 'echo "# $0: Line Number: $LINENO"' DEBUG
    fi
    if (( SET_DEBUG>2 )); then
        printf '%b\n' "${WARN:-}Debug Trace Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TRACE mode ($SET_DEBUG) activated"
        setopt XTRACE
    fi

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

    # Path to files that are automatically sourced
    DOTFILES_INC=${ZDOTDIR}/zshrc_inc

    # Path to other files that are available to source
    DOTFILES_INC_MANUAL=${ZDOTDIR}/zshrc_inc_manual

    # setup system $PATH (and $MANPATH)
    . ${DOTFILES_INC_MANUAL}/zsh_set_path.sh

#? -----------------------------> utilities
    .() { # source with debugging info and file read check
        source "$1"
        if (( $? )); then
            dbecho "ERROR: cannot source ${1##*/}"
        else
            (( SET_DEBUG )) && blue "SUCCESS: source ${1##*/}"
        fi
        }
    source_dir() { # 'source' all files in directories
        for f in $(find "$@" -type f -print; ); do
            [[ -r "$f" ]] && . "$f"
        done;
        }

#? -----------------------------> script timers
    ms() { printf '%i\n' "$(( $(gdate +%s%0N)/1000000 ))" }
    t0=$(ms)
    lap() {
        # report time (ns) since last 'lap' call
        dt=$(( $(ms) - t0 ))
        t0=$(ms)
        printf '%i\n' "$dt"
        }
    lap_ms() { printf '%i\n' "$(( $(lap)/1000000 ))"; } # report time (ms) since last 'lap' call
    lap_sec() { printf '%i\n' "$(( $(lap)/1000000000 ))"; } # report time (s) since last 'lap' call

#? -----------------------------> timer in CLI prompt
    # function preexec() { timer=$(ms); }
    # function precmd() {
    #     if [ $timer ]; then
    #         elapsed=$(($(ms)-$timer))

    #         RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
    #         unset timer
    #     fi
    #     }
#? -----------------------------> logging
    DEFAULT_BOOT_LOG_PREFIX="$HOME/.bootlog_"
    DEFAULT_BOOT_LOG_SUFFIX=".log"

    _boot_log_setup() {
        # todo - something just isn't working out with this ...
        # > log_setup [PREFIX] [SUFFIX]
        LOG_PATH_PREFIX=${1:=$DEFAULT_BOOT_LOG_PREFIX}
        LOG_PATH_SUFFIX=${2:=$DEFAULT_BOOT_LOG_SUFFIX}

        # the standard boot logger works when SET_DEBUG is non-zero
        if (( SET_DEBUG>0 )); then
            # Setup log file and redirect output
            # Create a numbered log file from prefix and suffix
            LOG_PATH="${LOG_PATH_PREFIX}$(ms)${LOG_PATH_SUFFIX}"

            touch "$LOG_PATH"
            dbecho "$0 has setup LOG_PATH to point to this file:\n  $LOG_PATH"

            # Reference: https://unix.stackexchange.com/a/145654/
            # exec &> >(tee -ap 'warn' $LOG_PATH)
            # exec &> >(tee -a $LOG_PATH)
            exec | tee -a $LOG_PATH
            dbecho "$0 redirects logging to file with this command:\n  exec | tee -a $LOG_PATH)"
            dbecho ""
        fi
    }

    # boot_log_setup

#? -----------------------------> load profile settings
    # source all files in this directory
    source_dir "$DOTFILES_INC"


    # if type brew &>/dev/null; then
    #     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    #     autoload -Uz compinit
    #     compinit
    # fi

    # . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    #   test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#? -----------------------------> oh-my-zsh config

    # Using ZSH shell - http://zsh.sourceforge.net/

    # HISTORY options are set in zshrc_exports 'history' section
        # extendedhistory
        # histexpiredupsfirst
        # histfindnodups
        # histignoredups
        # histignorespace
        # histreduceblanks
        # histverify
        # sharehistory

    # set automatically at invocation of the shell:
    # INTERACTIVE SHIN_STDIN MONITOR EXEC ZLE

    # Directory options:
    setopt AUTO_CD CDABLE_VARS CHASE_DOTS

    # Directory stack options:
    setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT PUSHD_TO_HOME
    # possibly useful: pushdminus

    # Completions:
    setopt ALWAYS_TO_END AUTO_LIST AUTO_PARAM_SLASH AUTO_PARAM_KEYS
    setopt AUTO_REMOVE_SLASH COMPLETE_ALIASES COMPLETE_IN_WORD
    setopt GLOB_COMPLETE LIST_AMBIGUOUS REC_EXACT

    # Expansion and Globbing
    setopt NO_CASE_GLOB EXTENDED_GLOB GLOB_DOTS GLOB_STAR_SHORT
    setopt NULL_GLOB NUMERIC_GLOB_SORT

    # Initialisation
    setopt ALL_EXPORT GLOBAL_EXPORT GLOBAL_RCS NO_RCS

    # Input/Output
    # The shell variable CORRECT_IGNORE may be set to a pattern to match
    #   words that will never be offered as corrections.
    setopt CORRECT CORRECT_ALL INTERACTIVE_COMMENTS
    setopt NO_FLOW_CONTROL MAIL_WARNING PATH_DIRS RC_QUOTES
    # todo - try these out
    setopt PRINT_EXIT_VALUE SHORT_LOOPS

    # Job Control
    setopt AUTO_RESUME NO_BG_NICE CHECK_JOBS CHECK_RUNNING_JOBS
    setopt LONG_LIST_JOBS NOTIFY

    # Prompting
    setopt PROMPT_BANG PROMPT_SUBST TRANSIENT_RPROMPT

    # Scripts and Functions
    setopt NO_ALIAS_FUNC_DEF C_BASES OCTAL_ZEROES C_PRECEDENCES
    # these can cause issues and are mainly for debugging:
    # setopt DEBUG_BEFORE_CMD ERR_RETURN EVAL_LINENO FUNCTION_ARGZERO MULTIOS

    # Shell Emulation
    setopt NO_CLOBBER APPEND_CREATE SH_WORD_SPLIT SH_NULLCMD
    setopt CONTINUE_ON_ERROR TRAPS_ASYNC

    # ZLE
    setopt COMBINING_CHARS


#? -----------------------------> OMZ plugins
    plugins=(\

    # repo management ...
    git gpg-agent npm gitignore\

    # macOS improvements
    osx colored-man-pages cp copyfile man iterm2 gnu-utils\

    # old plugins
    # terminalapp\

    # zsh helpers
    # zsh-autosuggestions \
    # zsh-better-npm-completion \
    # zsh-syntax-highlighting \

    # go!
    golang\
    # golang /Users/michaeltreanor/.dotfiles/ohmyzsh/plugins/golang/README.md

    # python!
    django poetry\

    python)
    # includes pyfind, pyclean, pyuserpaths, pygrep, ipython

#? -----------------------------> per host config
    # per-host
    _HOSTNAME=hostname
    HOSTRC="~/.dotfiles/zshrc.${_HOSTNAME}"
    if [ -r "$HOSTRC" ]; then
        source "$HOSTRC"
    fi
    if [ -r ~/.zshrc.host ]; then
        source ~/.zshrc.host
    fi

#? -----------------------------> load OMZ!
    # OMZ config
	CASE_SENSITIVE="false"
	COMPLETION_WAITING_DOTS="true"
    # DISABLE_UNTRACKED_FILES_DIRTY="true"
    ENABLE_CORRECTION="true"
    DISABLE_MAGIC_FUNCTIONS="true"
    ZSH_THEME="spaceship"
	# ZSH_THEME="robbyrussell"

    . "$ZSH/oh-my-zsh.sh"

#? -----------------------------> odds and ends
    # Autocorrect exceptions
    #alias vim='nocorrect vim '
    alias cp='nocorrect cp '
    alias mv='nocorrect mv '

    if [ -x dircolors ]; then
        eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.ansi-dark`
    fi

    # common shell config
    if [ -r ~/.commonshrc ]; then
        source ~/.commonshrc
    fi

    # export FPATH="$HOME/.dotfiles/docked-node/zfuncs:$FPATH"
    # autoload docked-node

    # Helper to lookup commands from the zsh git plugin cheatsheet
    function gx () {
        `fzf < ~/.dotfiles/zsh-git-plugin-cheatsheet.txt | cut -f3 -d'|' | tr _ ' '`
    }

    # reset the colorflag ... it seems to get lost somewhere ...
    # alias ls="ls --color=tty --group-directories-first"
    colorflag="--color=tty"
    alias ls="ls $colorflag --group-directories-first"

#? -----------------------------> ZSH odds and ends
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search # Up
    bindkey "^[[B" down-line-or-beginning-search # Down

    # SHIFT-TAB
    bindkey '^[[Z' reverse-menu-complete

    # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -a zsh/mapfile mapfile

    zstyle ':completion:*' menu select
    fpath+="$HOME/.zfunc"

	autoload -Uz compinit && compinit

#? -----------------------------> important utilities
    test -e "${HOME}/.iterm2_shell_integration.zsh" && . "${HOME}/.iterm2_shell_integration.zsh"

    # The next line updates PATH for the Google Cloud SDK.
    if [ -r ~/apps/google-cloud-sdk/path.zsh.inc ]; then . ~/apps/google-cloud-sdk/path.zsh.inc; fi

    # The next line enables shell command completion for gcloud.
    if [ -r ~/apps/google-cloud-sdk/completion.zsh.inc ]; then . ~/apps/google-cloud-sdk/completion.zsh.inc; fi
#? -----------------------------> Powerlevel10k
    # PowerLevel10k Theme
    ZSH_THEME="powerlevel10k/powerlevel10k"
    # To customize prompt, run `p10k configure` or edit ~/.dotfiles/.p10k.zsh.
    [[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh
    # POWERLEVEL9K_MODE="nerdfont-complete"
    # POWERLEVEL9K_DISABLE_RPROMPT=true
    # POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    # POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "
    # POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""

    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.dotfiles/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
    source ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh
    fi

#! -----------------------------> Install issues on macOS Big Sur
    # Reference: https://github.com/pyenv/pyenv/issues/1219

    BPO="${BREW_PREFIX}/opt/"
    LDFLAGS="-L${BPO}readline/lib -L${BPO}openssl/lib -L${BPO}zlib/lib"
    CFLAGS="-I${BPO}readline/include -I${BPO}openssl/include -I${BPO}zlib/include -I$(xcrun --show-sdk-path)/usr/include"
    CPPFLAGS=${CFLAGS}

#? -----------------------------> script cleanup
    script_exit_cleanup() {
        # cleanup and exit script
        printf "${MAIN:-}CPU: ${LIME:-}${CPU} ${MAIN:-}-> ${CANARY:-}${number_of_cores}${MAIN:-} cores. \n"
        printf "${MAIN:-}LOCAL IP: ${COOL:-}${LOCAL_IP}  ${MAIN:-}SHLVL: ${WARN:-}${SHLVL}  ${MAIN:-}LANG: ${RAIN:-}${LANG}${RESET:-}\n"
        # calculate and display script time
		# sleep 1 # timer test for ~ 1 second (1000 ms)
        SCRIPT_TIME=$(lap_ms)
        printf "${GREEN:-}Script ${SCRIPT_NAME} took ${BOLD:-}${ATTN:-}${SCRIPT_TIME}${RESET:-}${GREEN:-} ms to load.${RESET:-}\n\n"
        unset t0 t1 dt SCRIPT_NAME SCRIPT_TIME
        }
    trap script_exit_cleanup EXIT

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
