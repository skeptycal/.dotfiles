#? -----------------------------> oh-my-zsh options

    # if [ -x dircolors ]; then
    #     eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.ansi-dark`
    # fi

# Using ZSH shell - http://zsh.sourceforge.net/

# HISTORY options are set in zshrc_exports 'history' section
# extendedhistory
# histexpiredupsfirst
# histfindnodups
# histignoredups
# histignorespace
# histreduceblanks
# histverify
# sharehistory

# set automatically at invocation of the shell:
# INTERACTIVE SHIN_STDIN MONITOR EXEC ZLE

# Directory options:
setopt AUTO_CD CDABLE_VARS CHASE_DOTS

# Directory stack options:
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT PUSHD_TO_HOME PUSHD_MINUS

# Completions:
setopt ALWAYS_TO_END AUTO_LIST AUTO_PARAM_SLASH AUTO_PARAM_KEYS
setopt AUTO_REMOVE_SLASH COMPLETE_ALIASES COMPLETE_IN_WORD
setopt GLOB_COMPLETE LIST_AMBIGUOUS REC_EXACT

# Expansion and Globbing
setopt NO_CASE_GLOB EXTENDED_GLOB GLOB_DOTS GLOB_STAR_SHORT
setopt NULL_GLOB NUMERIC_GLOB_SORT

# Initialisation
setopt ALL_EXPORT GLOBAL_EXPORT GLOBAL_RCS NO_RCS

# Input/Output
# The shell variable CORRECT_IGNORE may be set to a pattern to match
#   words that will never be offered as corrections.
setopt NO_CORRECT NO_CORRECT_ALL INTERACTIVE_COMMENTS
setopt NO_FLOW_CONTROL MAIL_WARNING PATH_DIRS RC_QUOTES
setopt AUTO_MENU NO_MENU_COMPLETE
# todo - try these out
setopt PRINT_EXIT_VALUE SHORT_LOOPS

# Job Control
setopt AUTO_RESUME NO_BG_NICE CHECK_JOBS CHECK_RUNNING_JOBS
setopt LONG_LIST_JOBS NOTIFY

# Prompting
setopt PROMPT_BANG PROMPT_SUBST TRANSIENT_RPROMPT

# Scripts and Functions
setopt NO_ALIAS_FUNC_DEF C_BASES OCTAL_ZEROES C_PRECEDENCES MULTIOS
# these can cause issues and are mainly for debugging:
# setopt DEBUG_BEFORE_CMD ERR_RETURN EVAL_LINENO FUNCTION_ARGZERO

# Shell Emulation
setopt NO_CLOBBER APPEND_CREATE SH_WORD_SPLIT SH_NULLCMD
setopt CONTINUE_ON_ERROR TRAPS_ASYNC
# setopt KSH_ARRAYS # arrays begin at index 0

# ZLE
setopt COMBINING_CHARS
