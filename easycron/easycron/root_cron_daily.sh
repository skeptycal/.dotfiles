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


function zargit () {
	zargs -e.. "$1" .. rm -rf --
}
# empty trashes
# rm -rfv /Volumes/*/.Trashes;
zargit /Volumes/*/.Trashes
# zargs -e.. -- **/* .. ls -ld --

# rm -rfv /private/var/log/asl/*.asl;
# rm -rfv /private/var/log/asl/*.asl;
zargit /private/var/log/asl/*.asl

# lscleanup
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
