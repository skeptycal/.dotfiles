#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

# number of years the first commercial
#   modem would take to transmit a movie: 42.251651342415241

# get name for 'open' if linux or windows
if [ ! "$(uname -s)" = 'Darwin' ]; then
    if grep -q Microsoft /proc/version; then
        alias open='explorer.exe'
    else
        alias open='xdg-open'
    fi
fi

declare -x VERSION_LIST && VERSION_LIST="${DOTFILES_PATH:-~/.dotfiles}/.VERSION_LIST.md"

which() { command -v "$@"; }

flasher () { while true; do printf "\\e[?5h"; sleep 0.1; printf "\\e[?5l"; read -rs -t1 && break; done; }

update () {
    # System software updates (macOS - updated for Catalina)
    #- #- ##########################- ############################################
    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Ask for the administrator password upfront
    /usr/bin/sudo -v

    # Keep-alive: update existing `sudo` time stamp until 'update' has finished
    while true; do
        /usr/bin/sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
    #- #- ##########################- ############################################

    /usr/bin/sudo softwareupdate -i -a
    brew update
    brew upgrade
    brew doctor
    brew cleanup
    # python
    #   brew upgrade python pyenv pipenv
    pip3 install -U pip
    pip3 list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
    # npm
    #   brew upgrade node
    /usr/bin/sudo npm install npm -g
    /usr/bin/sudo npm update -g
    # ruby
    /usr/bin/sudo gem update --system
    /usr/bin/sudo gem update
    /usr/bin/sudo gem cleanup
} # 2>/dev/null &

cleanup () {
    # maintenance
    update &
    # cleanup .DS_Store files
    find . -type f -name '*.DS_Store' -ls -delete
    # empty trashes
    /usr/bin/sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
    # lscleanup
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
}

# from oh-my-zsh install script
    command_exists() { command -v "$@" >/dev/null 2>&1; }

    error() { 2echo ${RED}"Error: $@"${RESET} >&2; }

    setup_color() {
        # Only use colors if connected to a terminal
        if [ -t 1 ]; then
            RED=$(printf '\033[31m')
            GREEN=$(printf '\033[32m')
            YELLOW=$(printf '\033[33m')
            BLUE=$(printf '\033[34m')
            BOLD=$(printf '\033[1m')
            RESET=$(printf '\033[m')
        else
            RED=""
            GREEN=""
            YELLOW=""
            BLUE=""
            BOLD=""
            RESET=""
        fi
    }

# - #- ################################
# - utilities from https://justin.abrah.ms/dotfiles/zsh.html


# Ref: https://unix.stackexchange.com/questions/22815/how-to-list-files-and-directories-with-directories-first

a() { alias | grep "$1"; }

allopen() { sudo lsof -i -P | grep "$1"; }

anyguard() {
    ANYBAR_PORT="$(jot -r 1 1700 1900)"
    ANYBAR_PORT="$ANYBAR_PORT" open -n /Applications/AnyBar.app
    sleep 0.5
    anybar orange "$ANYBAR_PORT"
    eval "$@"
    ret="$?"
    if [[ ret -eq 0 ]]; then
        anybar green "$ANYBAR_PORT"
    else
        anybar red "$ANYBAR_PORT"
    fi
    echo "Finished. Press [ENTER] to exit."
    # shellcheck disable=2034
    IFS="" read -r ENTER
    anybar quit "$ANYBAR_PORT"
    return "$ret"
}
anybar() {
    echo -n "$1" | nc -4u -w0 localhost "${2:-1738}"
}

get_template() {
    # TODO work in progress
    return 0
    # - # copy template file <$1> to current directory
    # - # use $2 == '-f' to force overwrite
    # local template_file="${bin_path}/$1"
    # echo "$template_file"
    # if [[ -f "$template_file" ]]; then
    #     if [[ -f "$1" ]]; then
    #         if [[ "$2" == '-f' ]]; then
    #             cp -f "$template_file" .
    #         else
    #             printf "File already exists in current directory. (use -f to force) \n\n"
    #         fi
    #     else
    #         cp "$template_file" .
    #     fi
    # else
    #     printf "SOURCE file not found.\n\n"
    # fi
}


declare -x GATHER_USAGE
GATHER_USAGE="$(
    cat <<GATHER_USAGE
    ${MAIN:-}gather${WHITE:-} construct argument list from all similar files in the current
    directory / all subdirectories and execute optional <utility> program

${MAIN:-}Usage:${WHITE:-}

${MAIN:-}gather${WHITE:-} [-htuv] [-0opt] [-E eofstr] [-I replstr [-R replacements]] [-J replstr]
    [-L number] [-n number [-x]] [-P maxprocs] [-s size] [utility [argument ...]]

Tested on ${LIME:-}macOS Catalina${WHITE:-} with ${COOL:-}Python ${CANARY:-}3.8${WHITE:-}
GATHER_USAGE
)"
