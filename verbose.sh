#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
#*#######################################################################
#* verbose.sh - provides varying levels of feedback for shell scripts
#* copyright (c) 2019 Michael Treanor
#* MIT License - https://www.github.com/skeptycal
#*################ PROGRAM FEATURES:
    # Set default ANSI colors (using ssm) for verbose output
    # Set default debug, verbose, and log values
    # Set file descriptors for [debug, info, err, out, log]
    # Create log file in system default temp location
    # Assign log file to LOG file descriptor
    # Generate functions for [debug, info, err, out, log]
    # Provides generic test function to display values and colors
    # Provides generic cleanup function to delete temp file and close FD's
#*################ Set text output colors
    declare -x LOG_COLOR='ce' # ce is 'color echo with no color'
    declare -x INFO_COLOR='green'
    declare -x ERR_COLOR='warn'
    declare -x DEBUG_COLOR='attn'
    declare -x OUT_COLOR='me'
#*################ setup constants
    declare -ix SET_DEBUG=0      # set to 1 for verbose testing
    declare -ix VERBOSE=0        # 0, 1, 2, 3  means out, +err, +info, +debug
    declare -ix SET_LOG=0        # 1 for file logging

#*################ setup file descriptors
    [[ $VERBOSE -gt 2 ]] && exec {DEBUG}>&1 || exec {DEBUG}>/dev/null
    [[ $VERBOSE -gt 1 ]] && exec {INFO}>&1 || exec {INFO}>/dev/null
    [[ $VERBOSE -gt 0 ]] && exec {ERR}>&1 || exec {ERR}>/dev/null
    exec {OUT}>&1
#*################ setup logging to temp file
    if [[ $SET_LOG == 1 ]]; then # if SET_LOG is 1, setup file logging
        LOG_FILENAME="$TEMP_FILE"
        touch "$LOG_FILENAME"
        exec {LOG}>$LOG_FILENAME
        echo '' >&${LOG} # all other log output is 'appended'
    else
        exec {LOG}>/dev/null
    fi
#*################ setup output functions
    info() { $INFO_COLOR "$*"; } >&${INFO}
    err() { $ERR_COLOR "$*"; } >&${ERR}
    debug() { $DEBUG_COLOR "$*"; } >&${DEBUG}
    out() { $OUT_COLOR "$*"; } >&${OUT}
    log() { $LOG_COLOR "$*"; } >>&${LOG}
    # redirect all 'uncontrolled' stdout and stderr to /dev/null
    # basically STFU for everything except &6 ...
    # exec 1>/dev/null
    # exec 2>&1d
#*################ debug summary output
    verbose_debug_output() {
        err "Script Name: $0"
        debug "  SET_DEBUG: $SET_DEBUG"
        debug "  SET_LOG: $SET_LOG"
        info "  VERBOSE: $VERBOSE"
        err "  File Descriptors: out:$OUT | err:$ERR | info:$INFO | debug:$DEBUG | log:$LOG"
        info ''
        info "  LOG_FILENAME: $LOG_FILENAME"
        }
#*################ cleanup
    verbose_cleanup() {
        # remove temp file
        rm -rf "$LOG_FILENAME"
        # reset FD's
        exec {LOG}>&-
        exec {ERR}>&-
        exec {INFO}>&-
        exec {DEBUG}>&-
        exec {OUT}>&-
        }
