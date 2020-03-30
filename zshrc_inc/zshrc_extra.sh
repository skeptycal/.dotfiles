#!/usr/bin/env false
# -*- coding: utf-8 -*-
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=SC2034

# cannot be run directly; called from .bash_profile or .bashrc or .zshrc
# BASH_SOURCE=${(%):-%N} # to ease the transition to zsh
# *############################################################################
# [[ $SET_DEBUG == 1 ]] && db_script_source ".extra test"


# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
# unalias run-help
# autoload run-help
# HELPDIR=/usr/local/share/zsh/help

declare -g GIT_AUTHOR_NAME="skeptycal"
declare -g GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
declare -g GIT_AUTHOR_EMAIL="skeptycal@gmail.com"
declare -g GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"

# source $(which brew_fix.sh)
