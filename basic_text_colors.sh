#!/usr/bin/env bash
###############################################################################
# basic_text_colors : selected ansi text color shortcuts for macOS
# version 0.9.5
# usage:
#           source "$(which basic_text_colors.sh)"
#           OR source "/path/to/script/basic_text_colors.sh"
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###### basic_text_colors.sh #############################################
# FUNCTIONS         PARAMETERS and OPTIONS
# fn_exists         - test if a function exists already
# text colors       - MAIN, WARN, COOL, BLUE, GO, CHERRY, CANARY, ATTN,
#                   - PURPLE, WHITE, RESTORE, RESET
# br                - print blank line (CLI \n)
# ce                - $@ (color echo - generic color as $1, etc.)
# various           - $@ (color echo - specific color)
###############################################################################
# DEBUG='1'

VERSION='0.9.5'

# TODO testing these two
function fn_exists() {
    declare -f $1 >/dev/null
}

# TODO testing these two
is_function() {
    declare -F "$1" >/dev/null
}

function set_colors() {

    MAIN=$(echo -en '\001\033[38;5;229m') && export MAIN
    WARN=$(echo -en '\001\033[38;5;203m') && export WARN
    COOL=$(echo -en '\001\033[38;5;38m') && export COOL
    BLUE=$(echo -en '\001\033[38;5;38m') && export BLUE
    GO=$(echo -en '\001\033[38;5;28m') && export GO
    CHERRY=$(echo -en '\001\033[38;5;124m') && export CHERRY
    CANARY=$(echo -en '\001\033[38;5;226m') && export CANARY
    ATTN=$(echo -en '\001\033[38;5;178m') && export ATTN
    PURPLE=$(echo -en '\001\033[38;5;93m') && export PURPLE
    WHITE=$(echo -en '\001\033[37m') && export WHITE
    RESTORE=$(echo -en '\001\033[0m\002') && export RESTORE
    RESET=$(echo -en '\001\033[0m') && export RESET
    br() {
        # yes, this is a fake cli version of <br />
        printf '\n'
    }
    ce() {
        # ce - generic color echo (used manually or called from specific declare -x -f function)
        # if [ "$#" -gt 0 ]; then
        #     printf "%b " "$1"
        #     shift
        # fi
        # if [ "$#" -gt 0 ]; then
        printf "%b " "${@}${RESET}"
        printf "\n"
        # fi
        # printf '\n'
    }
    me() {
        # MAIN echo
        ce "${MAIN}${@}"
    }
    warn() {
        # red WARN echo
        ce "${WARN}${@}"
    }
    blue() {
        # COOL blue echo
        ce "${COOL}${@}"
    }
    green() {
        # he CHERRY echo
        ce "${GO}${@}"
    }
    cherry() {
        # he CHERRY echo
        ce "${CHERRY}${@}"
    }
    canary() {
        # CANARY bird echo
        ce "${CANARY}${@}"
    }
    attn() {
        # orange ATTN echo
        ce "${ATTN}${@}"
    }
    purple() {
        # PURPLE rain echo
        ce "${PURPLE}${@}"
    }
    white() {
        # PURPLE rain echo
        ce "${WHITE}${@}"
    }
}
function _test_color_output() {
    # test_color_output - print samples of available colors
    echo -e "Script source:$MAIN $BASH_SOURCE$RESET"
    echo -e "${MAIN}C ${WARN}O ${COOL}L ${GO}O ${CHERRY}R   ${CANARY}T ${ATTN}E ${PURPLE}S ${RESET}T"
    echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${PURPLE}PURPLE   ${RESET}RESET"
}

function set_usage() {
    read $name
    read $version
    read $desc
    read $usage
    read $parameters
    read $license
    read $USAGE_TEXT
}

function _bt_usage() {
    set_usage <<-bt_usage_text
    ${BASH_SOURCE[1]}
    ce "${WHITE} selected ansi text color shortcuts for macOS"
    ce "${MAIN}usage:
    source \"$(which basic_text_colors.sh)\"
    OR source /path/to/script/basic_text_colors.sh"
bt_usage_text
}

function _main_text_colors() {
    set_colors
    export TEXT_COLORS_LOADED='1'
    [[ "$1" == 'version' ]] && _bt_usage
    if [[ "$DEBUG" == '1' ]] || [[ "$1" == 'test' ]]; then
        _test_color_output
    fi
}

_main_text_colors "$@"

###############################################################################
# basic_text_colors info
#
# color codes available - e.g. to use WARN in a string - echo "$WARN"
# MAIN, WARN, COOL, GO, CHERRY, CANARY, ATTN, PURPLE, RESET
#
# function list
# test_color_output # test_color_output - print samples of available colors
# echo # This makes echo more consistent and portable
# br # yes, this is a fake cli version of <br />
# ce # ce - generic color echo (used manually or called from specific function)
# me # MAIN echo
# we # red WARN echo
# be # COOL blue echo
# ge # GO green echo
# oe # orange ATTN echo
# pe # purple PURPLE echo
###############################################################################
# References:
#
# (Side note about the colors: The colors are preceded by an escape
#       sequence \e and defined by a color value, composed of [style;color+m]
#       and wrapped in an escaped [] sequence. eg.
# reference: https://stackoverflow.com/questions/1550288/os-x-terminal-colors
# && # Â€Âœexport -p command -- show all the exported variables.
# reference: https://www.thegeekstuff.com/2010/08/bash-shell-builtin-commands/
###############################################################################

# Resources
# <<colors
#     RESTORE=$(echo -en '\001\033[0m\002')
#     RED=$(echo -en '\001\033[00;31m\002')
#     GREEN=$(echo -en '\001\033[00;32m\002')
#     YELLOW=$(echo -en '\001\033[00;33m\002')
#     BLUE=$(echo -en '\001\033[00;34m\002')
#     MAGENTA=$(echo -en '\001\033[00;35m\002')
#     PURPLE=$(echo -en '\001\033[00;35m\002')
#     CYAN=$(echo -en '\001\033[00;36m\002')
#     LIGHTGRAY=$(echo -en '\001\033[00;37m\002')
#     LRED=$(echo -en '\001\033[01;31m\002')
#     LGREEN=$(echo -en '\001\033[01;32m\002')
#     LYELLOW=$(echo -en '\001\033[01;33m\002')
#     LBLUE=$(echo -en '\001\033[01;34m\002')
#     LMAGENTA=$(echo -en '\001\033[01;35m\002')
#     LPURPLE=$(echo -en '\001\033[01;35m\002')
#     LCYAN=$(echo -en '\001\033[01;36m\002')
#     WHITE=$(echo -en '\001\033[01;37m\002')
# colors
