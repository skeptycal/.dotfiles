#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034

#? ######################## Shell Variables and Settings
  # profile start time
  t0=$(date "+%s.%n")

  # use root defaults (they match web server defaults)
  umask 022   #            !! possible security issue !!

  # Remove all aliases from random unexpected places
  unalias -a

  # Warn on global variable creation
  # setopt WARN_CREATE_GLOBAL'

  #? ######################## Troubleshooting
  #? set to 1 for verbose testing ; remove -r to allow each script to set it
  declare -ix SET_DEBUG
  SET_DEBUG=0

#? ######################## Constants
  # get name of shell program without path info
  # e.g. instead of /bin/zsh, get zsh
  declare -x SHELL_BIN && SHELL_BIN="${SHELL##*/}"
  SHELL_LVL=$SHLVL

  # flag: are personal utilities loaded? (default = False)
  declare -x SSM_LOADED && SSM_LOADED='False'
  declare -x SSM && SSM=$HOME/bin/ssm
  # load standard script modules
  . $SSM

  # local script path and name
  SCRIPT_PATH=${0%/*}
  SCRIPT_NAME=${0##*/}

  # provide a BASH_SOURCE variable in zsh
  # to ease the transition to zsh from bash
  [[ "$SHELL_BIN" = 'zsh' ]] && BASH_SOURCE=${(%):-%N}
  BASH_SOURCE="${BASH_SOURCE:-$0}"

  # Locations of profile settings files
  declare -x DOTFILES_PATH && DOTFILES_PATH="${HOME}/.dotfiles"
  declare -x DOTFILES_INC && DOTFILES_INC="${DOTFILES_PATH}/zshrc_inc"

  # Location of macOS Homebrew folder
  declare -x BREW_PREFIX && BREW_PREFIX="$(brew --prefix)"

#? ######################## Source Tools
.() { # source with debugging info and file read check
    if [[ -r $1 ]]; then
        source "$1"
        [[ $SET_DEBUG = 1 ]] && blue "Source $1"
    else
        attn "Source error for $1"
    fi
}

