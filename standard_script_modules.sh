#!/usr/bin/env bash
# -*- coding: utf-8 -*-
###############################################################################
# standard_script_modules : selected functions for macOS bash scripts
#   (function list at the end)
# version 0.8.0
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################
source "$(which bt)" || source "$src/bt" # basic_text_colors.sh
[[ -z "$DEBUG" ]] && DEBUG='0'           # set to 1 for debug and verbose testing
VERSION='0.8.0'

function die() {
    # https://stackoverflow.com/questions/7868818/in-bash-is-there-an-equivalent-of-die-error-msg/7869065
    local message=$1
    [ -z "$message" ] && message="Died"
    ce "${WARN}${message}" >&2
    ce "${MAIN}line ${BLUE}${BASH_LINENO[0]}${MAIN} in ${BASH_SOURCE[1]}:${ATTN}${FUNCNAME[1]}${MAIN}." >&2
    exit 1
}

function log_toggle() {
    #   usage: log_toggle [filename]
    #   toggle on and off logging to file
    #       parameter
    #           filename    - name of new logfile (default LOGFILE)
    #       variable $LOG stores state
    #       variable $LOGFILE stores filename
    #   reference: https://unix.stackexchange.com/questions/80988/how-to-stop-redirection-in-bash

    # set default log filename or $1
    [[ -z "$1" ]] && LOG_FILE_NAME='LOGFILE.log' || LOG_FILE_NAME="${1}"
    # if log is on, turn it off
    if [[ "$LOG" == '1' ]]; then
        LOG='0'
        exec >&3 2>&4
        attn "logging off ..."
    else # if it is off ... turn it on
        LOG='1'
        exec 3>&1 4>&2
        # log to the filename stored in $LOG_FILE_NAME
        db_echo "\${LOG_FILE_NAME}: ${LOG_FILE_NAME}"
        exec > >(tee -a -i "${LOG_FILE_NAME}") 2>&1
        attn "logging on ..."
    fi
}
function parse_filename() {
    #   usage: parse_filename [filename]
    #   parameter
    #       filename    - $1 or global $filename used
    #   returns
    #       base_name   - file name only (no path)
    #       dir         - path only
    #       name_only   - name without extension
    #       extension   - file extension or '' if none

    # set filename
    [[ -n "$1" ]] && filename="$1"
    # if no filename, error & exit
    [[ -z "$filename" ]] && exit_usage "\$filename not available or specified ..." "${MAIN}parse_filename ${WHITE}[filename]"
    base_name="${filename##*/}"
    # Strip longest match of */ from start
    dir="${filename:0:${#filename}-${#base_name}}"
    # Substring from 0 thru pos of filename
    name_only="${base_name%.[^.]*}"
    # Strip shortest match of . plus at least one non-dot char from end
    extension="${base_name:${#name_only}+1}"
    # Substring from len of base thru end
    if [[ -z "$name_only" && -n "$extension" ]]; then
        # If we have an extension and no base, it's really the base
        name_only="$extension"
        extension=""
    fi
}
function get_safe_new_filename() {
    # usage: get_safe_new_filename filename /path/to/file [extension]
    #   returns
    #       $new_safe_name      - new file name WITH path and extension
    #       $new_safe_name_only - new file name (no path / ext)
    #   eliminates duplicates by adding integers to filename as needed
    #   (e.g. file_2, file_3 ...)
    if [[ "$#" > 1 ]]; then
        safe_name="$1"
        safe_path="$2"
        [[ -z "$3" ]] && safe_ext='' || safe_ext=".$3"
        new_safe_name="${safe_path}/${safe_name}${safe_ext}"
        declare -i i=2
        while [ -f "$new_safe_name" ]; do
            new_safe_name="${safe_path}/${safe_name}_${i}${safe_ext}"
            i=$((i + 1))
        done
        new_safe_name_only="${safe_name}_${i}"
    else
        exit_usage "Invalid parameters ..." "usage: ${MAIN}get_safe_new_filename ${WHITE}filename /path/to/file [extension]"
    fi
}
function urlencode() {
    python -c "import sys, urllib as ul; print ul.quote_plus('$1');"
}
function db_echo() {
    # report data and errors in scripting
    #    - DEBUG is set to '1' to report errors
    #    - use log_toggle() to include file logging
    [[ $DEBUG == '1' ]] && warn "$(date "+%D %T") $@"
}
function usage() {
    # Print script usage test
    # Parameters:
    #   $1 - specific message (e.g. 'file not found')
    #   $2 - optional usage text
    [[ -n "$1" ]] && warn "$1"
    if [[ -z "$2" ]]; then
        ce "$_EXIT_USAGE_TEXT"
    else
        shift
        ce "$@"
    fi
    br
}
function exit_usage() {
    usage "$@"
    exit 1
}
function _alt_colors() {
    MAIN=$(echo -en '\001\033[38;5;229m')
    WARN=$(echo -en '\001\033[38;5;203m')
    BLUE=$(echo -en '\001\033[38;5;38m')
    WHITE=$(echo -en '\001\033[37m')
    PURPLE=$(echo -en '\001\033[38;5;93m')
    RESET=$(echo -en '\001\033[0m\002')
}
function _test_standard_script_modules() {
    # add tests for these functions as needed
    ce "Script source:$MAIN $BASH_SOURCE$RESET"
    # _SAMPLE_USAGE_TEXT='Sample Usage Text'
    db_echo "Testing db_echo. (red text if \$DEBUG='1') - currently '$DEBUG'"
    usage
}

