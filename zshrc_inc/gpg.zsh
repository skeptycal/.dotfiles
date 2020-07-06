#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178

  SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
  OLD_DEBUG=$SET_DEBUG
  SET_DEBUG=1

  if (( SET_DEBUG == 1 )); then
    echo ${ATTN:-}$(gpgconf)${RESET:-}
  fi


# Avoid init unless gpg commands are available.
  if (( ! $+commands[gpgconf] )) || (( ! $+commands[gpg-connect-agent] )); then
    return 0
  fi

# This will launch a new gpg-agent if one isn't running, unless a gpg-agent
# extra-socket has been remote-forwarded.
  export GPG_TTY=$TTY
  gpgconf --launch gpg-agent
  gpg-connect-agent updatestartuptty /bye &>/dev/null

# Change the SSH_AUTH_SOCK if enable-ssh-support is on for gpg-agent.
  if grep -q enable-ssh-support $HOME/.gnupg/gpg-agent.conf 2>/dev/null; then
    unset SSH_AGENT_PID
    if [[ ${gnupg_SSH_AUTH_SOCK_by:-0} -ne $$ ]]; then
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi
  fi

    SET_DEBUG=$OLD_DEBUG
