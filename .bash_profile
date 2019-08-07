#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#* #############################################################################
#* ### Universal BASH debug flag
#* #############################################################################
source "${HOME}/.dotfiles/.config_macos"
# set -am
umask 022

export DEBUG='0' # set to 1 for verbose messages and debugging logs
# log errors to text file; only functional if $DEBUG='1'
export DEBUG_LOG='1'
# log file for debug logs
export debug_log_file="${HOME}/.bash_profile_error.log"
# max filesize for debug_log_file
export debug_log_max_size=32768

function load_themes() {
    # Brew install bash-git-prompt
    if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
        __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
        source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
    fi

    source "${HOME}/.dotfiles/basic_text_colors.sh" # basic_text_colors.sh

    # ANSI color
    export CLICOLOR=1
    export colorflag='--color=always'

    # iterm2 bash shell integration
    source_file "${HOME}/.iterm2_shell_integration.bash"

    # https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
    # /usr/local/opt/coreutils/libexec/gnubin/dircolors -b &>/dev/null
    # GIT colors
    WS="$(git config --get-color color.diff.whitespace "blue reverse")"
    RESET="$(git config --get-color "" "reset")"
    export WS
    export RESET

    # minimum colors if main file isn't available
    # if [ ! "$TEXT_COLORS_LOADED" = '1' ]; then
    #     MAIN=$(echo -en '\001\033[38;5;229m') && export MAIN
    #     BLUE=$(echo -en '\001\033[38;5;38m') && export BLUE
    #     WHITE=$(echo -en '\001\033[37m') && export WHITE
    #     WARN=$(echo -en '\001\033[38;5;203m') && export WARN
    #     GO=$(echo -en '\001\033[38;5;28m') && export GO
    #     RESET=$(echo -en '\001\033[0m') && export RESET
    #     echo -e "${WARN}basic_text_colors is not available."
    #     echo -e "Check path: $colors_file${RESET}"
    #     echo -e "Several basic colors have been implemented:"
    #     echo -e "${MAIN}MAIN   ${WARN}WARN   ${COOL}COOL   ${GO}GO
    #              ${CHERRY}CHERRY   ${CANARY}CANARY   ${ATTN}ATTN
    #              ${PURPLE}PURPLE   ${RESET}RESET"
    # fi
}
function load_resources() {
    for file in ~/.dotfiles/.{path,exports,aliases,functions,extra,git_alias}; do
        source_file "$file" # &>/dev/null # used to test for errors
    done
    unset file
}

function _profile_run_debug() {
    db_echo "${WARN}BASH Debug Mode Enabled (DEBUG=1)${RESET}"
    db_echo "Script source:${MAIN} ${BASH_SOURCE}${RESET}"
    db_echo "Logging to $debug_log_file"
    db_echo "${GO}Use <versions> to see common program versions.${RESET}"
}

function main() {
    clear
    load_themes
    load_resources
    [[ $DEBUG == '1' ]] && _profile_run_debug
}

main "$@"

#* #############################################################################
#* ### End of standard .bash_profile
#* #############################################################################
if which pyenv-virtualenv-init >/dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/opt/perl@5.18/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"

# openssl is keg-only, which means it was not symlinked into /usr/local,
# because Apple has deprecated use of OpenSSL in favor of its own TLS and
# crypto libraries.
export PATH="/usr/local/opt/openssl/bin:$PATH"

#
# A CA file has been bootstrapped using certificates from the SystemRoots
# keychain. To add additional certificates (e.g. the certificates added in
# the System keychain), place .pem files in
#   /usr/local/etc/openssl/certs
#
# and run
#   /usr/local/opt/openssl/bin/c_rehash
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/apr-util/bin:$PATH"
export PATH="/usr/local/opt/apr/bin:$PATH"
export PATH="/usr/local/opt/apr-util/bin:$PATH"
export PATH="/usr/local/opt/openldap/bin:$PATH"
export PATH="/usr/local/opt/openldap/sbin:$PATH"
export PATH="/usr/local/opt/curl-openssl/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
