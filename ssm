#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#? ############################# skeptycal.com ################################
NAME="${BASH_SOURCE##*/:'standard_script_modules'}"
VERSION='0.1.2'
DESC='standard script modules for macOS (Bash 5.0 with GNU coreutils)'
USAGE="source ${NAME:-} [help|test|usage|version]"
AUTHOR="Michael Treanor  <skeptycal@gmail.com>"
COPYRIGHT="Copyright (c) 2019 Michael Treanor"
LICENSE="MIT <https://opensource.org/licenses/MIT>"
GITHUB="https://www.github.com/skeptycal"
#? ############################################################################

# [[ ! $SSM_LOADED == 1 ]] && return

export SET_DEBUG=0        # set to 1 for verbose testing
export SSM_LOADED=1       # prevent repeat loading

exec 6>&1 # non-volatile stdout leaves return values of stdout undisturbed
# return 0

# TODO
#   - automate creation of TOC
#   - use       declare -F
#* ############################################################################
# setup global functions and variables
#   functions beginning with _ are only called 'by the script'
#   others are reusable in any script as needed
#* ######################## path variables
export script_name="${BASH_SOURCE##*/}"
export script_path="${BASH_SOURCE%/*}"
export src_path="${script_path}/src"
export bak_path="${script_path}/bak"
export bin_path="${HOME}/bin/utilities/pc_bak"
export dotfiles_path="${HOME}/.dotfiles"
export here="$PWD"

#* ######################## constants

export _pretty_usage="Usage :\n\t${MAIN:-}pretty${WHITE:-} [file(s) ...] \t\t- use list of files (default is all files in current directory)\n\t${MAIN:-}pretty${WHITE:-} [-m [commit message]] \t- use git staged files and commit with message
    \n\t${MAIN:-}pretty${WHITE:-} [-h|--help|help] \t- usage help (this!)"

function async_run() {
    {
        eval "$@" &>/dev/null
    } &
}
function _debug_function_header() {
    # (($DEBUG_LOG == 1)) || return 64
    printf "${MAIN:-}Calling: ${CANARY:-}${FUNCNAME[0]:-} ${MAIN:-}$*${RESET_FG:-}" >&2
    printf "%b" "\n"

}
function l() {
    # added 'list' default parameter instead of 'help'
    eval "launchctl ${@:-list}"
}

in_list () { 
    # usage: contains needle haystack
    # list items must be surrounded by single spaces
    # [[ "$2" =~ " ${1} " ]] && echo 'yes' || echo 'no' # false positives
    # echo $list|grep $x
    echo "$2" | grep " $1 " >/dev/null && echo 'yes' || echo 'no'
}

#* ######################## C++ style error messages
#   References:
#       Advanced Bash-Scripting Guide
#       <http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF>
#       from /usr/include/sysexits.h
#       Copyright (c) 1987, 1993
#       The Regents of the University of California.  All rights reserved.
export EX_OK=0          # successful termination
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

#* ######################## BASH trap signals
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html
# https://www.learnshell.org/en/Bash_trap_command
export TRAP_SIGHUP=1
export TRAP_SIGINT=2
export TRAP_SIGQUIT=3
export TRAP_SIGILL=4
export TRAP_SIGTRAP=5
export TRAP_SIGABRT=6
export TRAP_SIGEMT=7
export TRAP_SIGFPE=8
export TRAP_SIGKILL=9
export TRAP_SIGBUS=10
export TRAP_SIGSEGV=11
export TRAP_SIGSYS=12
export TRAP_SIGPIPE=13
export TRAP_SIGALRM=14
export TRAP_SIGTERM=15
export TRAP_SIGURG=16
export TRAP_SIGSTOP=17
export TRAP_SIGTSTP=18
export TRAP_SIGCONT=19
export TRAP_SIGCHLD=20
export TRAP_SIGTTIN=21
export TRAP_SIGTTOU=22
export TRAP_SIGIO=23
export TRAP_SIGXCPU=24
export TRAP_SIGXFSZ=25
export TRAP_SIGVTALRM=26
export TRAP_SIGPROF=27
export TRAP_SIGWINCH=28
export TRAP_SIGINFO=29
export TRAP_SIGUSR1=30
export TRAP_SIGUSR2=31

