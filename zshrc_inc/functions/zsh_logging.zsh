#? -----------------------------> logging
    # todo - something just isn't working out with this ...
    DEFAULT_BOOT_LOG_PREFIX="$HOME/.bootlog_"
    DEFAULT_BOOT_LOG_SUFFIX=".log"
    BOOT_LOG_PATH="${DEFAULT_BOOT_LOG_PREFIX}$(ms)${DEFAULT_BOOT_LOG_SUFFIX}"
    touch "$BOOT_LOG_PATH"

    bootlog(){
        local usage="${WHITE:-}usage: ${MAIN:-}${0} ${DARKGREEN:-}DESCRIPTION...${RESET:-}"
        dbecho "${usage:-}"
        [ -z "$1" ] &&  (dbecho "${usage:-}"; return)
        dbecho "$*"
        builtin echo -E "$*" >>$BOOT_LOG_PATH
    }

    bootlog_error() {
        local usage="${WHITE:-}usage: ${MAIN:-}${0} ${DARKGREEN:-}ERRNO LINENO DESCRIPTION...${RESET:-}"
        if [[ "$1" -eq '-h' ]]; then
            ce "${usage:-}"
            return 0
        fi
        if [ -z "$1" ]; then
            bootlog "Error in $0: line $LINENO - no error code provided ..."
            return 1
        else
            l_errno="$1"
            shift
        fi
        if [ -z "$1" ]; then
            bootlog "Error in $0: line $LINENO - no line number provided ..."
            return 1
        else
            l_lineno="$1"
            shift
        fi

        bootlog "logger error ($l_errno) on line ($l_lineno)..."
        bootlog "${WARN:-}$*"
    }

    # boot_log_setup() {
    #     # todo - something just isn't working out with this ...
    #     # > log_setup [PREFIX] [SUFFIX]
    #     LOG_PATH_PREFIX=${1:=$DEFAULT_BOOT_LOG_PREFIX}
    #     LOG_PATH_SUFFIX=${2:=$DEFAULT_BOOT_LOG_SUFFIX}

    #     # the standard boot logger works when SET_DEBUG is non-zero
    #     if (( SET_DEBUG>0 )); then
    #         # Setup log file and redirect output
    #         # Create a numbered log file from prefix and suffix
    #         LOG_PATH="${LOG_PATH_PREFIX}$(ms)${LOG_PATH_SUFFIX}"

    #         touch "$LOG_PATH"
    #         dbecho "$0 has setup LOG_PATH to point to this file:\n  $LOG_PATH"

    #         # Reference: https://unix.stackexchange.com/a/145654/
    #         # exec &> >(tee -ap 'warn' $LOG_PATH)
    #         # exec &> >(tee -a $LOG_PATH)
    #         exec | tee -a $LOG_PATH
    #         dbecho "$0 redirects logging to file with this command:\n  exec | tee -a $LOG_PATH)"
    #         dbecho ""
    #     fi
    # }

    # todo - something just isn't working out with this ...
    # boot_log_setup