source_dir() { # source all files in directory
    if [[ -d $1 ]]; then
        local f
        [[ $SET_DEBUG = 1 ]] && blue "Source Directory $1"
        for f in "$1"/*; do
            . "$f"
        done
        unset f
    else
        attn "Source Directory error for $1"
    fi
}

#? ######################## Load Profile settings
  source_dir "$DOTFILES_INC"
  . ~/.dotfiles/.TWINE_USERNAME

#? ######################## From original oh-my-zsh .zshrc
  # Path to your oh-my-zsh installation. Comments at the end of this script.
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="spaceship"
  # ZSH_THEME="robbyrussell"
  CASE_SENSITIVE="false"
  COMPLETION_WAITING_DOTS="true"
  DISABLE_UNTRACKED_FILES_DIRTY="false"
  export plugins=(git vscode)
  source "$ZSH/oh-my-zsh.sh"

#? ######################## Set ZSH Options
  # Using ZSH shell - http://zsh.sourceforge.net/
  setopt   notify globdots correct pushdtohome cdablevars autolist
  setopt   correctall autocd recexact longlistjobs
  setopt   autoresume histignoredups pushdsilent noclobber
  setopt   autopushd pushdminus extendedglob rcquotes mailwarning
  unsetopt autoparamslash bgnice

  # Autoload zsh modules when they are referenced
  zmodload -a zsh/stat stat
  zmodload -a zsh/zpty zpty
  zmodload -a zsh/zprof zprof
  zmodload -a zsh/mapfile mapfile

#? ######################## Program settings
  # google cloud SDK
  # The next line updates PATH for the Google Cloud SDK.
  if [ -f '/Users/skeptycal/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/skeptycal/google-cloud-sdk/path.zsh.inc'; fi
  # The next line enables shell command completion for gcloud.
  if [ -f '/Users/skeptycal/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/skeptycal/google-cloud-sdk/completion.zsh.inc'; fi

  # haskell config
  [ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

  # brew install jump
  # https://github.com/gsamokovarov/jump
  eval "$(jump shell)"

  # pyenv
  [[ $(command -v pyenv >/dev/null) ]] && eval "$(pyenv init -)"
  [[ $(command -v pyenv-virtualenv-init >/dev/null) ]] && eval "$(pyenv virtualenv-init -)"

#? ######################## From zsh addons install
  # messages from these installs:
  # brew install zsh-autosuggestions
  # brew install zsh-syntax-highlighting

  if type brew &>/dev/null; then
    FPATH=$BREW_PREFIX/share/zsh-completions:$FPATH
    FPATH=$BREW_PREFIX/share/zsh/site-functions:$FPATH
  fi

  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/local/opt/zsh-git-prompt/zshrc.sh

  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Setup new style completion system. To see examples of the old style
  # (compctl based) programmable completion, check Misc/compctl-examples in
  # the zsh distribution.
  autoload -Uz compinit && compinit

#? ######################## ZSH command completions
  # zsh autocomplete
  _listsysctls() { set -A reply "$(sysctl -AN ${1%.*})"; }
  compctl -K _listsysctls sysctl

  # pip zsh completion start
  _pip_completion() {
    local words cword
    IFS="" read -r -Ac words
    IFS="" read -r -cn cword
    # shellcheck disable=1087,2207,2034
    reply=( $( COMP_WORDS="$words[*]" \
              COMP_CWORD=$(( cword-1 )) \
              PIP_AUTO_COMPLETE=1 "$words[1]" 2>/dev/null ))
    }
  compctl -K _pip_completion pip
  # pip zsh completion end

#? ######################## script cleanup
  # profile end time
  t1=$(date "+%s.%n")
  # display script time
    printf "${ATTN:-}Profile took ${WARN:-}%.1f${ATTN:-} second(s) to load.\n" $((t1-t0))
    printf "${MAIN:-}CPU: ${LIME:-}${CPU} ${MAIN:-}-> ${CANARY:-}${number_of_cores}${MAIN:-} cores. \n"
    printf "${MAIN:-}LOCAL IP: ${COOL:-}${LOCAL_IP}  ${MAIN:-}SHLVL: ${WARN:-}${SHLVL}  ${MAIN:-}LANG: ${RAIN:-}${LANG}${RESET:-}"


  unset t1 t0 SCRIPT_PATH SCRIPT_NAME

  # End of .zshrc
  # --------------------------------------------------------------------------

#* ----------------------------- REFERENCES and NOTES
#? ######################## Set BASH Options
  # BASH options
  # http://tldp.org/LDP/abs/html/options.html
  # set -a    # mark all variables and functions for export

  # local use options with deadly side effects
  # set +H    # turn off History expansion (to use indirect variables)
  # set -f    # disable globbing (#! CAREFUL)

  # debugging options
  # set -e    # exit immediately if a command fails (use Traps, however)
  # set -n    # read commands but do not execute them
  # set -u    # treat unset variables as an error
  # set -v    # print lines as they are read
  # set -x    # print a trace of simple commands

#? ######################## Set ZSH Options
  #   # Using ZSH shell - http://zsh.sourceforge.net/

  #   # zsh options
  #   # Set/unset  shell options
  #   setopt   notify globdots correct pushdtohome cdablevars autolist
  #   setopt   correctall autocd recexact longlistjobs
  #   setopt   autoresume histignoredups pushdsilent noclobber
  #   setopt   autopushd pushdminus extendedglob rcquotes mailwarning
  #   unsetopt bgnice autoparamslash

  #   # my options
  #   # setopt   alwaystoend all_export

  #   # zsh completions
  #   # rm -f ~/.zcompdump;

  #   # . "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  #   # . "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  #   # . "/usr/local/opt/zsh-git-prompt/zshrc.sh"

  #   # Autoload zsh modules when they are referenced
  #     zmodload -a zsh/stat stat
  #     zmodload -a zsh/zpty zpty
  #     zmodload -a zsh/zprof zprof
  #     zmodload -a zsh/mapfile mapfile

  #   # Some nice key bindings
  #     # bindkey '^X^Z' universal-argument ' ' magic-space
  #     # bindkey '^X^A' vi-find-prev-char-skip
  #     # bindkey '^Xa' _expand_alias
  #     # bindkey '^Z' accept-and-hold
  #     # bindkey -s '\M-/' \\\\
  #     # bindkey -s '\M-=' \|
  #     # bindkey -v                 # vi key bindings
  #     # bindkey -e                 # emacs key bindings
  #     # bindkey ' ' magic-space    # also do history expansion on space
  #     # bindkey '^I' complete-word # complete on tab, leave expansion to _expand


  # # sysctl - Access kernel state information.

  # # Show all available variables and their values:
  # # sysctl -a

  # # Show Apple model identifier:
  # # sysctl -n hw.model

  # # Show CPU model:
  # # sysctl -n machdep.cpu.brand_string

  # # Show available CPU features (MMX, SSE, SSE2, SSE3, AES, etc):
  # # sysctl -n machdep.cpu.feature

  # # Set a changeable kernel state variable:
  # # sysctl -w {{section.tunable}}={{value}}
  # CPU=$(sysctl -n machdep.cpu.brand_string)

  # # zsh autocomplete
  # listsysctls () {
  #   set -A reply $(sysctl -AN ${1%.*})
  #   }
  # compctl -K listsysctls sysctl

#? ######################## Original .zshrc
  # # Path to your oh-my-zsh installation.
  # export ZSH="/Users/skeptycal/.oh-my-zsh"

  # # Set name of the theme to load --- if set to "random", it will
  # # load a random theme each time oh-my-zsh is loaded, in which case,
  # # to know which specific one was loaded, run: echo $RANDOM_THEME
  # # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
  # ZSH_THEME="robbyrussell"

  # # Set list of themes to pick from when loading at random
  # # Setting this variable when ZSH_THEME=random will cause zsh to load
  # # a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
  # # If set to an empty array, this variable will have no effect.
  # # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

  # # Uncomment the following line to use case-sensitive completion.
  # CASE_SENSITIVE="true"

  # # Uncomment the following line to use hyphen-insensitive completion.
  # # Case-sensitive completion must be off. _ and - will be interchangeable.
  # # HYPHEN_INSENSITIVE="true"

  # # Uncomment the following line to automatically update without prompting.
  # # DISABLE_UPDATE_PROMPT="true"

  # # Uncomment the following line to disable colors in ls.
  # # DISABLE_LS_COLORS="true"

  # # Uncomment the following line to disable auto-setting terminal title.
  # # DISABLE_AUTO_TITLE="true"

  # # Uncomment the following line to enable command auto-correction.
  # # ENABLE_CORRECTION="true"

  # # Uncomment the following line to display red dots whilst waiting for completion.
  # COMPLETION_WAITING_DOTS="true"

  # # Uncomment the following line if you want to disable marking untracked files
  # # under VCS as dirty. This makes repository status check for large repositories
  # # much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # export plugins=(git)

  # source $ZSH/oh-my-zsh.sh

#? ######################## POSIX compliant 'source'
  # .() {
  #   s=$(command -v "$1")
  #   echo "path \$1: $s"
  #   source "$(realpath "${1}")" || echo "${0?"Unable to source script $s in $BASH_SOURCE at $LINENO"}"
  #   }
    # Reference: The shell shall execute commands from the file in the current environment.

    # If file does not contain a <slash>, the shell shall use the search path specified by PATH to find the directory containing file. Unlike normal command search, however, the file searched for by the dot utility need not be executable. If no readable file is found, a non-interactive shell shall abort; an interactive shell shall write a diagnostic message to standard error, but this condition shall not be considered a syntax error.

zstyle ':completion:*' menu select
fpath+=~/.zfunc