#* ######################## ANSI constants for common colors
export MAIN=$(echo -en '\001\033[38;5;229m')
export WARN=$(echo -en '\001\033[38;5;203m')
export COOL=$(echo -en '\001\033[38;5;38m')
export BLUE=$(echo -en '\001\033[38;5;38m')
export GO=$(echo -en '\001\033[38;5;28m')
export CHERRY=$(echo -en '\001\033[38;5;124m')
export CANARY=$(echo -en '\001\033[38;5;226m')
export ATTN=$(echo -en '\001\033[38;5;178m')
export PURPLE=$(echo -en '\001\033[38;5;93m')
export RAIN=$(echo -en '\001\033[38;5;93m')
export WHITE=$(echo -en '\001\033[37m')
export RESTORE=$(echo -en '\001\033[0m\002')
export RESET_FG=$(echo -en '\001\033[0m')

#* ######################## functions for printing lines in common colors
function br() { printf "\n"; } # yes, this is a fake cli version of <br />
function ce() { printf "%b\n" "${@}${RESET_FG:-}"; }
function me() { printf "%b\n" "${MAIN:-}${@}${RESET_FG:-}"; }
function warn() { printf "%b\n" "${WARN:-:-}${@}${RESET_FG:-}"; }
function blue() { printf "%b\n" "${COOL:-}${@}${RESET_FG:-}"; }
function green() { printf "%b\n" "${GO:-}${@}${RESET_FG:-}"; }
function cherry() { printf "%b\n" "${CHERRY:-}${@}${RESET_FG:-}"; }
function canary() { printf "%b\n" "${CANARY:-}${@}${RESET_FG:-}"; }
function attn() { printf "%b\n" "${ATTN:-}${@}${RESET_FG:-}"; }
function purple() { printf "%b\n" "${PURPLE:-}${@}${RESET_FG:-}"; }
function rain() { printf "%b\n" "${RAIN:-}${@}${RESET_FG:-}"; }
function white() { printf "%b\n" "${WHITE:-}${@}${RESET_FG:-}"; }
# go() { printf "%b\n" "${FUNCNAME[0]^^:-}${@}${RESET_FG:-}"; }

#* ######################## program usage setup
usage_long_desc="$(
    cat <<usage_long_desc
    ${MAIN:-}$NAME${WHITE:-} sets and exports constants, functions, and ansi color utilities that give
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
    # NAME, DESC, USAGE, usage_long_desc, usage_parameters,
    # GITHUB, LICENSE, COPYRIGHT, AUTHOR, VERSION, CONTRIBUTING
    MAN_PAGE="$(
        cat <<MAN_PAGE

${MAIN:-}NAME${WHITE:-}
    $NAME (version $VERSION) - $DESC

${MAIN:-}SYNOPSIS${WHITE:-}
    $USAGE

${MAIN:-}DESCRIPTION${WHITE:-}
$usage_long_desc

${MAIN:-}OPTIONS${WHITE:-}
$usage_parameters

${MAIN:-}EXIT STATUS${WHITE:-}
    0     - success; no errors detected
    1     - general errors (division by zero, etc.)
    2     - missing keyword or command (possible permission problem)
    64-78 - assorted user errors (e.g. EX_DATAERR=65, EX_NOINPUT=66,
            EX_UNAVAILABL=69, EX_OSERR=71, EX_OSFILE=72, EX_IOERR=74)

${MAIN:-}CONTRIBUTING${WHITE:-}
    GitHub: $GITHUB

${MAIN:-}LICENSE${WHITE:-}
    $LICENSE
    $COPYRIGHT
    $AUTHOR

MAN_PAGE
    )"
}
#* ######################## program configuration
get_linux_platform_name() {
    eval $_debug_function_header_text

    if [ -n "$runtime_id" ]; then
        echo "${runtime_id%-*}"
        return 0
    else
        if [ -e /etc/os-release ]; then
            . /etc/os-release
            echo "$ID.$VERSION_ID"
            return 0
        elif [ -e /etc/redhat-release ]; then
            local redhatRelease=$(</etc/redhat-release)
            if [[ $redhatRelease == "CentOS release 6."* || $redhatRelease == "Red Hat Enterprise Linux Server release 6."* ]]; then
                echo "rhel.6"
                return 0
            fi
        fi
    fi

    say_verbose "Linux specific platform name and version could not be detected: UName = $uname"
    return 1
}
get_current_os_name() {
    eval $_debug_function_header_text

    local uname=$(uname)
    if [ "$uname" = "Darwin" ]; then
        echo "osx"
        return 0
    elif [ "$uname" = "FreeBSD" ]; then
        echo "freebsd"
        return 0
    elif [ "$uname" = "Linux" ]; then
        local linux_platform_name
        linux_platform_name="$(get_linux_platform_name)" || { echo "linux" && return 0; }

        if [[ $linux_platform_name == "rhel.6" ]]; then
            echo $linux_platform_name
            return 0
        elif [[ $linux_platform_name == alpine* ]]; then
            echo "linux-musl"
            return 0
        else
            echo "linux"
            return 0
        fi
    fi

    db_echo "OS name could not be detected: UName = $uname"
    return 1
}
#* ######################## program control flow functions
db_echo() {
    # report data and errors in scripting
    #    - SET_DEBUG is set to '1' to report errors
    #    - use log_toggle() to include file logging
    # using stream 2 (stderr)

    if [[ $SET_DEBUG == '1' ]]; then
        warn "debug info ($(date "+%D %T")) - $@" >&2
    fi
    # printf "%b\n" "${cyan:-}dotnet-install:${normal:-} $1" >&3
}
die() {
    # exit program with $exit_code ($1) and optional $message ($2)
    # https://stackoverflow.com/questions/7868818/in-bash-is-there-an-equivalent-of-die-error-msg/7869065

    warn "${2:-$script_name} died...${USAGE:-}" >&2
    db_echo "${MAIN:-}line ${BLUE:-}${BASH_LINENO[0]}${MAIN:-} of ${ATTN:-}${FUNCNAME[1]}${MAIN:-} in ${BASH_SOURCE[1]}${MAIN:-}." >&2
    [[ ! "$DONT_DIE" == '1' ]] && exit "${1:1}"
}
yes_no() {
    # Accept a Yes/no (default Yes) user response to prompt ($1 or default)
    echo -n "${1:-'[Yes/no]: '}"
    read yno
    case $yno in
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
    *) # default 'No' ... see function yes_no for default 'Yes'
        return 0
        ;;
    esac
}
exit_usage() {
    # Print script usage and exit
    # TODO replace with die()
    # Parameters:
    #   $1 - specific message (e.g. 'file not found')
    #   $2 - optional usage text
    die "$@"
}
print_usage() {
    set_man_page
    echo "$MAN_PAGE"
}
function db_script_source() {
    [[ -n "$1" ]] && attn "$@"
    attn "Script source:${MAIN} ${BASH_SOURCE}${RESET_FG}\n"
}
#* ######################## program logging functions
# log_toggle() {
    #   usage: log_toggle [filename]
    #   toggle on and off logging to file
    #       parameter
    #           filename    - name of new logfile (default LOGFILE)
    #       variable $LOG stores state
    #       variable $LOGFILE stores filename
    #   reference: https://unix.stackexchange.com/questions/80988/how-to-stop-redirection-in-bash

    # set default log filename or $1
    # # TODO this function is generating sporadic errors ...
    # return 0
    # if [[ -z "$1" ]]; then
    #     if [[ -z "$LOG_FILE_NAME" ]]; then
    #         LOG_FILE_NAME="${script_source:-'./'}LOGFILE.log"
    #     fi
    # else
    #     LOG_FILE_NAME="${1}"
    # fi
    # touch "$LOG_FILE_NAME"
    # # if log is on, turn it off
    # if [[ "$LOG" == '1' ]]; then
    #     LOG='0'
    #     exec 1>&4- 2>&5-
    #     attn "logging off ..."
    # else # if it is off ... turn it on
    #     LOG='1'
    #     exec 4>&1 5>&2
    #     # log to the filename stored in $LOG_FILE_NAME
    #     db_echo "\${LOG_FILE_NAME}: ${LOG_FILE_NAME}"
    #     exec > >(tee -a -i "${LOG_FILE_NAME}") 2>&1
    #     attn "logging on ..."
    # fi
