#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2178,2128,2206,2034
#? ################# cron_sunday - sunday system updates ###############
#* copyright (c) 2019 Michael Treanor     -----     MIT License
#* should not be run directly; called from crontab or .zshrc, etc.

echo "every Sunday counts"

# start in 'easycron' folder
cd "${HOME}/.dotfiles/easycron/"

# souce 'versions.sh' to update '.VERSION_LIST.md' file
. ~/.dotfiles/easycron/versions.sh

# update and repair user HomeBrew repos
brew update
brew upgrade
brew doctor
brew cleanup

# update user (global) npm
npm install npm -g
npm update -g

# update user (global) pip library
pip3 list | sed 's/  */ /g' | cut -d ' ' -f 1 | tail -n +3 | xargs pip3 install -U
