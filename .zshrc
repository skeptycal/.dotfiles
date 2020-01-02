#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178

  # profile start time
  t0=$(date "+%s.%n")

#? ######################## Shell Settings
  # to ease the transition to zsh
  BASH_SOURCE=${(%):-%N}
  BASH_SOURCE=${BASH_SOURCE:-$0}

  # use root defaults since they match web server defaults
  umask 022

  # Remove all aliases from random unexpected places
  unalias -a

  declare -ix number_of_cores
  number_of_cores=$(sysctl -n hw.ncpu)

  . "${HOME}/.dotfiles/gpg.zsh"

#? ######################## Troubleshooting
  #?      set to 1 for verbose testing ; remove -r to allow each script to set it
  declare -ix SET_DEBUG=0
  #?      log errors to text file; only functional if $SET_DEBUG=1
  if [[ $SET_DEBUG == 1 ]]; then
      # setopt verbose xtrace
      #? turn on debug logging
      declare -ix DEBUG_LOG && DEBUG_LOG=0
      #? log file for debug logs
      declare -x debug_log_file && debug_log_file="${HOME}/.bash_profile_error.log"
      #? max filesize for debug_log_file
      declare -ix debug_log_max_size && debug_log_max_size=32768
  fi

#? ######################## POSIX compliant 'source'
  # .() {
  #   s=$(command -v "$1")
  #   echo "path \$1: $s"
  #   source "$(realpath "${1}")" || echo "${0?"Unable to source script $s in $BASH_SOURCE at $LINENO"}"
  #   }
  #   # Reference: The shell shall execute commands from the file in the current environment.

  #   # If file does not contain a <slash>, the shell shall use the search path specified by PATH to find the directory containing file. Unlike normal command search, however, the file searched for by the dot utility need not be executable. If no readable file is found, a non-interactive shell shall abort; an interactive shell shall write a diagnostic message to standard error, but this condition shall not be considered a syntax error.

#? ######################## Path Info
  declare -x SOURCE_PATH && SOURCE_PATH="${HOME}/.dotfiles"
  . "${SOURCE_PATH}/.path"

  # if type brew &>/dev/null; then #! removed 'brew' check
  #   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  # fi

  fpath=(/usr/local/share/zsh/site-functions $fpath)
  fpath=(/usr/local/share/zsh-completions $fpath)
  fpath=($HOME/.zsh/pure $fpath)

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
  # Using ZSH shell - http://zsh.sourceforge.net/

  # zsh options
  # Set/unset  shell options
  setopt   notify globdots correct pushdtohome cdablevars autolist
  setopt   correctall autocd recexact longlistjobs
  setopt   autoresume histignoredups pushdsilent noclobber
  setopt   autopushd pushdminus extendedglob rcquotes mailwarning
  unsetopt bgnice autoparamslash

  # my options
  # setopt   alwaystoend all_export

  # zsh completions
  # rm -f ~/.zcompdump;

  # . "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # . "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # . "/usr/local/opt/zsh-git-prompt/zshrc.sh"

  # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -a zsh/mapfile mapfile

  # Some nice key bindings
    # bindkey '^X^Z' universal-argument ' ' magic-space
    # bindkey '^X^A' vi-find-prev-char-skip
    # bindkey '^Xa' _expand_alias
    # bindkey '^Z' accept-and-hold
    # bindkey -s '\M-/' \\\\
    # bindkey -s '\M-=' \|
    # bindkey -v                 # vi key bindings
    # bindkey -e                 # emacs key bindings
    # bindkey ' ' magic-space    # also do history expansion on space
    # bindkey '^I' complete-word # complete on tab, leave expansion to _expand

#? ######################## Load Profile settings
  # . "${SOURCE_PATH}/ssm"
  . "${SOURCE_PATH}/.aliases"
  . "${SOURCE_PATH}/.exports"
  . "${SOURCE_PATH}/.theme"
  . "${SOURCE_PATH}/.functions"
  . "${SOURCE_PATH}/.extra"
  # . "${SOURCE_PATH}/.git_alias" # already included

  # pipenv python environment settings
  # eval "$(pyenv init -)"
  # eval "$(pyenv virtualenv-init -)"

  # pip zsh completion start
  function _pip_completion {
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

  # Setup new style completion system. To see examples of the old style (compctl
  # based) programmable completion, check Misc/compctl-examples in the zsh
  # distribution.
  autoload -Uz compinit && compinit

#? ######################## Original .zshrc
  # Path to your oh-my-zsh installation.
  export ZSH="/Users/skeptycal/.oh-my-zsh"

  # Set name of the theme to load --- if set to "random", it will
  # load a random theme each time oh-my-zsh is loaded, in which case,
  # to know which specific one was loaded, run: echo $RANDOM_THEME
  # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
  ZSH_THEME="robbyrussell"

  # Set list of themes to pick from when loading at random
  # Setting this variable when ZSH_THEME=random will cause zsh to load
  # a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
  # If set to an empty array, this variable will have no effect.
  # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

  # Uncomment the following line to use case-sensitive completion.
  CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion.
  # Case-sensitive completion must be off. _ and - will be interchangeable.
  # HYPHEN_INSENSITIVE="true"

  # Uncomment the following line to automatically update without prompting.
  # DISABLE_UPDATE_PROMPT="true"

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
  DISABLE_UNTRACKED_FILES_DIRTY="true"

  export plugins=(git)

  source $ZSH/oh-my-zsh.sh

#? ######################## script cleanup
  # profile end time
  t1=$(date "+%s.%n")
  # display script time
  printf "${MAIN}Profile took %.3f seconds to load.\n" $((t1-t0))
  unset t1 t0
