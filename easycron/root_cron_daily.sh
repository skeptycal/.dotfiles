#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ---------------------------------------> crontab script
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

#! -- root crontab script -- use caution --

echo "every day counts ..."

USERDIR=/Users/skeptycal

cd $USERDIR

# empty trashes
rm -rfv /Volumes/*/.Trashes;
rm -rfv $USERDIR/.Trash;
rm -rfv /private/var/log/asl/*.asl;
sqlite3 $USERDIR/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'

# cleanup .DS_Store files
find $USERDIR -type f -name "*.DS_Store" -exec rm -rfv {} +

# python and pycache cleanup
find $USERDIR -type d -name "build" -exec rm -rfv {} +
find $USERDIR -type d -name "dist" -exec rm -rfv {} +
find $USERDIR -type d -name ".mypy_cache" -exec rm -rfv {} +
find $USERDIR -type d -name ".pytest_cache" -exec rm -rfv {} +
find $USERDIR -type d -name "__pycache__" -exec rm -rfv {} +
find $USERDIR -type d -name "*.egg-info" -exec rm -rfv {} +
find $USERDIR -type d -name ".tox" -exec rm -rfv {} +
find $USERDIR -type f -name "*.py[co]" -exec rm -rfv {} +

# lscleanup
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
