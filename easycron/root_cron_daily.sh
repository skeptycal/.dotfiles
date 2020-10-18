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

# empty trashes
rm -rfv /Volumes/*/.Trashes;
rm -rfv /private/var/log/asl/*.asl;

# lscleanup
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
