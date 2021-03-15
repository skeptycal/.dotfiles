#!/usr/bin/env zsh

#? -----------------------------> Debug (Dev / Production modes)
    # SET_DEBUG is set to zero for production mode
    # SET_DEBUG is set to non-zero for dev mode
    #   1 - Show debug info and log to $LOGFILE
    #   2 - #1 plus trace and run specific tests
    #   3 - #2 plus display and log everything

    declare -ix SET_DEBUG=0 # ${SET_DEBUG:-0}

    dbecho "SET_DEBUG: $SET_DEBUG" #! debug
    if (( SET_DEBUG>0 )); then
        printf '%b\n' "${WARN:-}Debug Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "DEV mode ($SET_DEBUG) activated"
        trap 'echo "# $(realpath $0) (line $LINENO) Error Trapped: $?"' ERR
        trap 'echo "# $0: Exit with code: $?"' EXIT
    fi
    if (( SET_DEBUG>1 )); then
        printf '%b\n' "${WARN:-}Debug Test Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TEST mode ($SET_DEBUG) activated"
        setopt SOURCE_TRACE
        trap 'echo "# $0: Line Number: $LINENO"' DEBUG
    fi
    if (( SET_DEBUG>2 )); then
        printf '%b\n' "${WARN:-}Debug Trace Mode for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
        dbecho "# DEV TRACE mode ($SET_DEBUG) activated"
        setopt XTRACE # VERBOSE
    fi
