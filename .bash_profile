#!/bin/false
#cannot be run directly
#* #############################################################################
#* Universal BASH debug flag
export DEBUG='0'
# log errors to text file; only functional if $DEBUG='1'
export DEBUG_LOG='1'
# log file for debug logs
export debug_log_file="${HOME}/.bash_profile_error.log"
# max filesize for debug_log_file
export debug_log_max_size=32768

# added by travis gem
[ -f /Volumes/Data/skeptycal/.travis/travis.sh ] && source /Volumes/Data/skeptycal/.travis/travis.sh

# Homebrew GitHub public repo access + gists
source "$HOME/.dotfiles/.homebrew_github_private.sh"

function db_echo() {
    if [ $DEBUG = '1' ]; then
        if [ $DEBUG_LOG = '1' ]; then
            ce "$(date "+%D %T") $@" 2>&1 | tee -a $debug_log_file
            # TODO check filesize and chop off first half if needed
        else
            we "$(date "+%D %T") $@" 2>&1
        fi
    fi
}

function load_themes() {
    colors_file="/Volumes/Data/skeptycal/bin/utilities/scripts/basic_text_colors.sh"
    [[ -r "$colors_file" ]] && source "$colors_file"

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
    # NVM: Add the following to ~/.bash_profile or your desired shell configuration file:

    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    # This loads nvm
    [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
    # This loads nvm bash_completion
}

function run_debug() {
    db_echo "${WARN}BASH Debug Mode Enabled (DEBUG=1)${RESET}"
    db_echo "Script source:${MAIN} ${BASH_SOURCE}${RESET}"
    db_echo "${GO}Use <versions> to see common program versions.${RESET}"
}

function main() {
    clear
    load_themes
    load_resources
    [ ! $DEBUG = '1' ] || run_debug
}

main