# }
test_echo() {
    # log the current value of a given variable ($1)
    # usage: test_echo <test name> <test code>
    # report test results if:
    #    - SET_DEBUG is set to '1' or cli [test] option set
    #    - use log_toggle() to include file logging
    if [[ $SET_DEBUG == '1' ]] && [[ -n "$1" ]]; then
        printf "%bFunction Test -> %bPID %s %b" "$MAIN" "$CANARY" "$$" "$GO"
        printf '%(%Y-%m-%d)T' -1
        printf "%b test name: %s\n%b" "$ATTN" "$1" "${RESET_FG:-}"
        shift
        eval "$@"
        printf "%bResult = %s%b\n" "$COOL" "$?" "${RESET_FG:-}"
    fi
}
test_var() {
    # usage: test_var <test variable>
    # report test results if:
    #    - SET_DEBUG is set to '1' or cli [test] option set
    #    - use log_toggle() to include file logging
    # reference:
    #   indirect variables: https://wiki.bash-hackers.org/syntax/pe#indirection
    #   bash printf: https://www.linuxjournal.com/content/bashs-built-printf-function
    if [[ $SET_DEBUG == '1' ]] && [[ -n "$1" ]]; then
        local testvar="${1}"
        echo "\$testvar: $testvar"
        echo "testvar: " ${!testvar}
        echo ''
        printf "%bVariable Test -> %bPID %s %b" "$MAIN" "$CANARY" "$$" "$GO"
        printf '%(%Y-%m-%d)T' -1
        printf "%b %15s -%b %s %b\n" "$ATTN" "\$$testvar" "$WARN" "$testvar" "$RESET_FG"
    fi
}
log_flag() {
    rain "#? ############################################################################"
}
#* ######################## path manipulation functions
real_name() {
    # TODO test this further ... working on a bash only method
    # test_var "$1"
    # log_flag
    filename="${!1}"
    filename="${1##*/}"
    echo $filename
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

    [[ -z "$filename" ]] && filename="$1"
    if [[ -r "$1" ]]; then
        exit_usage "\$filename not readable ..." "${MAIN:-}${FUNCNAME[0]} ${WHITE:-}[filename]"

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
    fi
    test_var "$filename"
    log_flag

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
#* ######################## file manipulation functions
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
hex_dump() { [[ -r "$1" ]] && od -A x -t x1z -v "$1"; }
url_encode() {
    [[ -z "$1" ]] && return 64
    encoded=$(php -r "echo rawurlencode('$1');") && return 0 || return "$EX_DATAERR"
}
url_decode() {
    [[ -z "$1" ]] && return 1
    decoded=$(php -r "echo rawurldecode('$1');") && return 0 || return "$EX_DATAERR"
}
#* ######################## paramter handling

parse_options() {
    # parse basic options [help|test|usage|version] & SET_DEBUG
    # TODO the 'exits' and lack of shifts make this function inadequate
    # TODO use standard functions in a wrapper instead
    case "$1" in
    -h | --help | help)
        set_man_page
        echo "$MAN_PAGE"
        return
        # exit 0
        ;;
    -t | --test | test)
        [[ ! "$SET_DEBUG" == '1' ]] && _run_tests
        return
        # exit 0
        ;;
    -u | --usage | usage)
        me "$USAGE"
        return
        # exit 0
        ;;
    -v | --version | version)
        ce "${MAIN}${NAME}${WHITE} (version ${VERSION})${RESET_FG}"
        return
        # exit 0
        ;;
        # *) ;;
    esac
}

#* ######################## error handling
_set_traps() {
    cur_opts="$-"
    debug_opts="axET"
    set "-${cur_opts}${debug_opts}"
}

