#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ---------------------------------------> crontab script
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

echo "every day counts ..."

# source 'versions.sh' to update '.VERSION_LIST.md' file
# ~/.dotfiles/easycron/easycron/cron_versions.sh

cd $HOME

# prevent access to any version of python in virtual environment
VENV_PATH="lib/python"

COMMAND="rm -rfv {}"

clean(){ # usage: clean NAME [TYPE (default d)]
    find . \! -path "*${VENV_PATH}*" -name "$1" -type ${2:-d} -print0 | xargs -0n1 -P8 echo
	# zargs -e.. "$1" .. echo --
}

# todo - use zargs from zsh
# function zargit () {
# }

# cleanup .DS_Store files
# find $HOME -type f -name "*.DS_Store" -exec rm -rfv {} +
clean '*.DS_Store' 'f'

# python build and pypa
clean build
clean dist

# python cache files
clean .mypy_cache
clean .pytest_cache
clean __pycache__

# python builds
clean '*.egg-info'

# tox environments
clean .tox

# python bytecode files
clean '*.py[co]' 'f'

# pre-commit cache cleanup
rm -rf ${HOME}/.cache/pre-commit/*

# empty trashes
rm -rfv $HOME/.Trash;
sqlite3 $HOME/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
