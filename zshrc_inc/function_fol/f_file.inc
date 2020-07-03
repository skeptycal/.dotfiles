#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086


#? ######################## Program Versions Reporting
write_versions_file() {
    br
    me "# Program Versions List"
    me "-------------------------------------------------------------"
    # green "## VERSION_LIST path: $VERSION_LIST"
    blue "**os: $(uname -i) | $(sw_vers -productName) | $(sw_vers -productVersion)**"
    me "### shell:"
    lime "- zsh:            $(zsh --version)"
    # green "- current shell:  $ZSH_VERSION"
    rain "- VSCode:         $(code --version | head -n 1)"
    br
    me "### utilities:"
    warn   "- $(clang --version | grep version | sed 's/version //g')"
    attn   "- $(git --version | sed 's/version //g') with $(hub --version | grep hub | sed 's/version //g')"
    canary "- $(bash --version | grep bash | cut -d ',' -f 1)  ($(bash --version | grep bash | cut -d ' ' -f 4 | cut -d '(' -f 1))${WHITE} with ${GO}GNU grep ($(grep --version | head -n 1 | cut -d ' ' -f 4))${WHITE} and ${CHERRY}GNU coreutils ($(brew list coreutils --versions | cut -d ' ' -f 2))"
    # lime "- homebrew ($(brew --version | tail -n 3 | head -n 1 | cut -d ' ' -f 2))" # and conda ($(conda -V | cut -d ' ' -f 2))"
    canary "- prettier ($(prettier --version))"
    # purple "- stack ($(stack --version | cut -d ',' -f 1 | cut -d ' ' -f 2))"
    blue "- mkdocs ($(mkdocs --version | cut -d ' ' -f 3))"
    # green "- TeXLive(tlmgr)  v$(tlmgr --version | head -n 1 | cut -d ' ' -f 3-4))"
    br

    me "### languages:"
    blue   "- GO      ($(go version | cut -d ' ' -f 3 | sed 's/go//g'))"
    # attn   "- rustc   ($(rustc --version | cut -d ' ' -f 2)) with rustup ($(rustup --version | cut -d ' ' -f 2))"
    warn   "- ruby    ($(ruby -v 2>/dev/null | cut -d ' ' -f 2 | cut -d 'p' -f 1)) with gem ($(gem -v))"
    # purple "- php     ($(php -v 2>/dev/null | grep '(cli)' | cut -d ' ' -f 2)) with composer ($(composer --version | cut -d ' ' -f 3))"
    printf "%s\n" "${COOL}- python  ($(python --version | cut -d ' ' -f 2)) with pip ($(pip --version | cut -d ' ' -f 2)) and pipenv ($(pipenv --version | cut -d ' ' -f 3)) ${RESET_FG}"
    canary "- node    ($(node -v | sed 's/v//g')) with npm ($(npm -v))"
    cherry "- Xcode   ($(/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -version | grep Xcode | sed 's/Xcode //g'))"
    # attn   "- Clojure ($(clojure -Sdescribe | grep version | sed 's/{://g' | sed 's/"//g' | sed 's/version //g')) with lein"
    br

    # attn "- cargo ($(cargo --version | cut -d ' ' -f 2))"
    # attn "  $(lein --version | sed 's/Leiningen/lein version/g' | sed 's/version /       v/g')"

    # me "Travis CI   v$(travis version)"
    } >"$VERSION_LIST"
save_versions() {
    # echo "VERSION_LIST: $VERSION_LIST"
    rm -rf "$VERSION_LIST" >/dev/null
    # touch $VERSION_LIST
    write_versions_file
    }
versions() {
    cat ~/.dotfiles/.VERSION_LIST.md
    }
#? ######################## Directory Utilities
dls () {
 # directory LS
 ls -l | grep "^d" | awk '{ print $9 }' | tr -d "/"
    }
dgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    grep -iR "$@" -- * | grep -v "Binary"
    }
dfgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    # and returns only unique filenames
    grep -iR "$@" -- * | grep -v "Binary" | sed 's/:/ /g' | awk '{ print $1 }' | sort | uniq
    }
psgrep() {
    if [ -n "$1" ] ; then
        echo "Grepping for processes matching $1..."
        ps aux | grep "$1" | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
    }
