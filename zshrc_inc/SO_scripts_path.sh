#!/usr/bin/env sh

echo "option:        result:"
for OPT in $(uname --help | grep -o -e '--\S*\s'); do echo $OPT; done;
