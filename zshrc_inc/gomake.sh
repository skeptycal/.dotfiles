#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> .repo_tools - tools for repo management for macOS with zsh
	#*	system functions
	#*  tested on macOS Big Sur and zsh 5.8
	#*	copyright (c) 2021 Michael Treanor
	#*	MIT License - https://www.github.com/skeptycal
#? -----------------------------> https://www.github.com/skeptycal
#? -----------------------------> environment
	# repo_tools.sh includes ansi_colors.sh
	. "${DOTFILES_INC}/repo_tools.sh" || . $(which repo_tools.sh)

    SCRIPT_NAME=${0##*/}
#? -----------------------------> debug info
	declare -ix SET_DEBUG=${SET_DEBUG:-0}  		# set to 1 for verbose testing

	_debug_tests() {
		if (( SET_DEBUG > 0 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME##*/}${RESET:-}"
			green "Today is $today"
			_test_args "$@"
			dbecho "DEBUG mode is enabled. Set it to 0 to disable these messages."
			dbecho ""
			dbecho "ANSI colors active: $(which ansi_colors.sh)"
			dbecho "Git repo tools active: $(which repo_tools.sh)"
		fi
		}


_gomake() {
	#* dev functions ...
		#/ ******* test setup
		#/ if PWD == gomake_test, clear test directory and remake everything ...
			if [[ ${PWD##*/} = "gomake_test" ]]; then
				warn "gomake_test directory found ... entering test mode."
				cd ..
				rm -rf "gomake_test"
				mkd "gomake_test"
			fi
			#/ ******* test setup

	#* gh must be authenticated to use this script.
		_gh_auth_username
		if [[ -z ${_gh_user} ]]; then
			attn "gh must be authenticated to use this script."
			gh auth login
		fi

	#* check and setup local repo directory
		# create if needed and CD if possible
		if [[ -n "$1" ]]; then
			mkdir -p "$1"
			cd "$1" || ( warn "error creating directory $1"; return 1 )
		fi

		[ -n "$(ls -A ${PWD})" ] && ( warn "directory not empty"; return 1; )

	#* set repo variables
		#* general information
			YEAR=$( date +'%Y'; )

		#* local repo information
			REPO_PATH=${PWD%/*}
			REPO_NAME=${PWD##*/}

		#* github repo information
			GITHUB_USERNAME="$_gh_user"
			GITHUB_URL="https://github.com/${GITHUB_USERNAME}"
			GITHUB_TEMPLATE_PATH="https://github.com/skeptycal/gorepotemplate"
			PAGES_URL="https://${GITHUB_USERNAME}.github.io/${REPO_NAME}"

		#* file header blurbs
			BLURB_GO=$( _file_blurb )
			BLURB_INI=$( _file_blurb '#' )

	#/ at this point, the directory $REPO_NAME (which is also $PWD) is an empty directory in $REPO_PATH
	#* Initial repo setup
		#* remote repo from template (I use GitHub ... change it if you want)

			git init

			gh repo create ${REPO_NAME} -y --public --template $GITHUB_TEMPLATE_PATH
			if (( $? > 0 )); then
				warn "error creating GitHub remote repo ${REPO_NAME}"
				return 1
			fi

			#/ remote repo has been setup based on template

			git fetch origin

		#* .gitignore and initial commit
			makeGI
			git add .gitignore -f
			git tag 'v0.1.0'

			gac 'Initial Commit' # git add and commit function


		#* directory tree
			# based on the unofficial and evolving https://github.com/golang-standards/project-layout

			EXAMPLE_PATH="cmd/example/${REPO_NAME}"
			EXAMPLE_FILE="${EXAMPLE_PATH}/main.go"

			mv -f cmd/example/gorepotemplate $EXAMPLE_PATH


		#* GitHub repo files

			cat >|README.md <cat <<-EOF
				# ${REPO_NAME}

				> Tricky and fun utilities for Go programs.

				---

				![GitHub Workflow Status](https://img.shields.io/github/workflow/status/skeptycal/${REPO_NAME}/Go) ![Codecov](https://img.shields.io/codecov/c/github/skeptycal/${REPO_NAME})

				[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](code-of-conduct.md)

				![Twitter Follow](https://img.shields.io/twitter/follow/skeptycal.svg?label=%40skeptycal&style=social) ![GitHub followers](https://img.shields.io/github/followers/skeptycal.svg?style=social)

				---

				## Getting Started

				### Prerequisites

				-   [Go](https://golang.org/)
				-   [Git](https://git-scm.com/)
				-   [GitHub CLI](https://cli.github.com/)
				-

				Developed with $( go version; ). Go is _extremely_ backwards compatible and semver stable. Nearly any v1.x should work fine.

				---

				### Installation

				To use this repo as a template for your own project:

				```sh
				gh repo create -y --public --template "https://github.com/skeptycal/${REPO_NAME}"
				```

				Clone this repo to test and contribute:

				```bash
				# add repo to $GOPATH (xxxxxx is your computer login username)
				go get github.com/xxxxxx/${REPO_NAME}

				cd ${GOPATH}/src/github.com/xxxxxx/${REPO_NAME}

				# test results and coverage info
				./go.test.sh

				# install as a utility package
				go install

				```

				Use the [Issues][issues] and [PR][pr] templates on the GitHub repo page to contribute.

				---

				### Basic Usage

				> This is a copy of the example script available in the `cmd/example/${REPO_NAME}` folder:

				```go
				package main

				import "github.com/skeptycal/${REPO_NAME}"

				func main() {
					${REPO_NAME}.Example()
				}

				```

				To try it out:

				```sh
				# change to the sample folder
				cd cmd/example/${REPO_NAME}

				# run the main.go program
				go run ./main.go

				# to compile as an executable
				go build
				```

				---

				## Code of Conduct and Contributing

				Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us. Please read the [Code of Conduct](CODE_OF_CONDUCT.md) for details before submitting anything.

				---

				## Versioning

				We use SemVer for versioning. For the versions available, see the tags on this repository.

				---

				## Contributors and Inspiration

				-   Michael Treanor ([GitHub][github] / [Twitter][twitter]) - Initial work, updates, maintainer
				-   [Francesc Campoy][campoy] - Inspiration and great YouTube videos!

				See also the list of contributors who participated in this project.

				---

				## License

				Licensed under the MIT <https://opensource.org/licenses/MIT> - see the [LICENSE](LICENSE) file for details.

				[twitter]: (https://www.twitter.com/skeptycal)
				[github]: (https://github.com/skeptycal)
				[campoy]: (https://github.com/campoy)
				[fatih]: (https://github.com/fatih/color)
				[issues]: (https://github.com/skeptycal/${REPO_NAME}/issues)
				[pr]: (https://github.com/skeptycal/${REPO_NAME}/pulls)

			EOF
			gac 'add README.md'

			cat >|idea.md <cat <<-EOF
				# ${REPO_NAME}

				> $DESCRIPTION

				## Goals
				-

			EOF
			gac 'add idea.md'

			rm -rf gorepotemplate.go
			cat >|${REPO_NAME}.go <cat <<-EOF
				${BLURB_GO}

				// Package ${REPO_NAME} contains utilities for macOS.
				package ${REPO_NAME}

				import "fmt"

				func Example() {
					fmt.Println("Example import acknowledgement from package ${REPO_NAME}")
				}
			EOF
			gac "add ${REPO_NAME}.go with Example()"

			cat >|$EXAMPLE_FILE <cat <<-EOF
				${BLURB_GO}

				// Example for package ${REPO_NAME}.
				package main

				import "github.com/skeptycal/${REPO_NAME}"

				func main() {
					fmt.Println("Example for the ${REPO_NAME} package.")
					${REPO_NAME}.Example()

					// add more code here ...

				}
			EOF
			gac "add ${EXAMPLE_FILE} (main Go run file)."

		#* GitHub Pages site setup
			mkdir -p docs
			git checkout -b gh-pages
			git push origin gh-pages

			git checkout $(git_main_branch)

		#* Go module setup
			go mod init
			go mod tidy
			go doc >|go.doc
			gac "Go modules setup"

		}



#? -----------------------------> main

	gomake() { _gomake "$@"; }
	_main_() {
		(( SET_DEBUG > 0 )) && _debug_tests "$@"
		}
	# _main_ "$@"
	true
