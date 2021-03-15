#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#? ---------------------------------------> crontab script
	#* copyright (c) 2019 Michael Treanor     -----     MIT License
	#* should not be run directly; called from crontab or .zshrc, etc.

echo "every version bump counts ..."

# colors and formatting utilities
. ${HOME}/bin/ansi_colors

ZDOTDIR=${ZDOTDIR:=$HOME/.dotfiles}
VERSION_LIST="${ZDOTDIR:-~/.dotfiles}/.VERSION_LIST.md"

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
	lime "- homebrew ($(brew --version | tail -n 3 | head -n 1 | cut -d ' ' -f 2))" # and conda ($(conda -V | cut -d ' ' -f 2))"
	canary "- prettier ($(prettier --version))"
	# purple "- stack ($(stack --version | cut -d ',' -f 1 | cut -d ' ' -f 2))"
	blue "- mkdocs ($(mkdocs --version | cut -d ' ' -f 3))"
	# green "- TeXLive(tlmgr)  v$(tlmgr --version | head -n 1 | cut -d ' ' -f 3-4))"
	br

	me "### languages:"
	ce   "${GOLANG:-}- GO      ($(go version | cut -d ' ' -f 3 | sed 's/go//g'))"
	# attn   "- rustc   ($(rustc --version | cut -d ' ' -f 2)) with rustup ($(rustup --version | cut -d ' ' -f 2))"
	warn   "- ruby    ($(ruby -v 2>/dev/null | cut -d ' ' -f 2 | cut -d 'p' -f 1)) with gem ($(gem -v))"
	purple "- php     ($(php -v 2>/dev/null | grep '(cli)' | cut -d ' ' -f 2)) with composer ($(composer --version | cut -d ' ' -f 3))"
	printf "%b\n" "${COOL}- python  ($(python --version | cut -d ' ' -f 2)) with pip ($(pip --version | cut -d ' ' -f 2)) and pipenv ($(pipenv --version | cut -d ' ' -f 3)) ${RESET_FG}"
	canary "- node    ($(node -v | sed 's/v//g')) with npm ($(npm -v))"
	cherry "- Xcode   ($(/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -version | grep Xcode | sed 's/Xcode //g'))"
	# attn   "- Clojure ($(clojure -Sdescribe | grep version | sed 's/{://g' | sed 's/"//g' | sed 's/version //g')) with lein"
	br

	# attn "- cargo ($(cargo --version | cut -d ' ' -f 2))"
	# attn "  $(lein --version | sed 's/Leiningen/lein version/g' | sed 's/version /       v/g')"

	# me "Travis CI   v$(travis version)"
	} >"$VERSION_LIST"
save_versions() {
	rm -rf "$VERSION_LIST" >/dev/null 2>&1
	write_versions_file
	}

save_versions
