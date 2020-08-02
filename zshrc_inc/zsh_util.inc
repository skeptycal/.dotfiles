#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178

#? ######################## Set ZSH Options
  zstyle ':completion:*' menu select
  fpath+=~/.zfunc

#   test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

  # Using ZSH shell - http://zsh.sourceforge.net/
  setopt   notify globdots correct pushdtohome cdablevars autolist
  setopt   correctall autocd recexact longlistjobs nocaseglob
  setopt   autoresume histignoredups pushdsilent noclobber
  setopt   autopushd pushdminus extendedglob rcquotes mailwarning
  unsetopt autoparamslash bgnice

  # Autoload zsh modules when they are referenced
  zmodload -a zsh/stat stat
  zmodload -a zsh/zpty zpty
  zmodload -a zsh/zprof zprof
  zmodload -a zsh/mapfile mapfile

#? ######################## From zsh addons install
  # messages from these installs:
  # brew install zsh-autosuggestions
  # brew install zsh-syntax-highlighting

  if type brew &>/dev/null; then
    FPATH=$BREW_PREFIX/share/zsh-completions:$FPATH
    FPATH=$BREW_PREFIX/share/zsh/site-functions:$FPATH
  fi
    [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
    fi

#     [ -f /usr/local/opt/zsh-git-prompt/zshrc.sh ] && . /usr/local/opt/zsh-git-prompt/zshrc.sh

#? ######################## ZSH command completions
  # zsh autocomplete
#   _listsysctls() { set -A reply "$(sysctl -AN ${1%.*})"; }
#   compctl -K _listsysctls sysctl

#   pip zsh completion start
#   _pip_completion() {
#     local words cword
#     IFS="" read -r -Ac words
#     IFS="" read -r -cn cword
#     # shellcheck disable=1087,2207,2034
#     reply=( $( COMP_WORDS="$words[*]" \
#               COMP_CWORD=$(( cword-1 )) \
#               PIP_AUTO_COMPLETE=1 "$words[1]" 2>/dev/null ))
#       }
#   compctl -K _pip_completion pip
#   pip zsh completion end

  # Setup new style completion system. To see examples of the old style
  # (compctl based) programmable completion, check Misc/compctl-examples in
  # the zsh distribution.

#? ######################## From original oh-my-zsh .zshrc
  # Path to your oh-my-zsh installation. Comments at the end of this script.
  export ZSH="$HOME/.oh-my-zsh"
#   ZSH_THEME="spaceship"
  ZSH_THEME="robbyrussell"
  CASE_SENSITIVE="false"
  COMPLETION_WAITING_DOTS="true"
  DISABLE_UNTRACKED_FILES_DIRTY="false"
  export plugins=(git colorize vscode django autopep8 poetry)
  source "$ZSH/oh-my-zsh.sh"
  autoload -Uz compinit && compinit
