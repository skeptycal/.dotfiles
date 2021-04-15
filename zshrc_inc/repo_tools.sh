#!/usr/bin/env false sh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> repo_tools - tools for repo management for macOS with zsh
	#*	system functions
	#*  tested on macOS Big Sur and zsh 5.8
	#*	copyright (c) 2021 Michael Treanor
	#*	MIT License - https://www.github.com/skeptycal
#? -----------------------------> https://www.github.com/skeptycal
#? -----------------------------> environment
    . "${DOTFILES_INC}/ansi_colors.sh" || . $(which ansi_colors.sh)
	. "${DOTFILES_INC}/github_config_secret.sh" || . $(which github_config_secret.sh)

    SCRIPT_NAME=${0##*/}
#? -----------------------------> debug info
	declare -ix SET_DEBUG=${SET_DEBUG:-0}  		# set to 1 for verbose testing

	_debug_tests() {
		if (( SET_DEBUG > 0 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green "Today is $today"
			_test_args "$@"
			dbecho "DEBUG mode is enabled. Set it to 0 to disable these messages."
			dbecho ""
			dbecho "ANSI colors active: $(which ansi_colors.sh)"
		fi
		}

#? -----------------------------> parameter expansion tips
 #? ${PATH//:/\\n}    - replace all colons with newlines
 #? ${PATH// /}       - strip all spaces
 #? ${VAR##*/}        - return only final element in path (program name)
 #? ${VAR%/*}         - return only path (without program name)

#? -----------------------------> repo management
	: <<-'DISABLED'
		#/ gi() is defined in the zsh .gitignore plugin as:
		# function gi() { curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}" }

		gi () {
			curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}"
			}
	DISABLED

	is_empty_dir() {
		[ -z "$(ls -A ${1:-$PWD})" ]
	}

	#* custom file header for Go, Python, etc.
	#* Usage: _file_blurb [comment_char] [shebang]
	_file_blurb() {
		# if a different comment string is desired, pass as $1
		# The default // is used for Go
		_comment=${1:='//'}
		_shebang=
		exists "$2" && _shebang='#!/usr/bin/env '"${2}\n"

		cat <<-EOF
			${_shebang}${_comment} Copyright (c) $( date +"%Y" ) ${AUTHOR}
			${_comment} ${AUTHOR_URL}
			${_comment} ${LICENSE} License

		EOF
	}

	#* combine personal .gitignore items with the api defaults
	makeGI() {
		cat >|.gitignore <<-EOF
			############################################
			$( _file_blurb '#' )

			### Personal ###
			**/[Bb]ak/
			**/*.bak
			**/*temp
			**/*tmp
			**/.waka*

			### Repo Specific ###
			**/idea.md

			### Security ###
			**/*[Tt]oken*
			**/*[Pp]rivate*
			**/*[Ss]ecret*
			*history*
			*hst*

			############################################
		EOF
		gi macos linux windows ssh vscode go zsh node vue nuxt python django flask yarn laravel git >>.gitignore
	}

	gac() { # git add and commit; message is $1 or default
		_message=${1:=$_default_commit_message}

		git add --all
		git commit -m "${_message}"
		git push --set-upstream origin $(git_current_branch)
		git push origin --all
		git push origin --tags
	}
	_gh_auth_username() {
		_gh_user=$( gh auth status 2>&1 | grep "Logged in to github.com as" | awk '{ print $7 }'; )
	}

		is_empty_dir() {
		[ -z "$(ls -A ${1:-$PWD})" ]
	}
	_file_blurb() {
		# if a different comment string is desired, pass as $1
		# The default // is used for Go
		default_comment='//'

		_comment=${1:=$default_comment}

		cat <<-EOF
			${_comment} Copyright (c) $( date +"%Y" ) ${AUTHOR}
			${_comment} ${AUTHOR_URL}
			${_comment} ${LICENSE} License

		EOF
	}

	gac() { # git add and commit; message is $1 or default
		_message=${1:=$_default_commit_message}

		git add --all
		git commit -m "${_message}"
		git push --set-upstream origin $(git_current_branch)
		git push origin --all
		git push origin --tags
	}

	_gh_auth_username() {
		_gh_user=$( gh auth status 2>&1 | grep "Logged in to github.com as" | awk '{ print $7 }'; )
	}

#? -----------------------------> main
	(( SET_DEBUG > 0 )) && _debug_tests "$@"
	true
