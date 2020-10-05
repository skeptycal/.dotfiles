#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ---------------------------------------> crontab script
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

#! -- root crontab script -- use caution --

echo "every month counts ..."

USERDIR=/Users/skeptycal

cd $USERDIR

# purge node_modules folders from all User directories
find /Users -type d -name "node_modules" -exec rm -rfv {} +
find /Users -type d -name "cache" -exec rm -rfv {} +
