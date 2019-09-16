#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Silence Catalina Warning
export BASH_SILENCE_DEPRECATION_WARNING=1

#* #############################################################################
#* ### Set Options
#* #############################################################################

umask 022 # use root defaults since they match web server defaults

#* #############################################################################
#* ### Troubleshooting
#* #############################################################################

# #?      set to 1 for verbose testing ; remove -r to allow each script to set it
# declare -ir SET_DEBUG=1 
# export SET_DEBUG
# #?      log errors to text file; only functional if $SET_DEBUG=1
# if [[ $SET_DEBUG == 1 ]]; then
#     #? turn on debug logging
#     export DEBUG_LOG=0
#     #? log file for debug logs
#     export debug_log_file="${HOME}/.bash_profile_error.log"
#     #? max filesize for debug_log_file
#     export debug_log_max_size=32768
# fi

# #* #############################################################################
# #* ### Load Profile settings
# #* #############################################################################

# BASH_SOURCE="$0" # to help with zsh transition

# export SOURCE_PATH="$HOME/.dotfiles"
# [ -n "$PS1" ] && . "${SOURCE_PATH}/.bash_profile_details"
# return

# #* #############################################################################
# #* ### Notes and References
# #* #############################################################################

# #   022 - Solo root user - only you can write data, but anyone can read data.
# #   077 - Private: No other user can read or write your data.
# #   002 - Shared - Members of your group can create and modify data files
# #   007 - Private Group - completely exclude users who are not group members.

# #    The default umask for the root user is 022 result into default directory permissions are 755 and default file permissions are 644.
# # The default umask 002 used for normal user. With this mask default directory permissions are 775 and default file permissions are 664.

# #   # Reference: https://www.gnu.org/software/bash/manual/html_node/Th e-Set-Builtin.html
# #   set -ahimBH   #? default interactive - from `echo $-`
# #   set -ahimBHs

# #   set -n        #? trial run - read commands but do not execute
# #   set -x        #? trace 'simple', for, case, select, and arithmetic
# #   set -E        #? trap on ERR is inherited
# #   set -T        #? trap on DEBUG or RETURN is inherited
# #* #############################################################################
# #* ### End of standard .bash_profile
# #* #############################################################################
