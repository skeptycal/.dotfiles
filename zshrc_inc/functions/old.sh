#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################

#? -----------------------------> git housekeeping (TODO)
    #TODO - wip ...
    # _housekeeping () {
    #     echo "git fetch -p && git branch -vv | awk '/: gone]/ {print $1}' | xargs git branch -d"
    #     }

# cd() {
	# 	# Reference: https://manned.org/command
	# 	/usr/bin/cd "$@" >/dev/null
	# 	white $(pwd)
	# 	}

# benchtime() {
	# 	usage='timeit [N] <command> [options]'
	# 	if [[ -z "$1" -o ]]; then
	# 		white "usage: ${MAIN:-}bench ${GREEN:-}<COMMAND> [OPTIONS]"
	# 		return
	# 	fi

	# 	is_int "$1" && N="$1"
	# 	N=${N:=10000}

	# 	t0=$(ms)
	# }

# bench() {
	# 	if [[ -z "$1" -o ]]; then
	# 		white "usage: ${MAIN:-}bench ${GREEN:-}<COMMAND> [OPTIONS]"
	# 		return
	# 	fi
	# 	command="$@"

# 	# ( time date ) 2>&1 | awk -F "cpu" '{print $2}' | tail -n 1 | awk '{print $1}'
	# 	( time date ) 2>&1 | awk -F "cpu" '{print $2}' | tail -n 1 | awk '{print $1}'

	# 	time (repeat $N { typeset -p "SOME_VARIABLE" > /dev/null 2>&1 })

	# }

# BOOT_LOGFILE="${HOME}/.boot_log_$(ms).log"
	# PERF_TEST_LOGFILE="${HOME}/.perf_test_$(ms).log"
	# DAILY_LOG_FILE="${ZDOTDIR}/.daily_check"
	# SUN_LOG_FILE="${ZDOTDIR}/.sun_check"

	# default logfile
	# log_setup -f "$BOOT_LOGFILE"

	# find an available file descriptor for log redirection
	# get_fd(){
	# 	fd=5
	# 	while [ -t $fd ]; do (( fd++ )); done;
	# 	# dbecho "next available file descriptor: $fd"
	# 	echo $fd
	# 	# return $fd
	# }

	# LOG_FD=$(get_fd)

    # todo WIP
	# echolog() {
	# 	exec &> >(tee -a "$LOGFILE")
	# 	echo "$*"
	# 	# echo "$@" >>$LOGFILE
	# 	} # tee replacement ...

	# todo WIP
	# perf_test(){
	# 	LOGFILE=$PERF_TEST_LOGFILE
	# 	touch $LOGFILE
	# 	SEARCH_PATH=${1:-~/}

	# 	# find $PWD -name "*.pyc" -exec rm -rf {} \;
	# 	# find $PWD -name "__pycache__" -exec rm -rf {} \;'

	# 	hr() { echolog "============================================================================="; }
	# 	sr() { echolog "-----------------------------------------------------------------------------"; }
	# 	br() { echolog ""; }

	# 	# initial run example data
	# 	hr
	# 	echolog "Test various search, sort, and cleanup routines"
	# 	sr
	# 	echolog "Logging performance results to: $LOGFILE"
	# 	echolog "'time' will print the total time taken for the command to finish"
	# 	sr
	# 	echolog "Total space of search area ($SEARCH_PATH)."
	# 	echolog 'du -hd0 >>LOGFILE'
	# 	du -hd0 >>$LOGFILE                        # 52G
	# 	sr
	# 	echolog '# find -exec \;'
	# 	echolog "time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \; >>LOGFILE"
	# 	time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \; >>$LOGFILE
	# 	sr
	# 	echolog '# find -exec \+'
	# 	echolog "find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \+ >>LOGFILE"
	# 	time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \+ >>$LOGFILE
	# 	sr
	# 	echolog '# find | xargs -n1'
	# 	echolog "time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 -n1 grep -Hn 'def' >>LOGFILE"
	# 	time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 -n1 grep -Hn 'def' >>$LOGFILE
	# 	sr
	# 	echolog '# find | xargs'
	# 	echolog "time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 grep -Hn 'def' >>LOGFILE"
	# 	time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 grep -Hn 'def' >>$LOGFILE
	# 	hr
	# 	echolog "# find broken symlinks"
	# 	sr
	# 	echolog '# find | xargs'
	# 	echolog "time find -L $SEARCH_PATH -type l -print0 | xargs -0 grep -Hn 'def' >>LOGFILE"
	# 	time find -L $SEARCH_PATH -type l -print0 | xargs -0 grep -Hn '/' >>$LOGFILE
	# 	sr
	# 	echolog '# find -exec'
	# 	echolog "time find -L $SEARCH_PATH -type l -exec grep -Hn 'def' -- {} + >>LOGFILE"
	# 	time find -L $SEARCH_PATH -type l -exec grep -Hn '/' -- {} + >>$LOGFILE
	# 	hr
	# 	}

