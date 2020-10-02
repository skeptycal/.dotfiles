#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? ################# .functions - functions for macOS with zsh ###############
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#? ######################## https://www.github.com/skeptycal #################
	SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green $(type -a git)
		fi
	}
#? ###################### copyright (c) 2019 Michael Treanor #################


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

if [[ "$(git-achievements --help >/dev/null 2>&1 )" -ne 0 ]]; then
    alias git='git-achievements '
fi

if [[ "$(hash git &>/dev/null)" -eq 0 ]]; then
    # use git diff if available
	diff() { git diff --no-index --color-words "$@"; }

    # check for a git repo
    gs() { git status >/dev/null 2>&1; }
    # check for git status 'nothing to commit'
    gsok() { git status | grep 'nothing to commit'; }
    # check git status of directory $1
    gstdir() { [[ -d $1 ]] && ( cd $1; gs ); }

    gitit_f() {
        if ! [ -r "$PWD/.git" ]; then
            warn "Git repo not found in .../${PWD##*/}/.git"
        else
            gsok
            if [ $? -eq 0 ]; then
                canary "git status ${GO:-}OK${RESET:-}: $PWD"
            else
                # -m "${*:-'Gitit bot: minor updates and formatting.'}"
                message="${*:-$(cat ~/.dotfiles/.stCommitMsg)}"
                blue "GitIt - add and commit all updates."
                green "  repo: ${PWD##*/}"
                green "  message: "
                green "$message"
                [ -f .pre-commit-config.yaml ] || cp  $TEMPLATE_DIR/.pre-commit-config.yaml .

                git stash
                # catch any changes from the server (rare for me; I work alone a lot)
                git pull --rebase
                git apply

                # first run through catches errors that are autofixed
                git add --all >/dev/null 2>&1
                pre-commit >/dev/null 2>&1

                # second time shows persistent errors ...
                git add --all
                pre-commit

                git commit -m "$message" # --gpg-sign=$(which gpg_private)
                git push --set-upstream origin "$(git_current_branch)"
                git status
            fi
        fi
        }

    # ghget () {
    # 	# input: rails/rails
    # 	USER=$(echo "$@" | tr "/" " " | awk '{print $1}')
    # 	REPO=$(echo "$@" | tr "/" " " | awk '{print $2}')
    # 	cd "$HOME/src/github.com/$USER" || return
    # 	hub clone "$@" || return
    # 	cd "$REPO" || return
    # 	}
    update_git_dirs() { #! careful ...
        #! this function does a lot of automated git updates!
        # - finds all git repos in user's home directory
        # - changes to each directory
        # - performs 'git add -all'
        # - commits all files with an automated message
        # - pull --rebase to update then push to remote

        # - all stdout and stderr is silenced
        # - use &6 to force output to terminal

        TEMPLATE_DIR=~/Documents/coding/cc_template
        EXCLUDES='.virtualenvs node_modules .venv'

        OLD_DIR=$PWD
        cd "$HOME" || return
        lime "Locating all git repos in home directory ..." >&6
        git_dirs=$(find . -type d -name ".virtualenvs" -prune -o -name ".git" | sed 's/\.git//')
        green ${git_dirs//.\//\\n}
        for i in $(find . -type d -name ".virtualenvs" -prune -o -name ".git" | sed 's/\.git//'); do
            attn "Going into $i" >&6
            cd "$i" || return

            gitit "Gitit Bot: weekly update - minor / formatting" >&6

            git stash >&6
            git pull origin master --rebase >&6
            git stash apply >&6

            [ -f .pre-commit-config.yaml ] || cp $TEMPLATE_DIR/.pre-commit-config.yaml .
            pre-commit autoupdate

            gitit >&6
            cd ~
        done
        cd "$OLD_DIR"
        } 6>&1 >/dev/null 2>&1
    git_one() {
        # TODO work in progress
        # to keep from delaying a commit due to one file that won't pass pre-commit
        FILES=$(gaa -n)
        FILES="${FILES[*]/5/-1}"
        for file in $FILES; do
            fixed_file=${file/5/-1}
            echo "$fixed_file"
        done
        }
    parse_git_branch(){
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /';
        }
    parse_svn_rev(){
        svn info 2> /dev/null | grep "Revision" | sed 's/Revision: \(.*\)/[r\1] /';
        }
    parse_git_branch() {
        BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        if [ ! "${BRANCH}" == "" ]; then
            STAT=$(parse_git_dirty)
            echo "[${BRANCH}${STAT}]"
        else
            echo ""
        fi
        }
    parse_git_dirty() {
        status_dirty=$(git status 2>&1 | tee)
        dirty=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "modified:" &>/dev/null
            echo "$?"
        )
        untracked=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "Untracked files" &>/dev/null
            echo "$?"
        )
        ahead=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null
            echo "$?"
        )
        newfile=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "new file:" &>/dev/null
            echo "$?"
        )
        renamed=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "renamed:" &>/dev/null
            echo "$?"
        )
        deleted=$(
            echo -n "${status_dirty}" 2>/dev/null | grep "deleted:" &>/dev/null
            echo "$?"
        )
        bits=''
        if [ "${renamed}" == "0" ]; then
            bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
            bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
            bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
            bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
            bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
            bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
            echo " ${bits}"
        else
            echo ""
        fi
        }
fi
_debug_tests
true
