#!/usr/bin/env bash
# -*- coding: utf-8 -*-
source "$(which bt)" || source "${PWD}/src/bt" # basic_text_colors.sh
#? ############################# skeptycal.com ################################
NAME="${BASH_SOURCE##*/}"
VERSION='0.8.0'
DESC='standard script modules for macOS bash scripts'
USAGE="source ${NAME} [help|test|usage|version]"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="Copyright (c) 2019 Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"
#? #### standard_script_modules.sh contents ###################################
#? ############################################################################
DEBUG='1' # set to 1 for verbose testing
# [[ "$DEBUG" == '1' ]] && set -v

_ssm_initialize() {
    # setup global functions and variables
    # functions beginning with _ are only called 'by the script'
    # others are reusable in any script as needed
    filename="$BASH_SOURCE"
    parse_filename "$filename"
    _script_source="$dir"
    echo "\$dir: $dir"
    src="${dir}src"
    _script_name="$base_name"
    _bin_path="$HOME/bin/utilities/pc_bak"
}
function die() {
    # exit program with $exit_code ($1) and optional $message ($2)
    # https://stackoverflow.com/questions/7868818/in-bash-is-there-an-equivalent-of-die-error-msg/7869065
    exit_code=${1:-1}
    message=${2:-"Script died...$USAGE"}

    ce "${WARN}${message}" >&2
    ce "${MAIN}line ${BLUE}${BASH_LINENO[0]}${MAIN} of ${ATTN}${FUNCNAME[1]}${MAIN} in ${BASH_SOURCE[1]}${MAIN}." >&2
    [[ ! "$DONT_DIE" == '1' ]] && exit "$exit_code"
}
yes_no() {
    # Accept a Yes/no (default Yes) user response to prompt ($1 or default)
    echo -n "${1:-'[Yes/no]: '}"
    read yno
    case $yno in
    # [yY] | [yY][Ee][Ss])
    #     return 0
    #     ;;
    [nN] | [n | N][O | o])
        return 1
        ;;
    *) # default 'Yes' ... see function no_yes for default 'No'
        return 0
        ;;
    esac
}
no_yes() {
    # Accept a yes/No (default No) user response to prompt ($1 or default)
    echo -n "${1:-'[No/yes]: '}"
    read yno
    case $yno in
    [yY] | [yY][Ee][Ss])
        return 1
        ;;
    # [nN] | [n | N][O | o])
    #     return 1
    #     ;;
    *) # default 'No' ... see function yes_no for default 'Yes'
        return 0
        ;;
    esac
}
function hex_dump() { [[ -r "$1" ]] && od -A x -t x1z -v "$1"; }
function log_toggle() {
    #   usage: log_toggle [filename]
    #   toggle on and off logging to file
    #       parameter
    #           filename    - name of new logfile (default LOGFILE)
    #       variable $LOG stores state
    #       variable $LOGFILE stores filename
    #   reference: https://unix.stackexchange.com/questions/80988/how-to-stop-redirection-in-bash

    # set default log filename or $1
    if [[ -z "$1" ]]; then
        if [[ -z "$LOG_FILE_NAME" ]]; then
            LOG_FILE_NAME='${_script_source}LOGFILE.log'
        fi
    else
        LOG_FILE_NAME="${1}"
        touch "$LOG_FILE_NAME"
    fi
    # if log is on, turn it off
    if [[ "$LOG" == '1' ]]; then
        LOG='0'
        exec >&3 2>&4
        attn "logging off ..."
    else # if it is off ... turn it on
        LOG='1'
        exec 3>&1 4>&2
        exec 3>&- 4>&-

        # log to the filename stored in $LOG_FILE_NAME
        db_echo "\${LOG_FILE_NAME}: ${LOG_FILE_NAME}"
        exec > >(tee -a -i "${LOG_FILE_NAME}") 2>&1
        attn "logging on ..."
    fi
}

