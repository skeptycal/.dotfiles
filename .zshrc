#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
#* #############################################################################
#* ### Set Options
#* #############################################################################

umask 022 # use root defaults since they match web server defaults

#* #############################################################################
#* ### Troubleshooting
#* #############################################################################
# TODO Hack - to help with zsh transition
[[ -z "$BASH_SOURCE" ]] && BASH_SOURCE="$0" # to ease the transition to zsh
#?      set to 1 for verbose testing ; remove -r to allow each script to set it
declare -i SET_DEBUG=0
export SET_DEBUG
#?      log errors to text file; only functional if $SET_DEBUG=1
# if [[ $SET_DEBUG == 1 ]]; then
#     #? turn on debug logging
#     export DEBUG_LOG=0
#     #? log file for debug logs
#     export debug_log_file="${HOME}/.bash_profile_error.log"
#     #? max filesize for debug_log_file
#     export debug_log_max_size=32768
# fi

#* #############################################################################
#* ### Load Profile settings
#* #############################################################################
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export SOURCE_PATH="${HOME}/.dotfiles"
source "${SOURCE_PATH}/.path"
source "$(which ssm)"
source "${SOURCE_PATH}/.aliases"
source "${SOURCE_PATH}/.exports"
source "${SOURCE_PATH}/.theme"
source "${SOURCE_PATH}/.functions"
source "${SOURCE_PATH}/.extra"
# source "${SOURCE_PATH}/.git_alias"

#* #############################################################################
#* ### Original .zshrc
#* #############################################################################
export ZSH="${HOME}/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
ZSH_THEME=""
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS=true
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder
# plugins=(git lein pip pipenv django python osx vscode)
plugins=(git django python osx vscode)
source "${ZSH}/oh-my-zsh.sh"

#* #############################################################################
#* ### Sindre's prompt - https://github.com/sindresorhus/pure
#* #############################################################################
# Set ZSH_THEME="" in your .zshrc to disable oh-my-zsh themes.
# Follow the Pure Install instructions.
# Do not enable the following (incompatible) plugins: vi-mode, virtualenv.
# NOTE: oh-my-zsh overrides the prompt so Pure must be activated after source $ZSH/oh-my-zsh.sh.
autoload -U promptinit; promptinit
prompt pure

#* #############################################################################
#* ### end of original .zshrc
#* #############################################################################
#
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

#* #############################################################################
#* ### end of original .zprezto additions
#* #############################################################################
