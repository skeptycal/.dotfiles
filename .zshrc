#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
#? ######################## Set Options
  # Using ZSH shell - http://zsh.sourceforge.net/
  BASH_SOURCE=${(%):-%N} # to ease the transition to zsh
  set +avx

  # use root defaults since they match web server defaults
  umask 022

  # Remove all aliases from random unexpected places
  unalias -a

  # profile start time
  t0=$(date "+%s.%n")

  rm -f ~/.zcompdump;
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  fi
  source "${HOME}/.dotfiles/gpg.zsh"
  source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip
# pip zsh completion end

  # Set/unset  shell options
  setopt   notify globdots correct pushdtohome cdablevars autolist
  setopt   correctall autocd recexact longlistjobs
  setopt   autoresume histignoredups pushdsilent noclobber
  setopt   autopushd pushdminus extendedglob rcquotes mailwarning
  unsetopt bgnice autoparamslash

  # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -ap zsh/mapfile mapfile

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

  # Setup new style completion system. To see examples of the old style (compctl
  # based) programmable completion, check Misc/compctl-examples in the zsh
  # distribution.
  autoload -Uz compinit && compinit

  #? ######################## Troubleshooting
  #?      set to 1 for verbose testing ; remove -r to allow each script to set it
  declare -ix SET_DEBUG=0
  #?      log errors to text file; only functional if $SET_DEBUG=1
  if [[ $SET_DEBUG == 1 ]]; then
      #? turn on debug logging
      declare -ix DEBUG_LOG=0
      #? log file for debug logs
      declare -x debug_log_file="${HOME}/.bash_profile_error.log"
      #? max filesize for debug_log_file
      declare -ix debug_log_max_size=32768
  fi

#? ######################## Path Info
  declare -x SOURCE_PATH="${HOME}/.dotfiles"
  source "${SOURCE_PATH}/.path"
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  fi

#? ######################## Load Profile settings
  source "${SOURCE_PATH}/ssm"
  source "${SOURCE_PATH}/.aliases"
  source "${SOURCE_PATH}/.exports"
  source "${SOURCE_PATH}/.theme"
  source "${SOURCE_PATH}/.functions"
  source "${SOURCE_PATH}/.extra"
  source "${SOURCE_PATH}/.git_alias" # already included
  source "${HOME}/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#? ######################## Original .zshrc
  declare -x ZSH="${HOME}/.oh-my-zsh"
  # ZSH_THEME="robbyrussell"
  ZSH_THEME="robbyrussell"
  # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
  # CASE_SENSITIVE="true"
  # HYPHEN_INSENSITIVE="true"
  # DISABLE_AUTO_UPDATE="true"
  DISABLE_UPDATE_PROMPT="true"
  declare -x UPDATE_ZSH_DAYS=13
  # DISABLE_MAGIC_FUNCTIONS=true
  # DISABLE_LS_COLORS="true"
  # DISABLE_AUTO_TITLE="true"
  ENABLE_CORRECTION="true"
  COMPLETION_WAITING_DOTS="true"
  # DISABLE_UNTRACKED_FILES_DIRTY="true"
  # HIST_STAMPS="mm/dd/yyyy"
  # ZSH_CUSTOM=/path/to/new-custom-folder
  # ** original
  # plugins=(git lein pip pipenv django python osx vscode)
  # https://towardsdatascience.com/trick-out-your-terminal-in-10-minutes-or-less-ba1e0177b7df
  plugins=(git z history osx pip pipenv pyenv pylint python django lein sublime github vscode)
  # plugins=(git z history osx pylint python django vscode)
  source "${ZSH}/oh-my-zsh.sh"

#? ######################## Sindre's prompt - https://github.com/sindresorhus/pure
  # Set ZSH_THEME="" in your .zshrc to disable oh-my-zsh themes.
  # Follow the Pure Install instructions.
  # Do not enable the following (incompatible) plugins: vi-mode, virtualenv.
  # NOTE: oh-my-zsh overrides the prompt so Pure must be activated after source $ZSH/oh-my-zsh.sh.
  autoload -U promptinit; promptinit
  prompt pure

  # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
  # https://github.com/sindresorhus/pure/pull/472
  zstyle :prompt:pure:exec_time color 225
  zstyle :prompt:pure:git:arrow color 220
  zstyle :prompt:pure:git:branch color 106
  zstyle :prompt:pure:host color 30
  zstyle :prompt:pure:path color 230
  zstyle :prompt:pure:prompt:error color 196
  zstyle :prompt:pure:prompt:success color 222
  zstyle :prompt:pure:user color 36

#? ######################## script cleanup
  # script end time
  t1=$(date "+%s.%N")
  # display script time
  printf "${MAIN}Profile took %.3f seconds to load.\n" $(( t1-t0 ))
  unset t1 t0
  # set +avx

  # echo "` <$0`"           # Echoes the script itself to stdout.

#? ######################## zprezto (end of original .zshrc)
  # Executes commands at the start of an interactive session.
  #
  # Authors:
  #   Sorin Ionescu <sorin.ionescu@gmail.com>
  #
  # Source Prezto.
  # if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  #   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  # fi
  # Customize to your needs...

#? ######################## asdf (end of original .zshrc)

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

# . /usr/local/Cellar/asdf/0.7.5/asdf.sh

# . /usr/local/Cellar/asdf/0.7.5/etc/bash_completion.d/asdf.bash