function _main_standard_script_modules() {
    filename="$BASH_SOURCE"
    parse_filename
    _script_source="$dir"
    _script_name="$base_name"
    _bin_path="$HOME/bin/utilities/pc_bak"

    # sample usage text
    _EXIT_USAGE_TEXT="${MAIN}${_script_name}${WHITE} - macOS script"
    if [[ "$DEBUG" == '1' ]] || [[ "$1" == 'test' ]]; then
        _test_standard_script_modules
    fi
}

_main_standard_script_modules "$@"

###### basic_text_colors.sh #############################################
# FUNCTIONS         PARAMETERS and OPTIONS
# text colors       - MAIN, WARN, COOL, BLUE, GO, CHERRY, CANARY, ATTN,
#                   - PURPLE, WHITE, RESTORE, RESET
# br                - print blank line (CLI \n)
# ce                - $@ (color echo - generic color as $1, etc.)
# me, we, he, be,   - $@ (color echo - specific color)
#   ge, oe, pe, ye
###### standard_script_modules.sh #############################################
# FUNCTIONS         PARAMETERS and OPTIONS
# db_echo $@        - (if DEBUG='1') echo $@ in red
# usage $1 $2       - echo $1 and $2 (default _EXIT_USAGE_TEXT)
# exit_usage $1 $2  - call <usage> then exit 1

# function log_toggle()
#   usage: log_toggle [filename]
#   toggle on and off logging to file
#       parameter
#           filename    - name of new logfile (default LOGFILE)
#       variable $LOG stores state
#       variable $LOGFILE stores filename
#
# function parse_filename()
#   usage: parse_filename [filename]
#   parameter
#       filename    - $1 or global $filename used
#   returns
#       base_name   - file name only (no path)
#       dir         - path only
#       name_only   - name without extension
#       extension   - file extension or '' if none
#
# function get_safe_new_filename()
#   usage: get_safe_new_filename filename /path/to/file [extension]
#       returns
#           $new_safe_name      - new file name WITH path and extension
#           $new_safe_name_only - new file name (no path / ext)
#       eliminates duplicates by adding integers to filename as needed
#       (e.g. file_2, file_3 ...)

<<-sample_usage_text

${MAIN}NAME${WHITE}
    $name - convert plist files

${MAIN}SYNOPSIS${WHITE}
    $name SOURCE [FORMAT] [MINE]

${MAIN}DESCRIPTION${WHITE}
    Convert macOS plist file SOURCE to the optional FORMAT requested. The
    default format is xml1. If the file is already in the requested format,
    nothing is done. If the format requested is available, the file is
    translated and a copy is written with a new extension that reflects the
    new format.

    ${MAIN}SOURCE${WHITE} - existing plist file
    ${MAIN}FORMAT${WHITE} - optional {xml1 | binary1 | json}
        format in macOS naming format (default is xml1)
    ${MAIN}MINE${WHITE} - set to 'mine' to retain (non-sudo) ownership of the
        new file (default is current owner) (rarely needed)

    note: As tested, it is not possible to use a json file as *input*.

sample_usage_text

# References
# https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash
