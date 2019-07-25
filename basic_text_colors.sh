#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#? ############################# skeptycal.com ################################
NAME="${BASH_SOURCE##*/}"
VERSION='1.0.0'
DESC='Obligatory ansi text color module for macOS'
USAGE="source ${NAME} [help|test|usage|version]"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="Copyright (c) 2019 Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"
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
DEBUG='0' # set to 1 for debug and verbose testing

bt_source_initialize() {
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
}
_run_tests() {
    # calls script tests
    _bt_color_sample_test() {
        # specific script test - print samples of available colors
        echo -e "Script source:$MAIN $BASH_SOURCE$RESET"
        echo -e "${MAIN}C ${WARN}O ${COOL}L ${GO}O ${CHERRY}R   ${CANARY}T ${ATTN}E ${PURPLE}S ${RESET}T"
        echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${RAIN}RAIN   ${RESET}RESET"
    }
    _bt_color_sample_test
    # TODO add other tests as needed
}
parse_options() {
    # parse basic options [test|usage|version|help] & DEBUG
    # TODO the 'exits' and lack of shifts make this function
    # TODO inadequate for more detailed options handling
    case "$1" in
    -h | --help | help)
        set_man_page
        echo "$MAN_PAGE"
        exit 0
        ;;
    -t | --test | test)
        _run_tests
        exit 0
        ;;
    -u | --usage | usage)
        me "$USAGE"
        exit 0
        ;;
    -v | --version | version)
        ce "${MAIN}${NAME}${WHITE} (version ${VERSION})${RESET}"
        exit 0
        ;;
    esac
    [[ "$DEBUG" == '1' ]] && _run_tests
}
_main_loop() {
    bt_source_initialize
    parse_options "$@"
}

#* ############################################################################
#* ### Stuff to keep out of the way ...
usage_long_desc="$(
    cat <<usage_long_desc
    ${MAIN}$NAME${WHITE} sets and exports constants and functions that apply ANSI colors to
    terminal output. In addition, there are several debugging and general
    functions included for quality of life. These are the main colors

    ${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${RAIN}RAIN   ${RESET}RESET
usage_long_desc
)"
usage_parameters="$(
    cat <<usage_parameters
    help      - display complete usage information (this!)
    test      - display ANSI color tests
    usage     - short usage instructions
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
_main_loop "$@"

#? ############################################################################
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
