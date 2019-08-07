#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#? ############################# skeptycal.com ################################
NAME="${BASH_SOURCE##*/}"
VERSION='0.1.2'
DESC='standard script modules for macOS (Bash 5.0 with GNU coreutils)'
USAGE="source ${NAME} [help|test|usage|version]"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="Copyright (c) 2019 Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"
#? ############################################################################
# DEBUG='1' # set to 1 for verbose testing

_initialize_constants() {
    # setup global functions and variables
    # functions beginning with _ are only called 'by the script'
    # others are reusable in any script as needed
    _set_error_msgs() {
        # setup C++ style error messages
        #
        # reference: Advanced Bash-Scripting Guide
        #   <http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF>

        # from /usr/include/sysexits.h
        # Copyright (c) 1987, 1993
        # The Regents of the University of California.  All rights reserved.
        export EX_OK=0          # successful termination
        export EX__BASE=64      # base value for error messages
        export EX_USAGE=64      # command line usage error
        export EX_DATAERR=65    # data format error
        export EX_NOINPUT=66    # cannot open input
        export EX_NOUSER=67     # addressee unknown
        export EX_NOHOST=68     # host name unknown
        export EX_UNAVAILABL=69 # service unavailable
        export EX_SOFTWARE=70   # internal software error
        export EX_OSERR=71      # system error (e.g., can't fork)
        export EX_OSFILE=72     # critical OS file missing
        export EX_CANTCREAT=73  # can't create (user) output file
        export EX_IOERR=74      # input/output error
        export EX_TEMPFAIL=75   # temp failure; user is invited to retry
        export EX_PROTOCOL=76   # remote error in protocol
        export EX_NOPERM=77     # permission denied
        export EX_CONFIG=78     # configuration error
        export EX__MAX=78       # maximum listed value
    }
    _set_colors() {
        # setup ANSI constants for common colors
        MAIN=$(echo -en '\001\033[38;5;229m') && export MAIN
        WARN=$(echo -en '\001\033[38;5;203m') && export WARN
        COOL=$(echo -en '\001\033[38;5;38m') && export COOL
        BLUE=$(echo -en '\001\033[38;5;38m') && export BLUE
        GO=$(echo -en '\001\033[38;5;28m') && export GO
        CHERRY=$(echo -en '\001\033[38;5;124m') && export CHERRY
        CANARY=$(echo -en '\001\033[38;5;226m') && export CANARY
        ATTN=$(echo -en '\001\033[38;5;178m') && export ATTN
        PURPLE=$(echo -en '\001\033[38;5;93m') && export PURPLE
        RAIN=$(echo -en '\001\033[38;5;93m') && export RAIN
        WHITE=$(echo -en '\001\033[37m') && export WHITE
        RESTORE=$(echo -en '\001\033[0m\002') && export RESTORE
        RESET=$(echo -en '\001\033[0m') && export RESET
    }
    _set_color_functions() {
        # setup functions for printing lines in common colors
        br() { printf "\n"; } # yes, this is a fake cli version of <br />
        ce() { printf "%s \n" "${@}${RESET}"; }
        me() { ce "${MAIN}${@}"; }
        warn() { ce "${WARN}${@}"; }
        blue() { ce "${COOL}${@}"; }
        green() { ce "${GO}${@}"; }
        cherry() { ce "${CHERRY}${@}"; }
        canary() { ce "${CANARY}${@}"; }
        attn() { ce "${ATTN}${@}"; }
        purple() { ce "${PURPLE}${@}"; }
        rain() { ce "${RAIN}${@}"; }
        white() { ce "${WHITE}${@}"; }
    }
    _set_error_msgs
    _set_colors
    _set_color_functions
    export script_name="${BASH_SOURCE##*/}"
    export script_path="${BASH_SOURCE%/*}"
    export src_path="${script_path}/src"
    export bak_path="${script_path}/bak"
    export bin_path="${HOME}/bin/utilities/pc_bak"
    export dotfiles_path="${HOME}/.dotfiles"
    export here="$PWD"
}
db_echo() {
    # report data and errors in scripting
    #    - DEBUG is set to '1' to report errors
    #    - use log_toggle() to include file logging
    [[ $DEBUG == '1' ]] && warn "$(date "+%D %T") $@"
}
source_file() {
    db_echo "Script source: ($BASH_SOURCE)"
    if [[ -s "$1" ]]; then
        source "$1"
    elif [[ -L "$1" ]]; then
        source "$1"
    elif [[ -s "${HOME}/bin/$1" ]]; then
        source "${HOME}/bin/$1"
    elif [[ -s "$(which $1)" ]]; then
        source "$(which $1)"
    elif [[ -s "${PWD}/$1" ]]; then
        source "${PWD}/$1"
        db_echo "The source file ($1) loaded in script ($BASH_SOURCE) should include the path $PWD"
        db_echo "Script source: ($BASH_SOURCE)"
    elif [[ -s "$(which ${1}.sh)" ]]; then
        source "$(which ${1}.sh)"
        db_echo "The source file ($1) loaded in script ($BASH_SOURCE) should include the extension .sh"
        db_echo "Script source: ($BASH_SOURCE)"
    elif [[ -s "$(which ${1}.py)" ]]; then
        source "$(which ${1}.py)"
        db_echo "The source file ($1) loaded in script ($BASH_SOURCE) was not found, but was replaced with the python script (${1}.py)."
        db_echo "Script source: ($BASH_SOURCE)"
    else
        db_echo "The source file ($1) listed in script ($BASH_SOURCE) could not be found. A search was made for items in the path, ${1}.sh, and ${1}.py without results."
        db_echo "Script source: ($BASH_SOURCE)"
    fi
}
die() {
    # exit program with $exit_code ($1) and optional $message ($2)
    # https://stackoverflow.com/questions/7868818/in-bash-is-there-an-equivalent-of-die-error-msg/7869065
    exit_code=${1:-1}
    message=${2:-"Script died...$USAGE"}

    warn "${message}" >&2
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
hex_dump() { [[ -r "$1" ]] && od -A x -t x1z -v "$1"; }
log_toggle() {
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
            LOG_FILE_NAME="${script_source}LOGFILE.log"
        fi
    else
        LOG_FILE_NAME="${1}"
    fi
    touch "$LOG_FILE_NAME"
    # if log is on, turn it off
    if [[ "$LOG" == '1' ]]; then
        LOG='0'
        exec 1>&4 2>&5
        attn "logging off ..."
    else # if it is off ... turn it on
        LOG='1'
        exec 4>&1 5>&2
        exec 4>&- 5>&-

        # log to the filename stored in $LOG_FILE_NAME
        db_echo "\${LOG_FILE_NAME}: ${LOG_FILE_NAME}"
        exec > >(tee -a -i "${LOG_FILE_NAME}") 2>&1
        attn "logging on ..."
    fi
}
real_name() {
    # test_var "$1"
    # log_flag
    filename="${!1}"
    echo $filename
    filename="${1##*/}"
}
parse_filename() {
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
get_safe_new_filename() {
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
url_encode() {
    [[ -z "$1" ]] && return 64
    encoded=$(php -r "echo rawurlencode('$1');") && return 0 || return "$EX_DATAERR"
}
url_decode() {
    [[ -z "$1" ]] && return 1
    decoded=$(php -r "echo rawurldecode('$1');") && return 0 || return "$EX_DATAERR"
}
test_echo() {
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
test_var() {
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
exit_usage() {
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
print_usage() {
    set_man_page
    echo "$MAN_PAGE"
    exit 1
}
log_flag() {
    rain "#? ############################################################################"
}
_run_tests() {
    _run_debug_config() {
        ce "Script source:$MAIN $BASH_SOURCE$RESET"
        green "\$dotfiles_path is set to $dotfiles_path."
        green "\$here is set to as $here."
    }
    _bt_color_sample_test() {
        echo -e "Script source:$MAIN $BASH_SOURCE$RESET"
        echo -e "${MAIN}C ${WARN}O ${COOL}L ${GO}O ${CHERRY}R   ${CANARY}T ${ATTN}E ${PURPLE}S ${RESET}T"
        echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${RAIN}RAIN   ${RESET}RESET"
    }
    _test_standard_script_modules() {
        _EXIT_USAGE_TEXT="${MAIN}${script_name}${WHITE} - macOS script"
        # log file for test sesssion
        LOG_FILE_NAME="${script_source}ssm_debug_test.log"
        # functions that include an 'exit' will skip it so tests can continue
        DONT_DIE='1'
        # log everything to LOG_FILE_NAME
        log_toggle

        ce "${COOL}BASH_SOURCE:$MAIN $BASH_SOURCE$RESET"
        log_flag

        test_var "$script_name"
        test_var "$script_source"
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
    _run_debug_config
    _bt_color_sample_test
    _test_standard_script_modules
    return 0
}
parse_options() {
    # parse basic options [help|test|usage|version] & DEBUG
    # TODO the 'exits' and lack of shifts make this function
    # TODO inadequate for more detailed options handling
    case "$1" in
    -h | --help | help)
        set_man_page
        echo "$MAN_PAGE"
        return
        # exit 0
        ;;
    -t | --test | test)
        [[ ! "$DEBUG" == '1' ]] && _run_tests "$@"
        return
        # exit 0
        ;;
    -u | --usage | usage)
        me "$USAGE"
        return
        # exit 0
        ;;
    -v | --version | version)
        ce "${MAIN}${NAME}${WHITE} (version ${VERSION})${RESET}"
        return
        # exit 0
        ;;
        # *) ;;
    esac
}
_main_standard_script_modules() {
    _initialize_constants
    parse_options "$@"
    [[ "$DEBUG" == '1' ]] && _run_tests
    return 0
}

#? ############################################################################
#? ### Stuff to keep out of the way ...
usage_long_desc="$(
    cat <<usage_long_desc
    ${MAIN}$NAME${WHITE} sets and exports constants, functions, and ansi color utilities that give
    access to novel and useful features simply by loading the module through a one
    line command: 'source ssm'

usage_long_desc
)"
usage_parameters="$(
    cat <<usage_parameters
    help      - display complete usage information (this!)
    test      - perform script tests
    usage     - display short usage instructions
    version   - display version information
usage_parameters
)"

set_man_page() {
    # Create man page $MAN_PAGE from variables and template
    MAN_PAGE="$(
        cat <<MAN_PAGE

${MAIN}NAME${WHITE}
    $NAME (version $VERSION) - $DESC

${MAIN}SYNOPSIS${WHITE}
    $USAGE

${MAIN}DESCRIPTION${WHITE}
$usage_long_desc

${MAIN}OPTIONS${WHITE}
$usage_parameters

${MAIN}EXIT STATUS${WHITE}
    0     - success; no errors detected
    1     - general errors (division by zero, etc.)
    2     - missing keyword or command (possible permission problem)
    64-78 - assorted user errors (e.g. EX_DATAERR=65, EX_NOINPUT=66,
            EX_UNAVAILABL=69, EX_OSERR=71, EX_OSFILE=72, EX_IOERR=74)

${MAIN}CONTRIBUTING${WHITE}
    GitHub: $GITHUB

${MAIN}LICENSE${WHITE}
    $LICENSE
    $COPYRIGHT
    $AUTHOR

MAN_PAGE
    )"
}

_main_standard_script_modules "$@"

#? ############################################################################
# References
# https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash
# encoding urls: https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command

# identify this actual script name and current directory path
# _self=${0##*/}
# parameter expansion to remove trailing /filename
# _path="${0%/*}"

#? ############################################################################
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
#? #### standard_script_modules.sh #############################################
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
