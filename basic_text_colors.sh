#!/usr/bin/env bash
###############################################################################
NAME="${BASH_SOURCE##*/}"
VERSION='0.9.5'
DESC='obligatory ansi text color module for macOS'
USAGE="source ${NAME} [test|version]"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="2019 (c) Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"

###### basic_text_colors.sh contents #########################################
# TODO automate creation of TOC
# FUNCTIONS         PARAMETERS and OPTIONS
# fn_exists         - test if a function exists already
# text colors       - MAIN, WARN, COOL, BLUE, GO, CHERRY, CANARY, ATTN,
#                   - PURPLE, WHITE, RESTORE, RESET
# br                - print blank line (CLI \n)
# ce                - $@ (color echo - generic color as $1, etc.)
# various           - $@ (color echo - specific color)
# usage             - print script usage details
###############################################################################
[[ -z "$DEBUG" ]] && DEBUG='0' # set to 1 for debug and verbose testing

load_error_msgs() {
    # C++ style error messages
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

    EXIT_STATUS_TEXT=$(
        cat <<-EOF
        ${WHITE}The ${MAIN}${NAME} utility uses (mostly) C++ style exit codes:
        \t0     - success; no errors detected
        \t1     - general errors (division by zero, etc.)
        \t2     - missing keyword or shell command (possible permission problem)
        \t64-78 - EX__BASE=64, EX_USAGE=64, EX_DATAERR=65, EX_NOINPUT=66, EX_NOUSER=67, EX_NOHOST=68, EX_UNAVAILABL=69, EX_SOFTWARE=70, EX_OSERR=71, EX_OSFILE=72, EX_CANTCREAT=73, EX_IOERR=74, EX_TEMPFAIL=75, EX_PROTOCOL=76, EX_NOPERM=77, EX_CONFIG=78, EX__MAX=78
EOF
    )
    sample_long_desc=$(
        cat <<sample_long_desc
        ${MAIN}NAME${WHITE} sets and exports color constants and functions
        to make their use easier. In addition, there are several debugging
        and general functions included for quality of life. These are the
        main colors

        ${MAIN}NAME${WHITE} also exports a function for each color. Most of
        the functions are the same as the color names, except for the \$MAIN
        function having a name of 'me' to avoid using the common 'main' name.

        Functions set the echo color for that printed line. If they are not overridden by another ANSI code, the entire line will be printed in
        in that color. The color is reset at the end of each line.

sample_long_desc
    )
    sample_parameters=$(
        cat <<sample_parameters
    ${MAIN}OPTIONS${WHITE}
        \ttest      - display ANSI color tests
        \tversion   - display version information
        \thelp      - display complete usage information (this!)
sample_parameters
    )
    sample_usage_text=$(
        cat <<-sample_usage_text

        ${MAIN}NAME${WHITE}
            \t$NAME (version $VERSION) - $DESC

        ${MAIN}SYNOPSIS${WHITE}
            \t$USAGE

        ${MAIN}DESCRIPTION${WHITE}
            \t$sample_long_desc

            \t$sample_parameters

        ${MAIN}EXIT STATUS${WHITE}
            \t$EXIT_STATUS_TEXT

        ${MAIN}CONTRIBUTING${WHITE}
            \TGitHub: $GITHUB

        ${MAIN}LICENSE${WHITE}
            \t$LICENSE
            \t$COPYRIGHT
            \t$AUTHOR

sample_usage_text
    )
}

function _main_text_colors() {
    load_error_msgs
    set_colors "$@"
    set_usage
    echo
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
