#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################
	SET_DEBUG= ${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG > 0 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green "Today is $today"
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################

	weekday=$(date +%a)       					# Sun
	monthday=$(date +%d)      					# 23
	year=$(date +%Y)          					# 2020
	today=$(date +%F)         					# 2020-08-23
	now=$(date +%T)          					# 03:17:11
	nowdate=$(date +%m-%d-%Y)					# 09-12-2020
	week=$(date +%V)         					# 37
	seconds=$(date +%s)      					# 1600377174 s
	timestamp=$(date +%s%N)  					# 1600377060096604000 ns

    ms() { printf '%i\n' "$(( $(gdate +%s%0N)/1000000 ))" }

	SCRIPT_NAME=${0##*/}
	ZDOTDIR=${ZDOTDIR:=$HOME/.dotfiles}
	VERSION_LIST="${ZDOTDIR:-~/.dotfiles}/.VERSION_LIST.md"

	BOOT_LOGFILE="${HOME}/.boot_log_$(ms).log"
	PERF_TEST_LOGFILE="${HOME}/.perf_test_$(ms).log"
	DAILY_LOG_FILE="${ZDOTDIR}/.daily_check"
	SUN_LOG_FILE="${ZDOTDIR}/.sun_check"

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

#? ######################## Shell Utilities
	echolog() {
		exec &> >(tee -a "$LOGFILE")
		echo "$*"
		# echo "$@" >>$LOGFILE
		} # tee replacement ...
	perf_test(){
		LOGFILE=$PERF_TEST_LOGFILE
		touch $LOGFILE
		SEARCH_PATH=${1:-~/}

		# find $PWD -name "*.pyc" -exec rm -rf {} \;
		# find $PWD -name "__pycache__" -exec rm -rf {} \;'

		hr() { echolog "============================================================================="; }
		sr() { echolog "-----------------------------------------------------------------------------"; }
		br() { echolog ""; }

		# initial run example data
		hr
		echolog "Test various search, sort, and cleanup routines"
		sr
		echolog "Logging performance results to: $LOGFILE"
		echolog "'time' will print the total time taken for the command to finish"
		sr
		echolog "Total space of search area ($SEARCH_PATH)."
		echolog 'du -hd0 >>LOGFILE'
		du -hd0 >>$LOGFILE                        # 52G
		sr
		echolog '# find -exec \;'
		echolog "time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \; >>LOGFILE"
		time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \; >>$LOGFILE
		sr
		echolog '# find -exec \+'
		echolog "find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \+ >>LOGFILE"
		time find $SEARCH_PATH -name \*.pyc -type f -exec grep -Hn 'def' {} \+ >>$LOGFILE
		sr
		echolog '# find | xargs -n1'
		echolog "time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 -n1 grep -Hn 'def' >>LOGFILE"
		time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 -n1 grep -Hn 'def' >>$LOGFILE
		sr
		echolog '# find | xargs'
		echolog "time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 grep -Hn 'def' >>LOGFILE"
		time find $SEARCH_PATH -name \*.pyc -type f -print0 | xargs -0 grep -Hn 'def' >>$LOGFILE
		hr
		echolog "# find broken symlinks"
		sr
		echolog '# find | xargs'
		echolog "time find -L $SEARCH_PATH -type l -print0 | xargs -0 grep -Hn 'def' >>LOGFILE"
		time find -L $SEARCH_PATH -type l -print0 | xargs -0 grep -Hn '/' >>$LOGFILE
		sr
		echolog '# find -exec'
		echolog "time find -L $SEARCH_PATH -type l -exec grep -Hn 'def' -- {} + >>LOGFILE"
		time find -L $SEARCH_PATH -type l -exec grep -Hn '/' -- {} + >>$LOGFILE
		hr
		}

	not_root(){
		# the environment variable $EUID contains the 'effective user id'
		# it is locked by the shell and cannot be 'easily' changed
		#   example shell response:
		# % EUID = 0
		# zsh: failed to change effective user ID: operation not permitted

		# This is likely a safer method than shell programs such as 'id'
		return $(( EUID == 0 ));
		} >/dev/null 2>&1
	is_root() {
		# complementary function for 'not_root'
		return $(( EUID>0 ))
		} >/dev/null 2>&1
	userid_not_root(){
		# Using shell programs (whoami, uname, or id) to get username or userid and could easily be vulnerable to bypassing if they are replaced with a dummy file earlier in the path. Using scutil may be more difficult to fool, but is itself a shell program found on the path ...

		# It is interesting to realize that many secure macOS utilities (chown,
		# 	scutil, md5, halt, mount, kextload, fsck, launch_d, etc) are located
		#	in the /usr/sbin directory ... and scutil seems a less likely target
		# 	for attack than the ubiquitous 'id' program.

		# In any event, using the full path name is much safer. On a modern macOS
		# 	system, the /usr/bin directory is set to read only and this message
		# 	is the response to attempted changes:

		# 	mv: cannot move 'bin' to 'bin2': Read-only file system

		declare ix loggedInUserID="$( scutil <<< "show State:/Users/ConsoleUser"  | awk '/UID : / && ! /loginwindow/ { print $3 }' )"

		return $(( loggedInUserID=0 ))
		} >/dev/null 2>&1
	sudo_env() { # Turn on SUDO for remainder of current script
		#   requires root authentication, of course

		#   (use _SUDO_ENV=0 to disable this in all scripts
		#       the default is to turn it on within the function
		#       this makes it implicit with a function call ...)

		declare -x _SUDO_ENV=${_SUDO_ENV:-1}

		if [[ $_SUDO_ENV == 1 ]]; then
			warn "Using SUDO for this script ..." || echo "Using SUDO for this script ..."
			# Ask for the root password upfront
			/usr/bin/sudo -v

			# Keep-alive: update existing `sudo` time stamp until script has finished
			while true; do
				/usr/bin/sudo -n true
				/bin/sleep 60
				/bin/kill -0 "$$" || exit
			done 2>/dev/null &
		fi
		}
#? ######################## Program Versions Reporting
	write_versions_file() {
		br
		me "# Program Versions List"
		me "-------------------------------------------------------------"
		# green "## VERSION_LIST path: $VERSION_LIST"
		blue "**os: $(uname -i) | $(sw_vers -productName) | $(sw_vers -productVersion)**"
		me "### shell:"
		lime "- zsh:            $(zsh --version)"
		# green "- current shell:  $ZSH_VERSION"
		rain "- VSCode:         $(code --version | head -n 1)"
		br
		me "### utilities:"
		warn   "- $(clang --version | grep version | sed 's/version //g')"
		attn   "- $(git --version | sed 's/version //g') with $(hub --version | grep hub | sed 's/version //g')"
		canary "- $(bash --version | grep bash | cut -d ',' -f 1)  ($(bash --version | grep bash | cut -d ' ' -f 4 | cut -d '(' -f 1))${WHITE} with ${GO}GNU grep ($(grep --version | head -n 1 | cut -d ' ' -f 4))${WHITE} and ${CHERRY}GNU coreutils ($(brew list coreutils --versions | cut -d ' ' -f 2))"
		# lime "- homebrew ($(brew --version | tail -n 3 | head -n 1 | cut -d ' ' -f 2))" # and conda ($(conda -V | cut -d ' ' -f 2))"
		canary "- prettier ($(prettier --version))"
		# purple "- stack ($(stack --version | cut -d ',' -f 1 | cut -d ' ' -f 2))"
		blue "- mkdocs ($(mkdocs --version | cut -d ' ' -f 3))"
		# green "- TeXLive(tlmgr)  v$(tlmgr --version | head -n 1 | cut -d ' ' -f 3-4))"
		br

		me "### languages:"
		blue   "- GO      ($(go version | cut -d ' ' -f 3 | sed 's/go//g'))"
		# attn   "- rustc   ($(rustc --version | cut -d ' ' -f 2)) with rustup ($(rustup --version | cut -d ' ' -f 2))"
		warn   "- ruby    ($(ruby -v 2>/dev/null | cut -d ' ' -f 2 | cut -d 'p' -f 1)) with gem ($(gem -v))"
		# purple "- php     ($(php -v 2>/dev/null | grep '(cli)' | cut -d ' ' -f 2)) with composer ($(composer --version | cut -d ' ' -f 3))"
		printf "%b\n" "${COOL}- python  ($(python --version | cut -d ' ' -f 2)) with pip ($(pip --version | cut -d ' ' -f 2)) and pipenv ($(pipenv --version | cut -d ' ' -f 3)) ${RESET_FG}"
		canary "- node    ($(node -v | sed 's/v//g')) with npm ($(npm -v))"
		cherry "- Xcode   ($(/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -version | grep Xcode | sed 's/Xcode //g'))"
		# attn   "- Clojure ($(clojure -Sdescribe | grep version | sed 's/{://g' | sed 's/"//g' | sed 's/version //g')) with lein"
		br

		# attn "- cargo ($(cargo --version | cut -d ' ' -f 2))"
		# attn "  $(lein --version | sed 's/Leiningen/lein version/g' | sed 's/version /       v/g')"

		# me "Travis CI   v$(travis version)"
		} >"$VERSION_LIST"
	save_versions() {
		# echo "VERSION_LIST: $VERSION_LIST"
		rm -rf "$VERSION_LIST" >/dev/null 2>&1
		# touch $VERSION_LIST
		write_versions_file
		}
	versions() { cat $VERSION_LIST ; }
#? ######################## Maintenance
	update() { # System software updates (macOS - updated for Big Sur)
		#? ############################### Close 'System Preferences'
		# Close any open System Preferences panes, to prevent them from overriding
		# settings we are about to change
		osascript -e 'tell application "System Preferences" to quit'

		#? ############################### Homebrew updates
		# Brew does not like 'sudo'
		brew update
		brew upgrade
		brew doctor
		brew cleanup

		#? ############################### Use sudo for remainder of the script
		# Brew does not like 'sudo'
		sudo_env

		#? ############################### macOS updates
		/usr/bin/sudo softwareupdate -i -a

		#? ############################### python updates
		#   brew upgrade python pyenv pipenv
		cd ~
		deactivate || sleep 1 # exit venv ... if needed
		repip

		#? ############################### npm updates
		# /usr/bin/sudo
		npm install npm -g
		# /usr/bin/sudo
		npm update -g
		runif brew_fix

		#? ############################### ruby updates
		# /usr/bin/sudo
		gem update --system
		# /usr/bin/sudo
		gem update
		# /usr/bin/sudo
		gem cleanup
		} # 2>/dev/null &

	cleanup() {
		# init sudo environment
		sudo_env
		# cleanup .DS_Store files
		find . -type f -name '*.DS_Store' -ls -delete
		# empty trashes
		/usr/bin/sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
		# pycache cleanup

		# lscleanup
		/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
		true
		}

	maintenance() { cleanup && update; }
	background_update() { update >/dev/null 2>&1 & ; }
	background_cleanup() { cleanup >/dev/null 2>&1 & ; }
	background_maintenance() { background_cleanup && background_update >/dev/null 2>&1 & ; }

#? ######################## Session Tasks
	_login_message() { cat <<- EOF
		${CHERRY:-}
		========================================================${MAIN:-}
		os: ${LIME:-}$(uname -i) | $(sw_vers -productName) | $(sw_vers -productVersion)${MAIN:-}
		shell: ${ATTN:-}$(zsh --version | cut -d '(' -f 1))${MAIN:-}
		go: ${COOL:-}$(go version | cut -d ' ' -f 3 | cut -d 'o' -f 2)${MAIN:-}
		python: ${CANARY:-}$(python -V)${CHERRY:-}
		========================================================
		${LIME}
		--------------------------------------------------------${CANARY}
		Selected recently added utilities:${RESET}${ITALIC}${DIM}
			# Reminders to try out the latest features ...${RESET}
			${ATTN}
			recent              - see *more* utility additions / changes.${DARKGREEN}
			preman              - open man pages nicely formatted in Preview
			zsh_stats           - (from oh-my-zsh) list cli stats
			perf_test           - performance tests logged to ~/.perf_test_xxx.log
			repip               - reinstall updated pip and update all dependencies
			ldoc [FILES]        - local docs (move FILES out of iCloud)
			do_over [target]    - repeat something over and over ... and over
			log_urls            - logs urls from chrome constantly${RED}
			update_git_dirs     - update all git repos (!! I mean ALL !!)${RESET}
EOF
	}

	recent () { cat <<- EOF
		${LIME}
		--------------------------------------------------------${CANARY}
		Selected recently added utilities:
		${GREEN:-}
		Recently added:
			binit               - link a file to ~/bin and and chmod +x it
			bump                - update repo version (and changelog...)
			checkpath           - display and check \$PATH,
			checkpath.py        - display and check \$PATH (alternate version),
			do_over [target]    - repeat something over and over ... and over
			fd                  - find "\$PWD" -type d -name "\$1";
			ff                  - find "\$PWD" -type f -name "\$1";
			getURL              - gets url of active Chrome tab
			gitit               - add and commit all changes
			log_urls            - logs urls from chrome constantly
			login_message       - this message!!
			ping_avg            - average of ping times over COUNT attempts
			preman              - open man pages nicely formatted in Preview
			quickpret           - prettier (write, ignore unknown, hide errors)
			rc                  - repo clean (cache and temp files)
			repip               - repair and update pip packages in current env
			space [DEVICE]      - space remaining on drive
			sunday              - weekly maintenance scripts
			sysctl -a           - display a ton of system settings
			update_git_dirs     - update all git repos ${WARN}${REVERSED}DANGER${RESET}${LIME}
			versions            - to display program versions
EOF
	}
#? ######################## Daily Tasks
	daily_chores() {
		# TODO - really, this should be a cron job ... but, eh ...

		# set default log file name if not set
		ZDOTDIR=${ZDOTDIR:=$HOME/.dotfiles}
		DAILY_LOG_FILE=${ZDOTDIR}/.daily_check
		LOGFILE=$DAILY_LOG_FILE
		touch $LOGFILE

		if [ -r $LOGFILE ]; then
			log_line=$(tail -1 $LOGFILE)
			log_check="$nowdate"
			if [[ $log_line =~ "$log_check" ]]; then
				rain 'Your daily chores are done...'
			else
				rain "It's a new day! Performing daily updates and refreshes..."
				# TODO -- add daily update functions here ...
				(background_cleanup && printf '%b\n' "Daily tasks completed: $log_check") >>$LOGFILE
			fi
		fi
	}
#? ######################## Weekly Tasks
	sunday() {
		# TODO - really, this should be a cron job ... but, eh ...

		# set default log file name if not set
		ZDOTDIR=${ZDOTDIR:=$HOME/.dotfiles}
		SUN_LOG_FILE=${ZDOTDIR}/.sun_check
		LOGFILE=$SUN_LOG_FILE
		touch $LOGFILE

		if [ -r $LOGFILE ]; then
			# check last line of log file to see if this process
			#   has been completed earlier today...
			log_line=$(tail -1 $LOGFILE)

			log_check="${weekday}, ${nowdate}"
			if [[ $log_line =~ "$log_check" ]]; then
				rain 'Your Sunday chores are done...' >&6
			else
				loggedInUserID="$( scutil <<< "show State:/Users/ConsoleUser" | awk '/UID : / && ! /loginwindow/ { print $3 }' )"

				# Double check that the logged in user is NOT 'root' ...
				# this could lead to unexpected file permission errors ...
				if not_root && userid_not_root; then
					#! not allowed to run as root

					rain "It's Sunday! Performing weekly chores, updates, and refreshes..." >&6

					read -p "Are you sure you want to continue? <y/N> " prompt >&6
					if [[ "$prompt" =~ [yY](es)* ]]; then

						loggedInUser="$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"

						# add weekly update functions here ...
						cd $HOME

						# Find and delete all broken symbolic links in User Home
						blue "Pruning broken symlinks ..." >&6
						find_broken -d "$HOME"

						blue "Pruning empty directories in ${loggedInUser}'s home folder." >&6
						find "$HOME" -type d -uid ${loggedInUserID} -empty -exec rmdir --ignore-fail-on-non-empty -- {} +

						# Delete repo temp and cache files in User Home
						blue "Running RepoClean chores ..." >&6
						rc

						blue "Running python chores ..." >&6
						# python -m ${DOTFILES_INC}/sunday.py

						blue "Updating program version list <versions> ..." >&6
						save_versions

						#! .................................................................
						#! ....................begin root user portions ....................

						blue "Running system cleanup and update chores ..." >&6
						update

						#! .................................................................
						printf '%b\n' "Sunday chores completed: $log_check" >>$LOGFILE
					fi
				else
					echo "You cannot run $SCRIPT_NAME as a root user." >&6
					return 1;
				fi
			fi
		fi
	} 6>&1 >/dev/null 2>&1
#? ######################## MAIN LOOP
	_main_() {
		_login_message
		daily_chores
		[ $weekday='Sun' ] && sunday
		_debug_tests
	}
#? ######################## ENTRY POINT
	_main_ "$@"
	true

#? ######################## References
	# 'find types' https://www.gnu.org/software/findutils/manual/html_mono/find.html#Type
	# pipe $2 with $1 using |&  https://unix.stackexchange.com/questions/128975/why-doesnt-grep-using-pipe-work-here
	# mkdir ref: https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

	# ref: get url of Chrome active tab:
	# https://www.cyberciti.biz/faq/linux-unix-sleep-bash-scripting/
