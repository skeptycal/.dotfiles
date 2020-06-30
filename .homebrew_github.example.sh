#!/usr/bin/env false bash
# -*- coding: utf-8 -*-

# Use this link to access the github API token generator
# TODO Add your token here
export HOMEBREW_GITHUB_API_TOKEN=your_token_here

# *################################ References #################################

# GitHub issue #487
# https://github.com/github-tools/github/issues/487

# Homebrew will sometimes give this message:

#       Warning: Error searching on GitHub: GitHub You have triggered an abuse
#       detection mechanism. Please wait a few minutes before you try again.
#
#       The GitHub credentials in the macOS keychain may be invalid.
#       Clear them with:
#
# printf "protocol=https\nhost=github.com\n" | git credential-osxkeychain erase
#
#       Or create a personal access token:
#
# https://github.com/settings/tokens/new?scopes=gist,public_repo&description=Homebrew

# echo 'export HOMEBREW_GITHUB_API_TOKEN=your_token_here' >> ~/.bash_profile

# *################################ Directions #################################
# I do not use these random trailing addons to my files ...

# Instead create a file (this one is the example) called
#       .homebrew_github_private.sh

# The global .gitignore will ignore any file with the word 'private' in it
#   by adding this line in $HOME/.gitignore
#       *private*

# Then place a line in your ~/.bash_profile that says:
#       source "$HOME/.dotfiles/.homebrew_github_private.sh"
