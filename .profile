#!/usr/bin/env bash
# *############################################################################
echo "sourcing script .profile - forwarding to .bash_profile"

[ -n "$PS1" ] && source ~/.bash_profile
