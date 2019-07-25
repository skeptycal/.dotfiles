#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#* #############################################################################
#* ### Universal BASH debug flag
#* #############################################################################
export DEBUG='0' # set to 1 for verbose messages and debugging logs
# log errors to text file; only functional if $DEBUG='1'
export DEBUG_LOG='1'
# log file for debug logs
export debug_log_file="${HOME}/.bash_profile_error.log"
# max filesize for debug_log_file
export debug_log_max_size=32768

function source_file() {
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

function load_themes() {
    # Brew install bash-git-prompt
    if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
        __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
        source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
    fi
    # ANSI color
    export CLICOLOR=1
    export colorflag='--color=always'

    # iterm2 bash shell integration
    source_file "${HOME}/.iterm2_shell_integration.bash"

    #   https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
    /usr/local/opt/coreutils/libexec/gnubin/dircolors -b &>/dev/null
    # GIT colors
    WS="$(git config --get-color color.diff.whitespace "blue reverse")"
    RESET="$(git config --get-color "" "reset")"
    export WS
    export RESET

    # minimum colors if main file isn't available
    if [ ! "$TEXT_COLORS_LOADED" = '1' ]; then
        MAIN=$(echo -en '\001\033[38;5;229m') && export MAIN
        BLUE=$(echo -en '\001\033[38;5;38m') && export BLUE
        WHITE=$(echo -en '\001\033[37m') && export WHITE
        WARN=$(echo -en '\001\033[38;5;203m') && export WARN
        GO=$(echo -en '\001\033[38;5;28m') && export GO
        RESET=$(echo -en '\001\033[0m') && export RESET
        echo -e "${WARN}basic_text_colors is not available."
        echo -e "Check path: $colors_file${RESET}"
        echo -e "Several basic colors have been implemented:"
        echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO   ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN   ${PURPLE}PURPLE   ${RESET}RESET"
    fi
}
function load_resources() {
    for file in ~/.dotfiles/.{path,exports,aliases,functions,extra,git_alias}; do
        source "$file" # &>/dev/null # used to test for errors
    done
    unset file
}

function run_debug() {
    db_echo "${WARN}BASH Debug Mode Enabled (DEBUG=1)${RESET}"
    db_echo "Script source:${MAIN} ${BASH_SOURCE}${RESET}"
    db_echo "Logging to $"
    db_echo "${GO}Use <versions> to see common program versions.${RESET}"
}

function main() {
    source_file "standard_script_modules.sh"

    # Homebrew GitHub public repo access + gists
    source_file "$HOME/.dotfiles/.homebrew_github_private.sh"
    clear
    load_themes
    load_resources
    [[ $DEBUG == '1' ]] && run_debug
}

main

#* #############################################################################
#* ### End of standard .bash_profile
#* #############################################################################
