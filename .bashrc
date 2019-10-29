#!/usr/bin/env bash

echo "sourcing script .bashrc - forwarding to .zshrc for zsh"

[ -n "$PS1" ] && source ~/.zshrc
return
