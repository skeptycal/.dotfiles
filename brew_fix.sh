#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
BASH_SOURCE="$0" # to ease the transition to zsh
###############################################################################
# brew_fix : update, clean, and fix HomeBrew for macOS bash scripts
#   node / npm often breaks when updating brew repos:
#   use brew_fix -npm to reinstall node / npm
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################

# DEBUG='' # set to 1 for debug output
version='1.1.0'
DEBUG='0'

here=$PWD

if [[ $DEBUG == '1' ]]; then
    # set -v
    ce "Script source:$MAIN $BASH_SOURCE$RESET"
    # db_echo "debug: $DEBUG"
    # db_echo "_script_source: $_script_source"
    # db_echo "_script_name: $_script_name"
    # db_echo "_bin_path: $_bin_path"
    # db_echo "here: $here"
    # db_echo "PWD: $PWD"
    # db_echo "\$#: $#"
    # db_echo "\$0: $0"
    # db_echo "\$1: $1"
    # db_echo "\$2: $2"
    # db_echo "\$(whoami): $(whoami)"
    green "\$(brew --prefix): $(brew --prefix)"
    # db_echo "brew folder list: ${ATTN}" $(brew --prefix)/*
    # stat $(brew --prefix)/* | head -4 | cut -d ' ' -f 1-5
fi
# Activate Sudo Environment (often required)
# change this if you don't require it
sudo_env='true'

function brew_fix() {
    me "Update Homebrew"
    purple "==============="
    green "version 1.1.0"
    green "copyright (c) 2019 Michael Treanor"
    attn "Checking HomeBrew file structure (sudo)..."
    sudo chown -R $(whoami) $(brew --prefix)/*
    attn "Checking repo structures ..."
    brew doctor
    attn "Removing outdated downloads ..."
    brew cleanup
    attn "Upgrading all repos as needed ..."
    brew upgrade $(brew list)
    if [[ "$1" == '-npm' ]]; then
        attn "Reinstalling npm (node is commonly corrupted during updates) ..."
        brew reinstall npm
    fi
    br
    me "Brew_Fix Complete"
    purple "================="
    brew config
}

# brew_fix "$1" # only one option allowed at this time

###### basic_text_colors.sh #############################################
# FUNCTIONS         PARAMETERS and OPTIONS
# text colors       - MAIN, WARN, COOL, BLUE, GO, CHERRY, CANARY, ATTN,
#                   - PURPLE, WHITE, RESTORE, RESET
# br                - print blank line (CLI \n)
# ce                - $@ (color echo - generic color as $1, etc.)
# various           - $@ (color echo - specific color)
###### standard_script_modules.sh #############################################
# FUNCTIONS         PARAMETERS and OPTIONS
# db_echo $@        - (if DEBUG='1') echo $@ in red
# exit_usage $1     - echo _EXIT_USAGE_TEXT and $1 then exit 1
