	#!/usr/bin/env false sh

	. "${DOTFILES_INC}/repo/repo_tools.zsh"

	#* input information
	# TODO - create and load from config file ...
		AUTHOR="AUTHOR NAME"
		AUTHOR=${AUTHOR:=$( git config --global user.name )} # only get git user.name if AUTHOR is blank

		LICENSE="MIT"
		AUTHOR_URL="https://github.com/USERNAME"
		AUTHOR_GITHUB="https://github.com/USERNAME"
		AUTHOR_TWITTER="http://twitter.com/USERNAME"
		DESCRIPTION="Tricky and fun utilities for Go programs on macOS."

		_default_commit_message_filename=~/${DOTFILES_INC}/.stCommitMsg

		_default_commit_message=$(cat ~/${DOTFILES_INC}/.stCommitMsg) >/dev/null 2>&1
		_default_commit_message=${_default_commit_message:="# Minor updates and formatting\n# ${AUTHOR}<${AUTHOR_URL}>"}
