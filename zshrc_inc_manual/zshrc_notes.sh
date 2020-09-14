#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2230,2086
#? ######################## .functions - functions for macOS with zsh
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc

	#* copyright (c) 2019 Michael Treanor
	#* MIT License - https://www.github.com/skeptycal

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
