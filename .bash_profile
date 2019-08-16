#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#* #############################################################################
#* ### Universal BASH debug flag
#* #############################################################################
source "$(which ssm)"
# set -am
umask 022

declare -xi SET_DEBUG=0 # set to 1 for verbose testing
# log errors to text file; only functional if $SET_DEBUG='1'
declare -xi DEBUG_LOG=0
# log file for debug logs
declare -x debug_log_file="${HOME}/.bash_profile_error.log"
# max filesize for debug_log_file
declare -xi debug_log_max_size=32768

function load_themes() {
    # Brew install bash-git-prompt
    if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
        __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
        source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
    fi

    # ANSI color
    declare -xi CLICOLOR=1
    declare -x colorflag='--color=always'

    # iterm2 bash shell integration
    source "${HOME}/.iterm2_shell_integration.bash"

    # https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
    # /usr/local/opt/coreutils/libexec/gnubin/dircolors -b &>/dev/null
    # GIT colors
    declare -x WS="$(git config --get-color color.diff.whitespace "blue reverse")"
    declare -x RESET="$(git config --get-color "" "reset")"
}
function load_resources() {
    # _debug_function_header
    for file in ~/.dotfiles/.{path,exports,aliases,functions,extra,git_alias}; do
        source "$file" # &>/dev/null # used to test for errors
    done
    unset file
}

function _profile_run_debug() {
    db_echo "${WARN}BASH Debug Mode Enabled (SET_DEBUG=${SET_DEBUG})${RESET_FG}"
    db_echo "Script source:${MAIN} ${BASH_SOURCE}${RESET_FG}"
    db_echo "Logging to $debug_log_file"
    db_echo "${GO}Use <versions> to see common program versions.${RESET_FG}"
}

function main() {
    clear
    load_themes
    load_resources
    [[ $SET_DEBUG == 1 ]] && _profile_run_debug
}

main "$@"

#* #############################################################################
#* ### End of standard .bash_profile
#* #############################################################################