_trap_error() {
    # me "ERR: $ERR"
    # set "-${cur_opts}"
    return 0
}
_trap_debug() {
    return 0
    # ce "Script source:$MAIN $BASH_SOURCE$RESET_FG $@ \n"
    # attn "echo VARIABLE ($VARIABLE) is being used here."
}
_trap_exit() {
    # https://stackoverflow.com/a/50270940/9878098
    exitcode=$?
    printf 'error executing script...\n' 1>&2
    printf 'exit code returned: %s\n' "$exitcode"
    printf 'the command executing at the time of the error was: %s\n' "$BASH_COMMAND"
    printf 'command present on line: %d' "${BASH_LINENO[0]}"
    # Some more clean up code can be added here before exiting
    set "-${cur_opts}"
    exec 4>&- 5>&- 6>&-
    if [[ "$LOG" == '1' ]]; then
        LOG='0'
        exec 1>&4 2>&5
        exec 4>&- 5>&-
        attn "logging off ..."
    fi

    exit $exitcode
}
#* ######################## script tests
_run_tests() {
    _run_debug_config() {
        green "\$dotfiles_path is set to $dotfiles_path."
        green "\$here is set to as $here."
    }
    _bt_color_sample_test() {
        echo -e "${MAIN}C ${WARN}O ${COOL}L ${GO}O ${CHERRY}R   ${CANARY}T ${ATTN}E ${PURPLE}S ${RESET_FG}T"
        echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${RAIN}RAIN   ${RESET_FG}RESET_FG"
    }
    _test_standard_script_modules() {
        _EXIT_USAGE_TEXT="${MAIN}${script_name}${WHITE} - macOS script"
        # log file for test sesssion
        LOG_FILE_NAME="${script_source}ssm_debug_test.log"
        # functions that include an 'exit' will skip it so tests can continue
        DONT_DIE='1'
        # log everything to LOG_FILE_NAME
        # log_toggle

        ce "${COOL}BASH_SOURCE:$MAIN $BASH_SOURCE$RESET_FG"
        log_flag

        test_var "$script_name"
        test_var "$script_source"
        test_var "$SET_DEBUG"
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

        test_echo "in_list() test" "in_list '1' '123'"
        test_echo "in_list() test" "in_list 'ok' 'this is ok'"
        test_echo "in_list() test" "in_list 'j' 'klm')"
        test_echo "in_list() test" "in_list 'doc' '( txt rtf rtfd html doc docx odt wordml webarchive )')"

        log_flag
        result="${fake_filename##*/}"
        test_var "$result"

        # cleanup test environment
        # log_toggle
        unset DONT_DIE
        unset LOG_FILE_NAME
        unset _EXIT_USAGE_TEXT
        unset LOG
    }
    ce "Script source:$MAIN $BASH_SOURCE$RESET_FG"
    _run_debug_config
    _bt_color_sample_test
    _test_standard_script_modules
    return 0
}
#* ######################## main loop
_main_standard_script_modules() {
    # _debug_function_header
    [[ $SET_DEBUG == 1 ]] && _set_traps
    parse_options "$@"
    [[ $SET_DEBUG == 1 ]] && _run_tests
    # declare -f
}

#* ######################## entry point
# echo ${filename##*/}
# ce "Script source:$MAIN ${BASH_SOURCE[0]##*/}${RESET_FG:-}\n"
# ce "Script parent:$MAIN ${BASH_SOURCE[1]##*/}${RESET_FG:-}\n"
# ce "Script grandparent:$MAIN ${BASH_SOURCE[2]##*/}${RESET_FG:-}\n"

trap _trap_error ERR
# trap _trap_exit EXIT
# trap _trap_debug DEBUG

_main_standard_script_modules "$@"

# generate a function list
# declare -F | sed "s/declare -fx //g" >ssm_functions.txt

#? ############################################################################
# References

# determine if a function exists
# https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash

# url encoding
# https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command

# parameter expansions for file and path names
# identify this actual script name and current directory path
# _self=${0##*/}
# parameter expansion to remove trailing /filename
# _path="${0%/*}"

# printf and echo
# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo

# arguments in bash
# https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script
