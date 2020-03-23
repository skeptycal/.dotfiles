#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

# ref: https://stackoverflow.com/a/10983009
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")
trap 'rm -rf $tmp_dir' EXIT

# fast Nul files
dd if=/dev/zero of=nullfile1.txt count=1024 bs=1024
dd if=/dev/zero of=nullfile2.txt count=1024 bs=1048576

# text files
dd if=/dev/urandom of=textfile1.txt bs=2048 count=10
dd if=/dev/urandom of=textfile2.txt bs=1048576 count=100

# files of words
python3 -c <<EOF
import sys
with open(/usr/share/dict/words) as w:

EOF


echo "timetest $@"
echo ""

echo 'head -n1 $bigfile >/dev/null'

echo 'sed "1q" $bigfile >/dev/null'

echo 'sed -n "1p" $bigfile >/dev/null'

echo 'read -r line < <(seq 10)'

echo 'read -r line < $bigfile'

echo 'awk "NR==1 {print; exit}" $bigfile'
