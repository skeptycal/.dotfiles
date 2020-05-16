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

which() { command -v "$1"; } # use command -v instead of which ...
exists() { command -v "$1" >/dev/null 2>&1; } # which, no output
runif() { exists "$1" && "$@"; } # run it only if it exists
flasher () { while true; do printf "\\e[?5h"; sleep 0.1; printf "\\e[?5l"; read -rs -t1 && break; done; }
sudo_env() { # Turn on SUDO for remainder of current script
    # requires root authentication, of course
    #   use _SUDO_ENV=0 in main script to turn this off
    #   if it is not explicitly set, it will be turned on
    #   this makes it implicit with a function call ...
    _SUDO_ENV=${_SUDO_ENV:-1}
    if [[ $_SUDO_ENV == 1 ]]; then
        # warn "Using SUDO for this script ..."
        # Ask for the root password upfront
        sudo -v

        # Keep-alive: update existing `sudo` time stamp until script has finished
        while true; do
            sudo -n true
            sleep 60
            kill -0 "$$" || exit
        done 2>/dev/null &
    fi
    }

update () { # System software updates (macOS - updated for Catalina)

    #? ############################### Close 'Systemm Preferences'
    # Close any open System Preferences panes, to prevent them from overriding
    # settings weâ€™re about to change
    osascript -e 'tell application "System Preferences" to quit'

    #? ############################### Use sudo for remainder of the script
    sudo_env

    #? ############################### macOS updates
    /usr/bin/sudo softwareupdate -i -a

    #? ############################### Homebrew updates
    brew update
    brew upgrade
    brew doctor
    brew cleanup

    #? ############################### python updates
    #   brew upgrade python pyenv pipenv
    pip3 install -U pip
    pip3 list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U

    #? ############################### npm updates
    /usr/bin/sudo npm install npm -g
    /usr/bin/sudo npm update -g
    runif brew_fix

    #? ############################### ruby updates
    /usr/bin/sudo gem update --system
    /usr/bin/sudo gem update
    /usr/bin/sudo gem cleanup
    } # 2>/dev/null &

background_update() {
    update >/dev/null 2>&1 &
    }

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

# from oh-my-zsh install script (somewhat modified)
    declare -g RED=$WARN
    command_exists() { command -v "$@" >/dev/null 2>&1; }
    2echo() { ce "$@" >&2; }
    error() { warn ${RED}"Error: $@"${RESET} >&2; }
    setup_color() {
        # Only use colors if connected to a terminal
        if [ -t 1 ]; then
            declare -g RED=$(printf '\033[31m')
            declare -g GREEN=$(printf '\033[32m')
            declare -g YELLOW=$(printf '\033[33m')
            declare -g BLUE=$(printf '\033[34m')
            declare -g BOLD=$(printf '\033[1m')
            declare -g RESET=$(printf '\033[m')
        else
            declare -g RED=""
            declare -g GREEN=""
            declare -g YELLOW=""
            declare -g BLUE=""
            declare -g BOLD=""
            declare -g RESET=""
        fi
        }
    setup_color

# - #- ################################
# - utilities from https://justin.abrah.ms/dotfiles/zsh.html

# Ref: https://unix.stackexchange.com/questions/22815/how-to-list-files-and-directories-with-directories-first

a() { alias | grep "$1"; }

allopen() { sudo lsof -i -P | grep "$1"; }

anybar_message() {
    echo -n "$1" | nc -4u -w0 localhost "${2:-1738}"
}
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
