#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ################# cron_sunday - sunday system updates ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

	echo "every Sunday counts"

brew update
brew upgrade
brew doctor
brew cleanup

npm install npm -g
npm update -g

pip3 list | sed 's/  */ /g' | cut -d ' ' -f 1 | tail -n +3 | xargs pip3 install -U
