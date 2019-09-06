#!/usr/bin/env bash

echo "sourcing script .bashrc - forwarding to .bash_profile"

[ -n "$PS1" ] && source ~/.bash_profile
return