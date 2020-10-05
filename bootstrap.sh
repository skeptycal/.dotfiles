#!/usr/bin/env bash

# Copy files to home folder.

DOT_FOLDER=~/.dotfiles_test

mkdir -pv $DOT_FOLDER && cd $DOT_FOLDER || exit 1

git clone https://github.com/skeptycal/.dotfiles.git

check_setting() {
    file_name=$1
    question=$2
    file_text=$3

    read -p "$2 " -n 1;
	echo "";
	if [[ -z $REPLY ]]; then
        echo "Skipping $1 setup..."
    else
        echo "$1 is set to $3."
		echo $3 >$1;
	fi;
}

function ask_settings() {
    check_setting '.coveralls.yml' 'Set a coveralls token in ${1}, use xxxxx for a temporary setting, or <ENTER> to skip.' 'repo_token: $REPLY'
}

function setup_brew() {
    git init
    brew doctor >/dev/null 2>&1
    brew install gnupg >/dev/null 2>&1
    brew
}

function doIt() {
	rsync --exclude ".git/" \
		--exclude "_config.yml" \
		--exclude ".DS_Store" \
		--exclude ".big_sur" \
		--exclude "AUTHORS" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
    git init
    brew doctor >/dev/null 2>&1
    brew install gnupg >/dev/null 2>&1
    brew
	source ~/.zshrc;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
unset REPLY
