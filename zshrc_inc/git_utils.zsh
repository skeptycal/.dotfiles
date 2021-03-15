#!/usr/bin/env false zsh # source only ...
###################################################################
####### git_utils
###################################################################

. ~/bin/ansi_colors

function os () {
    # $(uname | tr '[:upper:]' '[:lower:]')
    case "$OSTYPE" in
        solaris*) echo "SOLARIS" ;;
        darwin*)  echo "OSX" ;;
        linux*)   echo "LINUX" ;;
        bsd*)     echo "BSD" ;;
        msys*)    echo "WINDOWS" ;;
        *)        echo "unknown: $OSTYPE" ;;
    esac
}

function travis_os() {
    OS=$(uname -o | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/" )

    case $OS in
    linux*)
        export TRAVIS_OS_NAME=linux
        ;;
    darwin*)
        export TRAVIS_OS_NAME=osx
        ;;
    msys*|cygwin*|ming*)
        export TRAVIS_OS_NAME=windows
        ;;
    *)
        export TRAVIS_OS_NAME=notset
        ;;
    esac
}
# generate a basic README.md
# for git repositories in go
function basic_readme() {
    REPO_NAME=${1:-${PWD##*/}}
	if ! [ -f README.md ]; then
	(
		echo "Repo: ${REPO_NAME}"
        echo "Version: $(version)"
		echo ""
		echo "go version: $(go version)"
		echo ""

	) >> README.md
	fi
}

# is the major version v0?
function is_v0() { (( $(major) == 0 ));	}

# return the repo remote url
function repo_url() { echo $(git remote get-url origin); }

# return the current branch
function current_branch() { echo $(git branch --list | grep '*' | awk '{ print $2 }' ); }

# return the full version from the latest git tag
# function version_full() { echo $(git describe --tags $(git rev-list --tags --max-count=1)); }
function version_full() { git tag | tail -n 1; }

# return the SemVer version in the format MAJOR.MINOR.PATCH
function version() { version_full  | cut -d '-' -f 1; }

# return the Major version
function major() { version | cut -d '.' -f 1 | tr -d 'v'; }

# return the Minor version
function minor() { version | cut -d '.' -f 2; }

# return the Patch version
function patch() { version | cut -d '.' -f 3; }

# return the timestamp used for dev versions
function git_tag_timestamp() { gdate '+%_s+%N'; }

# List changes between commits
# use --shortstat, --stat, or --numstat
function git_changes() { git diff ${1:-'--stat'} HEAD~5 HEAD; }

# List filenames changed between commits
function git_show() { git show --name-only; }

# cd to Git repo RooT directory
function grt() { cd "$(git rev-parse --show-toplevel || echo .)"; }

# Git Version with Timestamp
# takes the current v(major.minor.branch) and adds a numeric timestamp
#
# e.g. if version is v0.1.2, gvt gives v0.1.2.1608816656.770262000
# or similar ... the last 2 fields are the seconds since epoch
# (seconds since 1970-01-01 00:00:00 UTC) and
# current nanoseconds (000000000..999999999)
function newtag() { git tag "$(version)-$(git_tag_timestamp)"; }
