#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

#? ######################## .functions - functions for macOS with zsh
    #* should not be run directly; called from .bash_profile / .bashrc / .zshrc

    #* copyright (c) 2019 Michael Treanor
    #* MIT License - https://www.github.com/skeptycal

#? ######################## Maintenance
    export VERSION_LIST="${DOTFILES_PATH:-~/.dotfiles}/.VERSION_LIST.md"

    update() { # System software updates (macOS - updated for Big Sur)

        #? ############################### Close 'Systemm Preferences'
        # Close any open System Preferences panes, to prevent them from overriding
        # settings weâ€™re about to change
        osascript -e 'tell application "System Preferences" to quit'

        #? ############################### Homebrew updates
        # Brew does not like 'sudo'
        brew update
        brew upgrade
        brew doctor
        brew cleanup

        #? ############################### Use sudo for remainder of the script
        sudo_env

        #? ############################### macOS updates
        /usr/bin/sudo softwareupdate -i -a

        #? ############################### python updates
        #   brew upgrade python pyenv pipenv
        cd ~
        pipupdate() {
            pip3 install -U pip wheel setuptools
            pip3 install -U piplist
        } >/dev/null 2>&1

        #? ############################### npm updates
        # /usr/bin/sudo
        npm install npm -g
        # /usr/bin/sudo
        npm update -g
        runif brew_fix

        #? ############################### ruby updates
        # /usr/bin/sudo
        gem update --system
        # /usr/bin/sudo
        gem update
        # /usr/bin/sudo
        gem cleanup
    } # 2>/dev/null &

    cleanup() {
        # init sudo environment
        sudo_env
        # maintenance
        update &
        # cleanup .DS_Store files
        find . -type f -name '*.DS_Store' -ls -delete
        # empty trashes
        /usr/bin/sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
        # lscleanup
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
        } &

    maintenance() { cleanup && update; }

    background_update() { update >/dev/null 2>&1 &; }
    background_cleanup() { cleanup >/dev/null 2>&1 &; }

    background_maintenance() { background_cleanup && background_maintenance >/dev/null 2>&1 &; }



#? ######################## Session Tasks
    _login_message() {
        cherry "========================================================"
        me "os: ${LIME:-}$(uname -i) | $(sw_vers -productName) | $(sw_vers -productVersion)"
        me "shell: ${ATTN:-}zsh: $(zsh --version)"
        me "python: ${BLUE:-}$(python -V)"
        # green "  this zsh session: $ZSH_VERSION"
        cherry "========================================================"
        br

        # Reminders to try out the latest features ...
        canary "Recently added utilities: "
        green "--------------------------
        versions            - to display program versions
        sysctl -a           - display a ton of system settings
        log_urls            - logs urls from chrome constantly
        sunday              - weekly maintenance scripts
        do_over             - repeat something over and over ... and over

        update_git_dirs     - update all git repos
        gitit               - add and commit all changes with default message
        binit               - link and chmod a file to ~/bin
        repip               - repair and update pip packages in current env
        "
        br
        # space [DEVICE]      - space remaining on drive (just the number from 'df')
        # getURL              - gets url of active Chrome tab
    }
#? ######################## Daily Tasks
    _daily() {
        background_cleanup
    }
#? ######################## Weekly Tasks
    _sunday() {
        weekday=$(date +%a)
        monthday=$(date +%d)
        year=$(date +%Y)
        today=$(date +"")
        sun_file=~/.dotfiles/.sun_check
        touch $sun_file
        if [[ $weekday = 'Sun' ]]; then
            if [ -f $sun_file ]; then
                read -r line < $sun_file
                line=$(tail -1 $sun_file)
                if [[ $line = "$today" ]]; then
                    rain 'Sunday tasks already done...'
                else
                    rain "It's Sunday! Performing weekly updates and refreshes..."

            # TODO -- add weekly update functions here ...
                    cd ~
                    blue "Updating pip ..."
                    pip install --upgrade pip setuptools wheel

                    attn "Running system cleanup and update chores ..."
                    cleanup &

                    attn "Running RepoClean chores ..."
                    rc &

                    blue "Running python chores"
                    python -m ${DOTFILES_INC}/sunday.py

                    blue "Updating program version list <versions> ..."
                    save_versions & # 2>/dev/null
                fi
            fi
        fi
    }
#? ######################## MAIN LOOP
    _main_() {
        _login_message
        _daily
        _sunday
    }
#? ######################## ENTRY POINT
    _main_ "$@"
