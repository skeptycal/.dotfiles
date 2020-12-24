#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ################# cron_sunday - sunday system updates ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

#! -- root crontab script -- use caution --

echo "every Sunday counts"

. /Users/skeptycal/bin/ansi_colors

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

# Find and delete all broken symbolic links
find -L / -type l -exec rm -- {} +

# Removing all empty directories
find / -type d -empty -exec rmdir --ignore-fail-on-non-empty -- {} +

# update macOS dev software
softwareupdate -i -a

# update global npm repos
npm install npm -g
npm update -g

# update global gem repos
gem update --system
gem update
gem cleanup

# update global python
pip3 list | sed 's/  */ /g' | cut -d ' ' -f 1 | tail -n +3 | xargs pip3 install -U
