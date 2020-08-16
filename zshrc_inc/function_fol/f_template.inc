#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034

# ssm - standard script modules
. "$(command -v ssm)"

# profile start time
t0=$(date "+%s.%n")

export YEAR=$(date "+%Y")
export REPO_TEMPLATE_LOCATION=~/Documents/coding/template

export DEFAULT_REPO_FILE_LIST=( .editorconfig .pre-commit-config.yaml AUTHORS CHANGELOG.md CODE_OF_CONDUCT.md LICENSE azure-pipelines.yml conftest.py pytest.ini requirements-dev.txt setup.py setup.sh tox.ini toxcov.ini README.md .gitignore pyproject.toml )

dprintf() {
    printf '%b' "$WARN"
    if [ -n "$1" ]; then
        printf ' -> %s' "$1"
        shift
    fi
    for arg in "$@"; do
        printf ' %s' "$arg"
    done
    printf '%s\n' ''
    }

echo() {
    # more portable 'echo'
    if [ -n "$1" ]; then
        printf '%s' "$1"
        shift
    fi
    for arg in "$@"; do
        printf ' %s' "$arg"
    done
    printf '%s\n' ''
    }

link_tmp_to_repo() {
    # create files in current directory based on template repo
    echo $LIME
    for f in $@; do
        # copy with hard links as 1st choice
        # interactice, recursive, verbose
        cp -irv --link "${REPO_TEMPLATE_LOCATION}/${f}" .

        if [ ! -r $f ]; then # copy with symlinks as 2nd choice
            # no-clobber, recursive, verbose
            cp -nrv --symbolic-link "${REPO_TEMPLATE_LOCATION}/${f}" .
        fi

        if [ ! -r $f ]; then # copy files as 3rd choice
            # no-clobber, recursive, verbose
            cp -nrv "${REPO_TEMPLATE_LOCATION}/${f}" .
        fi
    done;
    echo $RESET
}

send_to_temp() {
    # update files in template repo based on current directory
    for f in $@; do
        # force, recursive, verbose
        cp -frv "${f}" "${REPO_TEMPLATE_LOCATION}/"
    done;
}

_get_repo_template() {
    #TODO This is a preset template directory - prefer github repo
    for f in $repo_file_list; do
        if [ -e "$f" ]; then
            attn "$f already exists in the destination folder."
        else
            echo "cp -ri" "${REPO_TEMPLATE_LOCATION}/${f}" "$repo_path" #! not activated ... remove <echo> ...
        fi
    done


    # github repo template
    }
_config() {
    # Setup path names and constants
    [[ $SET_DEBUG == 1 ]] && _set_debug "$@"
    SHELL_BIN="${SHELL##*/}" && export SHELL_BIN

    #TODO - check for $1 repo name, etc
    repo_path=$PWD
    repo_name=${PWD##*/}
    dprintf "\$repo_path = $repo_path"
    dprintf "\$repo_name = $repo_name"
    }

main() {
    SET_DEBUG=1
    br
    lime "**************************  Setup Github/Python repo **************************"
    _config "$@"
    dprintf "\$repo_path = $repo_path"
    dprintf "\$repo_name = $repo_name"
    _get_repo_template
    br

    blue "Template location:"
    ls $repo_template_location
    blue "Repo location:"
    ls "$repo_path"
    _end_timer
}

#* ##############################################################################
#? ${PATH//:/\\n}    - replace all colons with newlines to display as a list
#? ${PATH// /}       - strip all spaces
#? ${VAR##*/}        - return only final element in path (program name)
#? ${VAR%/*}         - return only path elements in path (without program name)