#? ######################## Maintenance
    # todo - moved to crontab for now
	# update() { # System software updates (macOS - updated for Big Sur)
	# 	#? ############################### Close 'System Preferences'
	# 	# Close any open System Preferences panes, to prevent them from overriding
	# 	# settings we are about to change
	# 	osascript -e 'tell application "System Preferences" to quit'

	# 	#? ############################### Homebrew updates
	# 	# Brew does not like 'sudo'
	# 	brew update
	# 	brew upgrade
	# 	brew doctor
	# 	brew cleanup

	# 	#? ############################### Use sudo for remainder of the script
	# 	# Brew does not like 'sudo'
	# 	sudo_env

	# 	#? ############################### macOS updates
	# 	/usr/bin/sudo softwareupdate -i -a

	# 	#? ############################### python updates
	# 	#   brew upgrade python pyenv pipenv
	# 	cd ~
	# 	deactivate || sleep 1 # exit venv ... if needed
	# 	repip

	# 	#? ############################### npm updates
	# 	# /usr/bin/sudo
	# 	npm install npm -g
	# 	# /usr/bin/sudo
	# 	npm update -g
	# 	runif brew_fix

	# 	#? ############################### ruby updates
	# 	# /usr/bin/sudo
	# 	gem update --system
	# 	# /usr/bin/sudo
	# 	gem update
	# 	# /usr/bin/sudo
	# 	gem cleanup
	# 	} # 2>/dev/null &

	# cleanup() {
	# 	# init sudo environment
	# 	sudo_env
	# 	# cleanup .DS_Store files
	# 	find . -type f -name '*.DS_Store' -ls -delete
	# 	# empty trashes
	# 	/usr/bin/sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
	# 	# pycache cleanup

	# 	# lscleanup
	# 	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
	# 	true
	# 	}

	# maintenance() { cleanup && update; }

	# background_update() { update >/dev/null 2>&1 & ; }
	# background_cleanup() { cleanup >/dev/null 2>&1 & ; }
	# background_maintenance() { background_cleanup && background_update >/dev/null 2>&1 & ; }

#? ######################## Session Tasks

	# items that are out of action right now...
		# perf_test           - performance tests logged to ~/.perf_test_xxx.log
		# repip               - reinstall updated pip and update all dependencies
		# ldoc [FILES]        - local docs (move FILES out of iCloud)
		# do_over [target]    - repeat something over and over ... and over
		# ftxinstalledfonts   - Apple utility to list and analyze fonts (very detailed!)
		# 	(e.g. ftxinstalledfonts -fiMls -U 'U+0041, $0042, 0x43' 2>/dev/null | grep 'YES\tYES')
		# log_urls            - logs urls from chrome constantly${LIME}

# ------------------------- gitit -------------------------
#   Automatic repo pre-commit, commit, and push
#
#   Usage: gitit [message]
# ---------------------- Requirements ---------------------
#
#   gpg key generator:          git_gpg.php
#   default status message:     ~/.dotfiles/.stCommitMsg
#
#   example .stCommitMsg:
#       (Gitit Bot): minor updates and formatting.
#       https://www.github.com/skeptycal
# ---------------------------------------------------------