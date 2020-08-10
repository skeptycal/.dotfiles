#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178

    set -a

# ------------------------- gitit -------------------------
#   Automatic repo pre-commit, commit, and push
#
#   Usage: gitit [message]
# ---------------------- Requirements ---------------------
#
#   gpg key generator:          git_gpg.php
#   default status message:     ~/.dotfiles/.stCommitMsg
#
#   example .stCommitMsg:
#       (Gitit Bot): minor updates and formatting.
#       https://www.github.com/skeptycal
# --------------------------
