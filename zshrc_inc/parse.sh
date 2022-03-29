#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034
#? ################# zsh_args.sh - process common cli args for macOS with zsh
 #* copyright (c) 2019 Michael Treanor     -----     MIT License
 #* https://www.github.com/skeptycal

#? -----------------------------> parameter expansion tips
 #? ${PATH//:/\\n}    - replace all colons with newlines
 #? ${PATH// /}       - strip all spaces
 #? ${VAR##*/}        - return only final element in path (program name)
 #? ${VAR%/*}         - return only path (without program name)

 . $(which ansi_colors.sh)

#? -----------------------------> standard options


for i in "$@"; do
	case $i in
		-e=*|--extension=*)
		EXTENSION="${i#*=}"
		shift # past argument=value
		;;
		-s=*|--searchpath=*)
		SEARCHPATH="${i#*=}"
		shift # past argument=value
		;;
		-l=*|--lib=*)
		LIBPATH="${i#*=}"
		shift # past argument=value
		;;
		--default)
		DEFAULT=YES
		shift # past argument with no value
		;;
		*)
			# unknown option
		;;
	esac
done

echo "FILE EXTENSION  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "LIBRARY PATH    = ${LIBPATH}"
echo "DEFAULT         = ${DEFAULT}"

# test
SEARCHPATH=/Users/skeptycal/go/src/github.com/skeptycal/zsh

echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
ls -1 "${SEARCHPATH}"/**/*."${EXTENSION}"
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
