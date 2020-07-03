#!/usr/bin/env false zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2230,2086

set_gamma () {
  xrandr --output eDP1 --gamma "$1":"$1":"$1"
    }
cs_on() {
  set_gamma 1.7
    }
cs_off()  {
  set_gamma 1.0
    }
phpserver() {
    local port
    port="${1:-4000}"
    local ip
    ip=$(ipconfig getifaddr en0)
    sleep 1 && open "http://${ip}:${port}/" &
    php -S -c "$PWD" "${ip}:${port}" -
    }
pk() { pkill -9 -u "$(id -u "$1")"; } # kill another user's processes
pyver() {
    # silly function to address the lack of correct output from
    #   python 2.7 executable in this sitation 'python --version'
    python -c "print('.'.join(str(i).strip() for i in __import__('sys').version_info[:3]))"
    }
server() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    python2 -c 'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
    }
setup_tools() {
    # TODO Work in progress
    return 0
    # https://www.createdbypete.com/ruby-on-rails-development-setup-for-macos/
    echo "Setup for Homebrew, Node.js, Python, etc."
    echo ''
    if [ "$(yes_no 'Fresh Homebrew and tools setup?')" ]; then
        echo "Homebrew ..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew update &>/dev/null && brew cleanup &>/dev/null && brew doctor &>/dev/null
        brew install bash zsh coreutils cython python git hub heroku leiningen clojure php node
        brew reinstall node && echo -e "==> Installation successful! node.js $(node -v) installed."
    else
        return 1
    fi
    }

travis_trigger() {
    # TODO needs more testing - strange errors
    return 0
    # Travis CI CLI API
    # Travis CI Client (CLI and Ruby library)
    # https://github.com/travis-ci/travis.rb#mac-os-x-via-homebrew
    # macOS:
    # brew install ruby
    # gem update --system
    #
    # Using the CLI
    # travis login --org --auto
    # travis token
    # You can keep this token in an environment variable TRAVIS_TOKEN, as long as the file you keep it in is not version-controlled somewhere public.
    # I use this function to submit triggers:
    # local org=$1 && shift
    # local repo=$1 && shift
    # local branch=${1:-master} && shift
    # body="{
    #         \"request\": {
    #         \"branch\": \"${branch}\"
    #         }
    #     }"
    # curl -s -X POST \
    #     -H "Content-Type: application/json" \
    #     -H "Accept: application/json" \
    #     -H "Travis-API-Version: 3" \
    #     -H "Authorization: token $TRAVIS_TOKEN" \
    #     -d "$body" \
    #     "https://api.travis-ci.org/repo/${org}%2F${repo}/requests"
    }
