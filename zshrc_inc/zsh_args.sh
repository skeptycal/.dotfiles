#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
  # shellcheck shell=bash
  # shellcheck source=/dev/null
  # shellcheck disable=2178,2128,2206,2034
#? ################# zsh_args.sh - process common cli args for macOS with zsh
 #* copyright (c) 2019 Michael Treanor     -----     MIT License
 #* https://www.github.com/skeptycal

 . $(which ansi_colors.sh)

#? -----------------------------> parameter expansion tips
 #? ${PATH//:/\\n}    - replace all colons with newlines
 #? ${PATH// /}       - strip all spaces
 #? ${VAR##*/}        - return only final element in path (program name)
 #? ${VAR%/*}         - return only path (without program name)

#? -----------------------------> standard options

# cat >default_options_list.sh <<EOF
cat <<EOF
$(hr)
${BOLD:-}Standard Command-Line Options${RESET:-}

-a | --all		All: show all information or operate on all arguments.
-f | --force		Force: force overwrite of target file(s).
-h | --help		Help: Give usage message and exit.
-l | --list		List: list files or arguments without taking other action.
-o			Output filename
-q | --quiet		Quiet: suppress stdout.
-r | -R | --recursive	Recursive: Operate recursively (down directory tree).
-V | --verbose		Verbose: output additional information to stdout or stderr.
-v | --version		Version: Show program version and exit.
-z | --compress		Compress: apply compression (usually gzip).
-- 			Stop processing arguments.

$(hr)
References:

From Advanced Bash-Scripting Guide
${BLUE:-}<https://tldp.org/LDP/abs/html/index.html>${RESET:-}

 - G.1. Standard Command-Line Options
	${BLUE:-}<https://tldp.org/LDP/abs/html/standard-options.html>${RESET:-}

	Over time, there has evolved a loose standard for the meanings of
	command-line option flags. The GNU utilities conform more closely
	to this "standard" than older UNIX utilities. Traditionally, UNIX
	command-line options consist of a dash, followed by one or more
	lowercase letters. The GNU utilities added a double-dash, followed
	by a complete word or compound word.

	There are other common options and there is some variance between
	programs and operating systems. The above were chosen to be as consitent
	 as possible with the GNU and POSIX standards.

 - 4.10 Table of Long Options
	${BLUE:-}<https://tldp.org/LDP/abs/html/index.html>${RESET:-}


From The GNU C Library (libc)
${BLUE:-}<https://www.gnu.org/software/libc/manual/html_node/index.html#SEC_Contents>${RESET:-}
 - 25.1.1 Program Argument Syntax Conventions
	${BLUE:-}<https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html>${RESET:-}

From IEEE
${BLUE:-}<https://pubs.opengroup.org/onlinepubs/9699919799/mindex.html>${RESET:-}
 - IEEE Std 1003.1-2017 (Revision of IEEE Std 1003.1-2008)
	${BLUE:-}https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html${RESET:-}

From The Art of Unix Programming
${BLUE:-}<http://www.catb.org/esr/writings/taoup/>${RESET:-}
${BLUE:-}<http://>www.catb.org/esr/writings/>${RESET:-}

EOF

# for i in "$@"; do
# 	case $i in
# 		-e=*|--extension=*)
# 		EXTENSION="${i#*=}"
# 		shift # past argument=value
# 		;;
# 		-s=*|--searchpath=*)
# 		SEARCHPATH="${i#*=}"
# 		shift # past argument=value
# 		;;
# 		-l=*|--lib=*)
# 		LIBPATH="${i#*=}"
# 		shift # past argument=value
# 		;;
# 		--default)
# 		DEFAULT=YES
# 		shift # past argument with no value
# 		;;
# 		*)
# 			# unknown option
# 		;;
# 	esac
# done

# echo "FILE EXTENSION  = ${EXTENSION}"
# echo "SEARCH PATH     = ${SEARCHPATH}"
# echo "LIBRARY PATH    = ${LIBPATH}"
# echo "DEFAULT         = ${DEFAULT}"

# # test
# SEARCHPATH=/Users/skeptycal/go/src/github.com/skeptycal/zsh
# echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
# ls -1 "${SEARCHPATH}"/**/*."${EXTENSION}"
# if [[ -n $1 ]]; then
#     echo "Last line of file specified as non-opt/last argument:"
#     tail -1 $1
# fi
