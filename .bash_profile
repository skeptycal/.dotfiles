#!/usr/bin/env bash
# -*- coding: utf-8 -*-
umask 022

set -a #? export all;
#* #############################################################################
#* Troubleshooting
#* #############################################################################
# set -n #? trial run - read commands but do not execute
# set -x #? trace 'simple', for, case, select, and arithmetic

# set -E #? trap on ERR is inherited
# set -T #? trap on DEBUG or RETURN is inherited

#? set to 1 for verbose testing
declare -xi SET_DEBUG=0
#? log errors to text file; only functional if $SET_DEBUG=1
(($SET_DEBUG)) && declare -xi DEBUG_LOG=0
#? log file for debug logs
declare -x debug_log_file="${HOME}/.bash_profile_error.log"
#? max filesize for debug_log_file
declare -xi debug_log_max_size=32768

[ -n "$PS1" ] && source ~/.bash_profile_details

#* #############################################################################
#* ### End of standard .bash_profile
#* #############################################################################
