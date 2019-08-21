#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# echo "sourcing script .bash_profile - forwarding to .bash_profile_details"

# set -am # export all;
#* #############################################################################
#* Troubleshooting
#* #############################################################################
# set -n # trial run - read commands but do not execute
# set -x # trace 'simple', for, case, select, and arithmetic
# set -E # trap on ERR is inherited
umask 022
[ -n "$PS1" ] && source ~/.bash_profile_details

# reference: https://unix.stackexchange.com/questions/425757/avoid-sourcing-scripts-multiple-times

[[ $SSM_LOADED != 1 && -f "$(which ssm)" ]] && source "$(which ssm)"
# if [ ! X”” = X”$uniq_var” ] ; then . ~/.bash_profile ; fi

declare -xi SET_DEBUG=0 # set to 1 for verbose testing
# log errors to text file; only functional if $SET_DEBUG='1'
declare -xi DEBUG_LOG=0
# log file for debug logs
declare -x debug_log_file="${HOME}/.bash_profile_error.log"
# max filesize for debug_log_file
declare -xi debug_log_max_size=32768

#* #############################################################################
#* ### End of standard .bash_profile
#* #############################################################################
