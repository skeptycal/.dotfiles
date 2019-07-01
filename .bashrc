#!/bin/false
echo "sourcing script .bashrc - forwarding to .bash_profile"

[ -n "$PS1" ] && source ~/.bash_profile



# added by travis gem
[ -f /Volumes/Data/skeptycal/.travis/travis.sh ] && source /Volumes/Data/skeptycal/.travis/travis.sh
