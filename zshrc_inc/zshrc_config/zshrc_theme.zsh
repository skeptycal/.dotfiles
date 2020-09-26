#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
#?-----------------------------> .zshrc theme
    #*	    Colors ... shortcuts ... the pathway to an easier life ...
    #*      tested on macOS Big Sur and zsh 5.8
    #*	    copyright (c) 2019 Michael Treanor
    #*	    MIT License - https://www.github.com/skeptycal
#? -----------------------------> copyright (c) 2019 Michael Treanor

    # available colors:
    #   MAIN  WARN  COOL  LIME  GO  CHERRY  CANARY  ATTN  RAIN  WHITE  RESET

#? -----------------------------> BLOOM theme colors
#     THEME_NAME='BLOOM'
#     THEME_PROMPT='>'
#     THEME_USER_COLOR=$(printf '%b' "$RAIN")
#     THEME_ROOT_COLOR="$CHERRY"
#     THEME_STATUS_COLOR="$GO"
#     THEME_GIT_CLEAN_COLOR="$COOL"
#     THEME_GIT_DIRTY_COLOR="$WARN"
#     THEME_VENV_COLOR=$(printf '%b' "$GO")
#     THEME_FOLDER_COLOR="$CANARY"
#     THEME_HOST_COLOR="$GO"
#     THEME_PROMPT_COLOR="$LIME"
#     THEME_TIMER_COLOR="$GO"

# #? -----------------------------> BLOOM theme features
#     # possible features:
#     # PS_SHOW="status venv user host folder git prompt timer"
#     PS_SHOW="status venv user host folder git prompt timer"

#     $PS_STATUS="$?"

#     #? -----------------------------> build prompt
#     # Reference: https://erikberglund.github.io/2018/Get-the-currently-logged-in-user,-in-Bash/
#     # prompt format:
#     # status (venv) user@host folder (git) prompt                      timer

#     PS_BUILD=
#     PS_USER=
#     PS_VENV=

#     # prompt status
#     if [[ "$PS_SHOW" =~ "status" ]]; then
#         if (( PS_STATUS > 0 )); then
#             PS_STATUS_COLOR="${WARN:-}"
#         else
#             PS_STATUS_COLOR="${LIME:-}"
#         fi
#         PS_BUILD="${PS_STATUS_COLOR:-}${PS_STATUS} "
#     fi

#     # prompt virtual environment
#     if [[ "$PS_SHOW" =~ "venv" ]]; then
#         if [[ -n $VIRTUAL_ENV ]]; then
#             PS_VENV="${THEME_VENV_COLOR:-}($(basename "$VIRTUAL_ENV"))${RESET:-}"
#             PS_BUILD="${PS_BUILD}${PS_VENV} "
#         fi
#     fi

#     # prompt username
#     if [[ "$PS_SHOW" =~ "user" ]]; then
#         if [[ $loggedInUserID ]]; then
#             PS_USER="${THEME_USER_COLOR:-}${loggedInUser}${RESET:-}"
#         else
#             PS_USER="${THEME_ROOT_COLOR:-}root${RESET:-}"
#         fi
#         PS_BUILD="${PS_BUILD:=}${PS_USER}"
#     fi

#     # prompt host
#     if [[ "$PS_SHOW" =~ "host" ]]; then
#         PS_BUILD="${PS_BUILD}${THEME_HOST_COLOR:-}@$(uname -n)${RESET:-}"
#     else
#         PS_BUILD="${PS_BUILD} "
#     fi

#     # prompt folder
#     if [[ "$PS_SHOW" =~ "folder" ]]; then
#         PS_BUILD="${PS_BUILD}${THEME_FOLDER_COLOR:-}in ${PWD##*/} ${RESET:-}"
#     fi

#     # prompt git
#     if [[ "$PS_SHOW" =~ "git" ]]; then
#         PS_BUILD="${PS_BUILD}${THEME_FOLDER_COLOR:-}on ($(git_current_branch)) ${RESET:-}"
#     fi

#     # prompt prompt
#     if [[ "$PS_SHOW" =~ "prompt" ]]; then
#         PS_BUILD="${PS_BUILD}${THEME_PROMPT_COLOR:-}${THEME_PROMPT} ${RESET:-}"
#     fi

#     # prompt timer
#     if [[ "$PS_SHOW" =~ "timer" ]]; then
#         PS_TIMER="${THEME_TIMER_COLOR:-}${elapsed}ms${RESET:-}"
#     else
#         PS_TIMER=
#     fi
#     #? -----------------------------> prompt with timer in CLI right prompt
#         function preexec() { timer=$(ms); }
#         function precmd() {
#             export PS1="$PS_BUILD"
#             if [ $PS_TIMER ]; then
#                 elapsed=$(($(ms)-$timer))

#                 export RPROMPT="${THEME_TIMER_COLOR:-}${elapsed}ms ${RESET:-}"
#                 unset timer
#             fi
#             }
true
