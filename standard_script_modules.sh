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
# DEBUG='1'
_script_source="$(dirname "${BASH_SOURCE}")"
_script_name=$(basename $0)
_bin_path="$HOME/bin/utilities/pc_bak"

# sample usage text
_EXIT_USAGE_TEXT="${MAIN}NAME${WHITE}
    $_script_name - macOS script"

source_file "basic_text_colors.sh"

function _define_standard_functions() {
    function urlencode() {
        python -c "import sys, urllib as ul; print ul.quote_plus('$1');"
    }
    function db_echo() {
        # report and/or log data and errors in scripting
        #    - DEBUG is set to '1' to report errors
        #    - DEBUG_LOG is set to '1' to log errors (if DEBUG = '1')
        if [[ $DEBUG == '1' ]]; then
            # ce "Script source:$MAIN $BASH_SOURCE$RESET"
            warn "$(date "+%D %T") $@" 2>&1
            if [[ $DEBUG_LOG == '1' ]]; then
                echo -e "$(date "+%D %T")" 2>&1 >>$debug_log_file
                echo -e "$@\n" 2>&1 >>$debug_log_file
                # TODO check filesize and chop off first half if needed
            fi
        fi
    }
    function usage() {
        # Print script usage test
        # Parameters:
        #   $1 - specific message (e.g. 'file not found')
        #   $2 - optional usage text
        [[ -n "$1" ]] && warn "$1"
        if [[ -z "$2" ]]; then
            me "$_EXIT_USAGE_TEXT"
        else
            shift
            me "$@"
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
        ce "Script source:$MAIN $BASH_SOURCE$RESET"
        # _SAMPLE_USAGE_TEXT='Sample Usage Text'
        db_echo "Testing db_echo. (red text if \$DEBUG='1') - currently '$DEBUG'"

        # usage test
        usage
        # usage 'usage $1 only'
        # usage 'usage $1' 'usage $2'
        # usage 'alternate $2 (_SAMPLE_USAGE_TEXT)' $_SAMPLE_USAGE_TEXT

        # exit test
        # exit_usage "Testing exit_usage. (normal text)"
    }
}
function _main_standard_script_modules() {
    _define_standard_functions
    [[ $DEBUG == '1' ]] && _test_standard_script_modules
}

_main_standard_script_modules

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
