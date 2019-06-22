#!/bin/false
#* #############################################################################
#* Theme settings and resources
# [ -r "~/bin/utilities/scripts/basic_text_colors.sh" ] && source "$HOME/bin/utilities/scripts/basic_text_colors.sh"
source /Volumes/Data/skeptycal/bin/utilities/scripts/basic_text_colors.sh

#* #############################################################################
#* Cycle through main sections sourced in resource documents
# for file in ~/.dotfiles/.{path,exports,aliases,functions,extra};
for file in ~/.dotfiles/.{path,exports,aliases,functions,extra,git_alias}; do
    source "$file" # &>/dev/null # comment the &>/dev/null to test for errors
done
unset file

#* #############################################################################
#* list current versions of common utilities
# versions

#* #############################################################################
#* Bam ... make the magic
# source "$ZSH/oh-my-zsh.sh"

export PATH="$HOME/.cargo/bin:$PATH"
