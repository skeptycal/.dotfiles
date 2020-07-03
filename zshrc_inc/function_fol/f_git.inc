#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

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

# use git diff if available
if [[ "$(hash git &>/dev/null)" -eq 0 ]]; then
    function diff() {
        git diff --no-index --color-words "$@"
    }
fi
gstdir(){
    if [ -n $1 ]; then
        cd $1;
        $(git status >/dev/null 2>&1; echo $?;)
    fi
}

gitit() {
    if ! [ -d "$PWD/.git" ]; then
        echo $!
        warn "Git repo not found in .../${PWD##*/}/.git"
    else
        git status
        if [ $? -ne 0 ]; then # >/dev/null 2>&1
            warn "Git status error: $PWD"
        else
            # -m "${*:-'Gitit bot: minor updates and formatting.'}"
            message="${*:-$(cat ~/.dotfiles/.stCommitMsg)}"
            blue "GitIt - add and commit all updates."
            green "  repo: ${PWD##*/}"
            green "  message: "
            green "$message"
            git add --all >/dev/null 2>&1
            pre-commit >/dev/null 2>&1
            git add --all
            pre-commit
            git commit -m "$message" --gpg-sign=$(git_gpg.php)
            git push --set-upstream origin "$(git_current_branch)"
            git status
        fi
    fi
    }

ghget () {
    # input: rails/rails
    USER=$(echo "$@" | tr "/" " " | awk '{print $1}')
    REPO=$(echo "$@" | tr "/" " " | awk '{print $2}')
    mcd "$HOME/src/github.com/$USER" || return
    hub clone "$@" || return
    cd "$REPO" || return
    }

parse_git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /';
    }

parse_svn_rev(){
    svn info 2> /dev/null | grep "Revision" | sed 's/Revision: \(.*\)/[r\1] /';
    }

update_git_dirs() {
    # so what the below does is finds all files named .git in my home
    # directory, but excludes the .virtualenvs folder then strips the .git from
    # the end, cd's into the directory, pulls from the origin master, then
    # repeats

    OLD_DIR=$(pwd)
    cd ~ || return
    for i in $(find . -type d -name ".virtualenvs" -prune -o -name ".git" | sed 's/\.git//'); do
        echo "Going into $i"
        cd "$i" || return
        git pull origin master
        cd ~ || return
    done
    cd "$OLD_DIR" || return
    }

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
    status=$(git status 2>&1 | tee)
    dirty=$(
        echo -n "${status}" 2>/dev/null | grep "modified:" &>/dev/null
        echo "$?"
    )
    untracked=$(
        echo -n "${status}" 2>/dev/null | grep "Untracked files" &>/dev/null
        echo "$?"
    )
    ahead=$(
        echo -n "${status}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null
        echo "$?"
    )
    newfile=$(
        echo -n "${status}" 2>/dev/null | grep "new file:" &>/dev/null
        echo "$?"
    )
    renamed=$(
        echo -n "${status}" 2>/dev/null | grep "renamed:" &>/dev/null
        echo "$?"
    )
    deleted=$(
        echo -n "${status}" 2>/dev/null | grep "deleted:" &>/dev/null
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
