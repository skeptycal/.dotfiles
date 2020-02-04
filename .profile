#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
# *############################################################################
echo "sourcing script .profile - forwarding to .bash_profile"

[ -n "$PS1" ] && source ~/.zshrc
return
