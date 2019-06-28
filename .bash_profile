#!/bin/false
#cannot be run directly
#* #############################################################################
#* Universal BASH debug flag
export DEBUG='0'

function load_themes () {
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
    }

function run_debug() {
    we "BASH Debug Mode Enabled (DEBUG=1)"
    ce "Script source:$MAIN $BASH_SOURCE$RESET"
    ge "Use <versions> to see common program versions."
    }

function main() {
    clear
    load_themes
    load_resources
    [ ! $DEBUG = '1' ] || run_debug
    }

main
