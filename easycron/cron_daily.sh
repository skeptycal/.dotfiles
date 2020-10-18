#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ---------------------------------------> crontab script
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

echo "every day counts ..."

cd $HOME

# empty trashes
rm -rfv $HOME/.Trash;
sqlite3 $HOME/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'

# cleanup .DS_Store files
find $HOME -type f -name "*.DS_Store" -exec rm -rfv {} +

# user python and pycache cleanup
find $HOME -type d -name "build" -exec rm -rfv {} +
find $HOME -type d -name "dist" -exec rm -rfv {} +
find $HOME -type d -name ".mypy_cache" -exec rm -rfv {} +
find $HOME -type d -name ".pytest_cache" -exec rm -rfv {} +
find $HOME -type d -name "__pycache__" -exec rm -rfv {} +
find $HOME -type d -name "*.egg-info" -exec rm -rfv {} +
find $HOME -type d -name ".tox" -exec rm -rfv {} +
find $HOME -type f -name "*.py[co]" -exec rm -rfv {} +