function real_name() {
    # test_var "$1"
    # log_flag
    filename="${!1}"
    echo $filename
    filename="${1##*/}"
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
    test_var "$filename"
    log_flag
    [[ -r "$filename" ]] && exit_usage "\$filename not readable ..." "${MAIN}parse_filename ${WHITE}[filename]"
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
function url_encode() {
    [[ -z "$1" ]] && return 1
    encoded=$(php -r "echo rawurlencode('$1');") && return 0 || return "$EX_DATAERR"
}
function url_decode() {
    [[ -z "$1" ]] && return 1
    decoded=$(php -r "echo rawurldecode('$1');") && return 0 || return "$EX_DATAERR"
}
function db_echo() {
    # report data and errors in scripting
    #    - DEBUG is set to '1' to report errors
    #    - use log_toggle() to include file logging
    [[ $DEBUG == '1' ]] && warn "$(date "+%D %T") $@"
}
function test_echo() {
    # log the current value of a given variable ($1)
    # usage: test_echo <test name> <test code>
    # report test results if:
    #    - DEBUG is set to '1' or cli [test] option set
    #    - use log_toggle() to include file logging
    if [[ $DEBUG == '1' ]] && [[ -n "$1" ]]; then
        printf "%bFunction Test -> %bPID %s %b" "$MAIN" "$CANARY" "$$" "$GO"
        printf '%(%Y-%m-%d)T' -1
        printf "%b test name: %s\n%b" "$ATTN" "$1" "$RESET"
        shift
        local
        eval "$@"
        printf "%bResult = %s%b\n" "$COOL" "$?" "${RESET}"
    fi
}
function test_var() {
    # usage: test_var <test variable>
    # report test results if:
    #    - DEBUG is set to '1' or cli [test] option set
    #    - use log_toggle() to include file logging
    # reference:
    #   indirect variables: https://wiki.bash-hackers.org/syntax/pe#indirection
    #   bash printf: https://www.linuxjournal.com/content/bashs-built-printf-function
    if [[ $DEBUG == '1' ]] && [[ -n "$1" ]]; then
        local testvar="${1}"
        echo "\$testvar: $testvar"
        echo "testvar: " ${!testvar}
        echo ''
        echo ''
        printf "%bVariable Test -> %bPID %s %b" "$MAIN" "$CANARY" "$$" "$GO"
        printf '%(%Y-%m-%d)T' -1
        printf "%b %15s -%b %s %b\n" "$ATTN" "\$$testvar" "$WARN" "$testvar" "$RESET"
    fi
}
function exit_usage() {
    # Print script usage test
    # Parameters:
    #   $1 - specific message (e.g. 'file not found')
    #   $2 - optional usage text
    [[ -n "$1" ]] && warn "$1"
    if [[ -z "$2" ]]; then
        ce "$USAGE"
    else
        shift
        ce "$@"
    fi
    br

}
function print_usage() {
    set_man_page
    echo "$MAN_PAGE"
    exit 1
}
log_flag() {
    rain "#? ############################################################################"
}
function _test_standard_script_modules() {

    # sample usage text
    _EXIT_USAGE_TEXT="${MAIN}${_script_name}${WHITE} - macOS script"
    # log file for test sesssion
    LOG_FILE_NAME="${_script_source}ssm_debug_test.log"
    # functions that include an 'exit' will skip it so tests can continue
    DONT_DIE='1'
    # log everything to LOG_FILE_NAME
    log_toggle

    ce "${COOL}BASH_SOURCE:$MAIN $BASH_SOURCE$RESET"
    log_flag

    test_var "$_script_name"
    test_var "$_script_source"
    test_var "$DEBUG"
    test_var "$DONT_DIE"
    test_var "$LOG"
    test_var "$LOG_FILE_NAME"

    # TODO add tests for these functions as needed
    test_echo "die() test" "die 'die test!'"
    test_echo "db_echo() test" "db_echo 'This is the test argument'"
    test_echo "urlencode() test" "url_encode 'http://www.github.com/skeptycal'"
    db_echo "$encoded"
    test_echo "urlencode() test" "url_decode 'http%3A%2F%2Fwww.github.com%2Fskeptycal'"
    db_echo "$decoded"
    fake_filename="$LOG_FILE_NAME"
    test_var "$fake_filename"
    test_echo "real_name() test" "real_name $fake_filename"

    log_flag
    result="${fake_filename##*/}"
    test_var "$result"

    # cleanup test environment
    log_toggle
    unset DONT_DIE
    unset LOG_FILE_NAME
    unset _EXIT_USAGE_TEXT
    unset LOG
}
function _main_standard_script_modules() {
    # [[ "$1" == 'test' ]] && DEBUG='1'
    _ssm_initialize
    [[ "$DEBUG" == '1' ]] && _test_standard_script_modules
    return 0
}

#* ############################################################################
#* ### Stuff to keep out of the way ...
usage_long_desc="$(
    cat <<usage_long_desc
    ${MAIN}$NAME${WHITE} sets and exports constants and functions that give access to
    novel and useful features simply by loading the module through a one line
    command: 'source ssm'

usage_long_desc
)"
usage_parameters="$(
    cat <<usage_parameters
    help      - display complete usage information (this!)
    test      - perform tests
    usage     - short usage instructions
    version   - display version information
usage_parameters
)"

_main_standard_script_modules "$@"

#? #### basic_text_colors.sh contents #########################################
# TODO automate creation of TOC
# FUNCTIONS         PARAMETERS and OPTIONS
# color constants   - ANSI constants for common colors
#                       MAIN, WARN, COOL, BLUE, GO, CHERRY, CANARY, ATTN,
#                       PURPLE, RAIN, WHITE, RESTORE, RESET
# color functions   - functions for printing lines in common colors
#                       me (for main), warn, blue, green, cherry, canary,
#                       attn, purple, rain, white
# error messages    - C++ style error messages
# br                - print blank line (CLI \n)
# ce                - $@ (color echo - generic color as $1, etc.)
# set_man_page      - set $MAN_PAGE based on docblock variables
# parse_options     - parse basic options [test|usage|version|help] & DEBUG
#? ############################################################################
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
# encoding urls: https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command
