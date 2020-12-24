#!/usr/bin/env zsh
	# -*- coding: utf-8 -*-
	# shellcheck shell=bash
	# shellcheck source=/dev/null
	# shellcheck disable=2178,2128,2206,2034
#*-------------------------------> repo setup (mainly python / golang) for macOS with zsh
  #* copyright (c) 2019 Michael Treanor     -----     MIT License
  #* should not be run directly; called from .bash_profile / .bashrc / .zshrc
#*-------------------------------> https://www.github.com/skeptycal
	# . $(which ansi_colors)
	SET_DEBUG=${SET_DEBUG:-0} # set to 1 for verbose testing
	SCRIPT_NAME=${0##*/}
	_debug_tests() {
		if (( SET_DEBUG == 1 )); then
			printf '%b\n' "${WARN:-}Debug Mode Details for ${CANARY}${SCRIPT_NAME}${RESET:-}"
			green "DEFAULT_ENVIRONMENT_FOLDER_NAME: $DEFAULT_ENVIRONMENT_FOLDER_NAME"
		fi
		}

#*-------------------------------> repo setup
	alias please='sudo '

	# alias d="docker "

	# upgrade all Homebrew repos that are installed
	alias rebrew='brew upgrade $(brew list --formula)'

	# homebrew with big sur issue
	# https://discourse.brew.sh/t/macos-big-sur-issue/8407
	# export SYSTEM_VERSION_COMPAT=1

	alias pc='pre-commit '
	alias pci='pre-commit install && pre-commit install-hooks && pre-commit autoupdate'
	alias pca='pre-commit run --all-files'

#*-------------------------------> template management
	# Path to template files
	# DOTFILES_TEMPLATE="${ZDOTDIR}/template"
	DOTFILES_TEMPLATE="${HOME}/go/src/github.com/skeptycal/util/http/gorepo/template"

	# Path to template files that should be linked
	# Symlinked to ../ so links are copied instead of files
	# DOTFILES_TEMPLATE_LN=${DOTFILES_TEMPLATE}/ln

	function get_template_file () {
		local resource
		local target
		if ! [ -d ${DOTFILES_TEMPLATE} ]; then # template path unavailable?
			attn "Template path unavailable."
			exit 1
		else
			resource="${DOTFILES_TEMPLATE}/${1}"
			target="${PWD}/${resource##*/}"

			# is the requested resource a symlink?
			if [ -h "$resource" ]; then
				resource=$(readlink -m "$resource")
				cyan "${resource##*/}"
				ln -s $resource $target >/dev/null 2>&1
			elif [ -f "$resource" ]; then
				resource=$(realpath -m "$resource")
				green "${resource##*/}"
				cp -au $resource $target >/dev/null 2>&1
			fi
		fi
	}

	function gt () {
		get_template_file "$@"
	}

	function gig () {
		# local template version if available
		[ -f "$DOTFILES_TEMPLATE/.gitignore" ] && get_template_file .gitignore
		# cp $HOME/.dotfiles/.gitignore .

		# gi macos linux windows ssh vscode go zsh node vue nuxt python django
	}

#*-------------------------------> Python
	#   set hash seed to different random number every session
	unset PYTHONDONTWRITEBYTECODE
	export PYTHONHASHSEED="$(shuf -i1-4294967295 -n1)"
	export PYTHONIOENCODING="UTF-8"
#*-------------------------------> pip
	# As of pip 20.2.2, this is a new option to resolve dependencies
	# 	--use-feature=2020-resolver
	# TODO - some conflicts with venv ... python environments alway suck

	# alias pip="python3 -m pip "

	piplist () { python3 -m pip list | sed 's/  */ /g' | awk {'print $1'} | tail -n +3; }
	PIPLIST="$(piplist)"

	alias piu='python3 -m pip install -U '
	alias pipup='piplist | xargs pip install -U ;'

#*-------------------------------> python related
	alias py='python3 -m '

	# change all .py files in current folder to executable
	alias pymod='chmod +x *.py -c --preserve-root -- '

	# display current python path
	alias pypath='python3 -c "import sys; print(sys.path)" | tr "," "\n" | grep -v "egg"'

	# clean out stale pycache files
	alias pyclean='find $PWD -name "*.pyc" -exec rm -rf {} +\; && find $PWD -name "__pycache__" -exec rm -rf {} +\;'

	# format all possible files with Prettier
	# alias pret='prettier -w *'

	# format all possible files with Prettier - ignore unknown files
	alias pret='prettier -uw * 2>/dev/null'

	# colorize output with pygmentize
	alias pm="pygmentize"

	alias dj="python3 manage.py runserver"
	# alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"

#*-------------------------------> python virtual environment
	DEFAULT_ENVIRONMENT_FOLDER_NAME='.venv'
	# older path was 'venv'

	# create a venv
	pyv() {
		python3 -m venv $DEFAULT_ENVIRONMENT_FOLDER_NAME --symlinks
		. ${DEFAULT_ENVIRONMENT_FOLDER_NAME}/bin/activate
		python3 -m pip install -U pip setuptools wheel
	}
	# the ubiquitous "source bin activate"s ...
	alias sba='. ${DEFAULT_ENVIRONMENT_FOLDER_NAME}/bin/activate'
	# turn off the venv
	alias sda='deactivate'

#*-------------------------------> pyenv setup
	[[ $(command -v pyenv >/dev/null) ]] && eval "$(pyenv init -)"
	[[ $(command -v pyenv-virtualenv-init >/dev/null) ]] && eval "$(pyenv virtualenv-init -)"

#*-------------------------------> poetry
	#   python environments suck ... a lot ... virtual environments suck ...
	#   someone should find a better way to do this ... it's so stupid

	#   poetry is the best alternative for now, but there seems to be one
	#   issue that completely ruins poetry: it corrupts pip

	#   if pip becomes corrupted, I have a utility called 'repip' that
	#   fixes it. 'repip' will reinstall pip, check versions of all repos,
	#   install updates, and check dependencies with the new (as of 7/2020)
	#   feature to check version compatibility: --use-feature=2020-resolver

	# poetry init [--name <...>] [--description <...>] [--author <...>] [--dependency <...>] [--dev-dependency <...>] [-l <...>]

	alias p="poetry "
	alias pu="poetry update"
	alias pb="poetry build"
	alias pub="poetry publish --build"

	alias pi='poetry init'
	alias pos='poetry show'
	alias pst="poetry show --tree"
	alias prr='poetry export -f requirements.txt >requirements.txt'

	#   python sucks ... virtual environments suck ...
	#   someone should find a better way to do this ... it's so stupid
	#   'poetry' is the best alternative for now
	export POETRY_REPOSITORIES_TESTPYPI_URL="https://test.pypi.org/legacy/"
	export POETRY_PYPI_TOKEN_TESTPYPI="$PYPI_TOKEN"

	export POETRY_CACHE_DIR="$HOME/Library/Caches/pypoetry"
	export POETRY_VIRTUALENVS_PATH="${POETRY_CACHE_DIR}/virtualenvs"
	export POETRY_PYPI_TOKEN_PYPI="$PYPI_TOKEN"

#*-------------------------------> PIL Library Support
	# for building libraries
	export MAX_CONCURRENCY=8

	# Raqm
    export XML_CATALOG_FILES="/usr/local/etc/xml/catalog" # for the docs

	# then:
	# 	xcode-select --install
	#	sudo xcodebuild -license
	#   brew install libtiff libjpeg webp little-cms2
	#	brew install freetype harfbuzz fribidi
	# 	depends/install_raqm_cmake.sh
	#	python3 -m pip install --upgrade pip
	#	python3 -m pip install --upgrade Pillow
	#	python3 setup.py install


#*-------------------------------> pipenv
	# * I use Poetry instead of PipEnv for now
	# alias pe='pipenv'
	# alias pes='pipenv shell'
	# alias pei='pipenv install'
	# alias peg='pipenv graph'
	# alias ve="virtualenv"
	# alias vew="virtualenvwrapper"

	_debug_tests
	true
