#!/usr/bin/env bash
# shellcheck source=/dev/null

echo "sourcing script .bashrc - forwarding to .zshrc for zsh"

[ -n "$PS1" ] && source "$HOME/.zshrc"
return
