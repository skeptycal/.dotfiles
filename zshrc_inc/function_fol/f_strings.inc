#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

#TODO find this text ... _pretty_usage
_pretty_usage=''

#TODO ------------------ Works in Progress
dict() { grep "$@" /usr/share/dict/words; }
colon_list() { echo -e "${1//:/\\n}"; }
in_str() { string=${@:2}; return $([ -z "${string##*$1*}" ]); }
is_instr() { return $([[ "${@:2}" == *"$1"* ]]); }
lower() { ce "${*:l}"; } # return all args as lowercase (zsh only)
upper() { ce "${*:u}"; } # return all args as uppercase (zsh only)
lower_file() {
    # set force_lower if first arg is '-f' else echo only

        # original
        #   t=$(echo $f | tr '[:upper:]' '[:lower:]')
        #   zsh uses ${file:l}
    local force_lower=0
    local file=
    if [[ $1 == '-f' ]]; then
        force_lower=1
        shift
    fi
    for file in "$@"; do
        if [[ $force_lower == 1 ]]; then
            mv -ub "$file" "${file:l}"
        else
            echo "$file" "${file:l}"
        fi
    done
    unset force_lower file
    }

replace() {
    if [[ -z "$1" ]]; then
        attn $'missing argument ...'
        me $'\nUsage: replace ORIGINAL [NEW] [FILES...]'
        exit "$EX_USAGE"
    fi
    ORIGINAL="$1"
    REPLACEMENT="${2:-}"
    FILES="${3:-'.'}"

# shellcheck disable=2013,2086
for word in $(grep -Fl $ORIGINAL $FILES)
do
  # -------------------------------------
  ex $word <<EOF
  :%s/$ORIGINAL/$REPLACEMENT/g
  :wq
EOF
  # :%s is the "ex" substitution command.
  # :wq is write-and-quit.
  # -------------------------------------
done
    }

safe_split() {
    # use custom IFS for safe word splitting of oddly formatted strings
    if [ -z "$2" ]; then
        attn "Usage: safe_split <DELIMITER> <DATA (array | string | file)>"
    else
        IFS="$1"
        shift
        ce "$*"
    fi
    }

prettier_here() {
    # $1 = path (default $PWD); $2 = filenames ( default '*')
    # OR
    # $1 = 'git'; $2 = "$files"
    if [[ "$1" == 'git' ]]; then
        FILES=$(git diff --cached --name-only | sed 's| |\\ |g')
        echo "${2:-$FILES}" | xargs prettier --write | grep -e '[[:space:]]\?[[:digit:]]\+ms'
    else
        find -L "${1:-$PWD}" -name "${2:-'*'}" -type f -print0 | xargs -0 prettier --write | grep -e '[[:space:]]\?[[:digit:]]\+ms'
    fi
    }
pretty() {
    # Use prettier to format all compatible selected files
    # Use $1 for pattern, -m (github diff) or default is '*'
    if [[ -z "$1" ]]; then
        echo "Making all the things pretty! (use pretty -h for help)"
        yes_no 'Make all of the things Prettier? (Y/n) '
        if [ "$?" ]; then
            ce "$_pretty_usage"
        else
            prettier_here
        fi
    else
        case "$1" in
        '-h' | '--help' | 'help')
            ce "$_pretty_usage"
            return "$EX_USAGE"
            ;;
        '-m' | '--commit-message' | 'commit')
            # echo "Making your git staged file pretty ..."
            # select stated files
            FILES=$(git diff --cached --name-only | sed 's| |\\ |g')
            # Prettify all selected files
            prettier_here
            # Add back the modified/prettified files to staging
            echo "$FILES" | xargs git add
            git commit -m "prettybot: $2"
            git status
            ;;
        *)
            prettier_here "$PWD" "$1"
            ;;
        esac
    fi
    }