l1() { # nice sorting ... #TODO no color ...
    # shellcheck disable=2012
    ls -l "$@" | sort -r | awk 'NF==9 { if ($1~/^d/) { print $9 "/" } else { print $9 } }'
    }
mkd(){
        [ $# -eq 0 ] && { echo "$0: (DIRNAME) [MODE]    - default MODE=755"; return; }
        local d="$1"               # get dir name
        local m=${2:-0755}         # get permission, set default to 0755
        # shellcheck disable=2174
        [ ! -d "$d" ] && mkdir -m "$m" -p "$d"
    }
unbak(){
    find . -name "*.bak" -type f -print0 | xargs -0 /bin/rm -f
    }
gather_del() {
    find . -name "${1:-}" -type f -print0 | xargs -0 /bin/rm -f
    }
bak() {
    FILES="$*"
    [[ -d "$PWD/bak" ]] || mkdir "$PWD/bak"
    for file in $FILES; do
        [[ -d "$file" ]] && bak "$file"
        printf "Backup file %s " "$file"
        [[ -f "$file" ]] && cp -f "$file" "bak/${file}.bak" || echo -e "${WARN}backup unsuccessful - ${MAIN}${file}${RESET_FG}"
        echo ''
    done
    }
cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" || return 1
    }
check_file() {
    #? ${VAR##*/}        - return only final element in path (program name)
    #? ${VAR%/*}         - return only path (without program name)
    filename=$(py_realpath $1)
    local name="${filename##*/}"
    local path="${filename%/*}"
    echo "name: $name"
    echo "path: $path"
    local tmp_chk=''
    [[ -e "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} exists"
    [[ -d "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} d"
    [[ -r "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk}-r"
    [[ -w "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk}-w"
    [[ -x "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk}-e"
    [[ -f "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} norm"
    [[ -L "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} link"
    [[ -s "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} size>0"
    [[ -O "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} mine"
    [[ -N "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} dirty"
    [[ -k "$path" ]] && tmp_chk="${tmp_chk}$GO" || tmp_chk="${tmp_chk}$ATTN"
    tmp_chk="${tmp_chk} sticky$RESET"
    echo -e " ->$tmp_chk"
    echo ''
    }
path() {
    path_param=${*:-$PATH} # use all args ... if none, use PATH as default
    # path_param="${path_param//:/ }"  # replace DELIM
    # path_param="${path_param//  / } "     # remove duplicate spaces
    # IFS="$'\n\t :'"

    IFS=':'; for p in ${=path_param};
    do
        # shellcheck disable=2015
        [[ -d "$p" ]] && green "$p" || attn "$p"
    done
    }
chmod_all() {
    # chmod matching files to given mode
    # $1 is path (default $PWD);
    # $2 is pattern (default '*');
    # $3 is mode (default '644' for files, '755' for directories)
    case "$1" in
    '-h' | '--help' | 'help')
        echo "Usage : $0 [path($PWD)] [pattern(*)] [mode(644)]"
        return "$EX_USAGE"
        ;;
    esac
    # Check the given file is exist #
    if [ ! -f "$3" ]; then
        echo "Filename given \"$3\" doesn't exist"
        return 1
    fi
    find -L "${1:-$PWD}" -name "${2:-'*'}" -type f -print0 | xargs -0 chmod "${3:-644}"
    }
datelog() {
    # create a logfile with the date as part of the file_name
    [[ -z $1 ]] && exit 1
    command_text="$*"
    file_name="${PWD}/datelog_$(date "+%m_%d_%y").log"
    printf "\nOutput logged to file: %s\n${file_name}\n"
    printf "\n===================================\n" | tee -a "$file_name"
    printf "Log for %s\n\n" "$(date "+%m/%d/%Y")" | tee -a "$file_name"
    eval "$command_text" | tee -a "$file_name"
    # shellcheck disable=2091 #! exec / eval warning ...
    $("$*") | tee -a "$file_name"
    }
fileop() {
    # TODO work in progress
    return 0
    # File counter, filter, and editor for word or line matches
    # Check 3 arguments are given #
    # if [ "$#" -lt 3 ]; then
    #     echo "Usage : $0 option pattern filename"
    #     return 1
    # fi
    # - # Check the given file is exist #
    # if [ ! -f "$3" ]; then
    #     echo "Filename given \"$3\" doesn't exist"
    #     return 1
    # fi
    # case "$1" in
    # - # Count number of lines matches
    # -i)
    #     echo "Number of lines matches with the pattern $2 :"
    #     fgrep -c -i $2 $3
    #     ;;
    # - # Count number of words matches
    # -c)
    #     echo "Number of words matches with the pattern $2 :"
    #     fgrep -o -i $2 $3 | wc -l
    #     ;;
    # - # print all the matched lines
    # -p)
    #     echo "Lines matches with the pattern $2 :"
    #     fgrep -i $2 $3
    #     ;;
    # - # Delete all the lines matches with the pattern
    # -d)
    #     echo "After deleting the lines matches with the pattern $2 :"
    #     sed -n "/$2/!p" $3
    #     ;;
    # *)
    #     echo "Invalid option"
    #     ;;
    # esac
    }
find_broken() {
    # Find and delete all broken symbolic links in current directiry
    # use safety feature $1 == '-d' to actually delete them
    # interesting method:
    # https://stackoverflow.com/a/26887762/9878098

    if [ -z "$1" ]; then
        echo "Usage: $0 [-d]"
    else
        if [[ "$1" == "-d" ]]; then
            echo "Deleting Broken Symlinks ..."
            find -L "$PWD" -type l -exec rm -- {} +
        else
            echo "Listing Broken Symlinks (use -d to delete links)..."
            find -L ${1:-$PWD} -type l -print 2>&1
        fi
    fi
    }
fix_list() {
    # TODO work in progress
    return 0
    # https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Command-Substitution
    # function_list=$(<~/.dotfiles/.functions | grep -e 'function () { ' | awk '{ printf "%s\\n",$2 }')
    # me "\nAvailable BASH functions (function_list):\n"
    # oe $function_list
    # < ~/.dotfiles/.functions | grep -e " function " | awk '{ print $2 }'
    # echo $function_list >function_list.txt
    }
fs() {
    if du -b /dev/null >/dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$*" ]]; then
        du $arg -- "$*"
    else
        du $arg .[^.]* ./*
    fi
    }
targz() {
    local tmpFile="${*%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1
    size=$(
        stat -f"%z" "${tmpFile}" 2>/dev/null
        stat -c"%s" "${tmpFile}" 2>/dev/null
    )
    local cmd=""
    if ((size < 52428800)) && hash zopfli 2>/dev/null; then
        cmd="zopfli"
    else
        if hash pigz 2>/dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi
    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`âŚ"
    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"
    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2>/dev/null
        stat -c"%s" "${tmpFile}.gz" 2>/dev/null
    )
    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
    }
tre() {
    tree -axC -I '.git|node_modules|bower_components' --dirsfirst "$@" -- | less -FRNX
    }
trw() {
    # TODO work in progress
    return 0
    # -     # trim leading and trailing whitespace
    #     local var="$*"
    #     var="${var#"${var%%[![:space:]]*}"}"
    #     var="${var#"${var&&[!'/']*}"}"
    #     var="${var%"${var##*[![:space:]]}"}"
    #     echo -n "$var"
    }
tt() {
    # alias treetop='tree -L 1'
    tree -L 1 -- "$@"
    }
tree_html() {
    tree -ahlsAFRHD --prune --du --si --dirsfirst >tree.html
    }
unpatch () {
  find . -name "*.orig" -o -name "*.rej"  -type f -exec rm {} \;
  find . -name "b" -type d -exec rm -rf {} \;
    }
web_chmod() {
    # Set default permissions for a folder that will be uploaded to the web.
    # default directory is PWD
    # most files = 644; directories = 755
    [[ -d "$1" ]] && dir="$1" || dir=$PWD
    find -LX "$dir" -type f -print0 | xargs -0 chmod 644
    echo "Changing permissions of all regular files to 0644."
    find -LX "$dir" -type d -print0 | xargs -0 chmod 755
    echo "Changing permissions of all regular directories to 0755."
    # ls "$dir" -ARlh
    }
py_realpath(){
    python3 -c "
from os.path import realpath
from sys import argv
for item in argv[1:]:
    print(f'{item} \'{realpath(item)}\'')
" "$@"
    }
extract () {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)        tar xjf "$1"        ;;
            *.tar.gz)         tar xzf "$1"        ;;
            *.bz2)            bunzip2 "$1"        ;;
            *.rar)            unrar x "$1"        ;;
            *.gz)             gunzip "$1"         ;;
            *.tar)            tar xf "$1"         ;;
            *.tbz2)           tar xjf "$1"        ;;
            *.tgz)            tar xzf "$1"        ;;
            *.zip)            unzip "$1"          ;;
            *.Z)              uncompress "$1"     ;;
            *.7z)             7zr e "$1"          ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
    }
shell () {
  # an odd alternative to using the $SHELL variable
  ps | grep "^$$" | awk '{ print $4 }' | cut -d '-' -f 2
    }
unegg () {
    unzip "$1" -d tmp || return
    rm "$1"
    mv tmp "$1"
    }
# hardlink_dotfiles(){
#     -  convert symlinks to hardlinks
#     ls "$HOME/.dotfiles" -A | perl -nle 'print if -l and not -d;'

#     while IFS="" read -r f || [ -n "$f" ]
#     do
#         f=
#         printf '%s\n' "$p"
#         unlink ""
#         ln "$HOME/.dotfiles/$p" "$HOME"
#     done < lsln.txt
# }
ind() {
    lime Indirect Variable Tests

    value of

    me "echo tests"
    br
    # shellcheck disable=SC2016,SC2086
    ce '  var name (\$1):'"\t\t"            \$$1
    # shellcheck disable=SC2016,SC2086
    ce '  printf "$1":'"\t\t"           "$1"
    # shellcheck disable=SC2016,SC2086
    ce "  printf '\$1':""\t\t"          '$1'
    # shellcheck disable=SC2016,SC2086
    ce '  printf \$1:'"\t\t"         \$$1
    # shellcheck disable=SC2016,SC2086
    ce '  printf "\$$1":'"\t"       "\$$1"
    br
    me "eval tests"
    br
    # shellcheck disable=SC2016,SC2086
    attn '  printf $1:'"\t\t"
    # shellcheck disable=SC2016,SC2086
    eval echo -e $1
    # shellcheck disable=SC2016,SC2086
    attn '  printf "$1":'"\t"
    eval echo -e "$1"
    attn "  printf '\$1':""\t"
    eval echo -e '$1'
    # shellcheck disable=SC2016,SC2086
    attn '  printf \$1:'"\t\t"
    # shellcheck disable=SC2016,SC2086
    eval echo -e \$$1
    # shellcheck disable=SC2016,SC2086
    attn '  printf "\$$1":'"\t"
    eval echo -e "\$$1"
    }
path() { # alias path='echo -e ${PATH//:/\\n}'
    if [[ -z "$1" ]]; then  # no arguments given ... print path
        green "$( echo -e "${PATH//:/\\n}" )"
    elif [ -d "$1" ]; then # if $1 is a directory, highlight the path entries

        IFS=":"
        typeset -a path_list
        # shellcheck disable=SC2207
        path_list=( $( IFS=":" echo -e "$1"; ) )
        echo -e "${path_list[@]}"
        echo -e "#-> -----------------#"
        for s in ${path_list[*]}
        # for s in "${path_list}"
        do
            if [ -h "$s" ]; then
                cool "$s"
            elif [ -d "$s" ]; then
                warn "$s"
            elif [ -x "$s" ]; then
                lime "$s"
            elif [ -O "$s" ]; then
                me "$s"
            elif [ -S "$s" ]; then
                canary "$s"
            elif [ -k "$s" ]; then
                rain "$s"
            elif [ -f "$s" ]; then
                ce "$s"
            else
                cherry "$s"
            fi
        done
        unset 'path_list[-1]'

        # ???âŻ for line in ${PATH//:/ } ; do; echo $RANDOM$line; done;
    else #  if $1 is not a directory, treat it as a : delimited list ($1 is search term)
        needle="$1"
        shift
        echo -e ${${@}//:/\\n} | grep --color ''"$needle"
    fi
    }
gather() {
    # gather - an easy way to gather similar files and do something with them
    #   designed for xargs (GNU findutils) 4.7.0 on macOS Catalina. ymmv
    #   Usage: xargs [OPTION]... COMMAND [INITIAL-ARGS]...
    #   installed with: <brew install findutils>
    gather_test=1 # reset test flag (0|1) (set to 1 for testing)

    #- ######################### process options
        option_string='-0' # default options (-0 is required to work with find -print0)
        if [ -z "$1" ]; then # if no args, exit with usage and error message
            me "$0 ${WHITE:-}[-huv] [-0opt] [xargs options] filetype [utility]"
            attn "error ${EX_USAGE} : a 'filetype' to gather is required" #TODO fix this so I can also lookup text
            return "$EX_USAGE" #TODO and make a shell function to search from the command line or list error codes
        else # process initial options
            case "$1" in
                -h|--help|help|'')
                    me "$GATHER_USAGE"
                    return 0
                ;;
                -u|--usage|usage)
                    me "$0 ${WHITE:-}[-huv] [-0opt] [xargs options] filetype [utility]"
                    return 0
                ;;
                -v|--version|version)
                    me "$0 version $VERSION"
                    ce "$(xargs --version)"
                    return 0
                ;;
                test)
                    gather_test=1
                    shift
                ;;
            esac
        fi
        while [[ ${1:0:1} == '-' ]]; do # process additional options
            option_string+="$1" # add them to the string
            shift
        done

    #- ######################### cleanup options
        option_string=${option_string//0/}'0' # remove all 0 and add a single one (-0 is required)
        option_string='-'${option_string//-/} # remove any '-' symbols and add a single one (formatting)

    #- ######################### setup search pattern
        # default filetype is pdf ... imo, least likely to cause headaches if they are moved accidentally
        gather_pattern=\*"${1:-pdf}"\*
        shift

    #- ######################### setup command
        # remaining args are considered the xargs 'command' or 'utility' and its arguments (default /bin/echo)
        command_string="${*:-/bin/echo}"

    #! ######################## testing
        if [[ $gather_test == 1 ]]; then
            br
            lime "Gathering all files like ${MAIN:-}${gather_pattern}${LIME:-} in current path and recursively."
            green "pwd:                  $PWD"
            green "option_string:        $option_string"
            green "gather_pattern:       $gather_pattern"
            green "command_string:       $command_string"
            br
            blue "# find -x . -name '$gather_pattern' -print0 | xargs $option_string $command_string"
            br

            # mkdir -p ~/books/_new/${gather_pattern//./} >/dev/null
            # find . -name "*.bak" -type f -print0 | xargs0
            # green "$( find . -name \'$gather_pattern\' -type f -print0 | xargs $option_string $command_string )"
        fi
    # issue final command to shell functions - pipe output where you like
    canary "$(find . -name "$gather_pattern" -print0 | xargs "$option_string" "$command_string")"
    # find . -name $gather_pattern -print0 |xargs -0
    }
time_script() {
    count=${1:-2}
    shift
    _t0=$(date +%s%3N)
    _t1=_t0
    for file_name in $@; do
        printf "  ${WARN}line${MAIN} (ms) / ${WARN}cummulative${MAIN} - code  (averaging $count trials)\n" 'line'
        printf "-------------------------------------------------------------\n"
        while read -r _line; do
            # process code here ...
            for ((i = 0 ; i <= count ; i++)); do
                eval $_line &>/dev/null     # process code line
            done
            _tn=$(date +%s%3N)      # get time data
            _tt=$((_tn-_t1))       # time in this step
            _t21=$((_tt / count))
            _dt=$((_tn-_t0))        # time elapsed since start
            printf "${WARN}%8d${MAIN} ms / ${WARN}%8d${MAIN} ms - ${_line}\n" _t21 _dt
            _t1=$_tn
        done < $file_name
    done
    }
time_it() {
    _t0=$(date +%s%3N)
    # process code here ...
    eval "$@" #! this is stupid and dangerous

    _t1=$(date +%s%3N)
    _dt=$((_t1-_t0))
    printf "${MAIN}Code block took ${WARN}%.1f${MAIN}s to run.\n" $_dt
    }
