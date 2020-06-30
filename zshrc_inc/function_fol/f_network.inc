#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

killit() {
    # Kills any process that matches a regexp passed to it
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}
portslay () {
    kill -9 "$(lsof -i tcp:"$1" | tail -1 | awk '{ print $2;}')"
}
exip () {
    # gather external ip address
    echo -n "Current External IP: "
    curl -s -m 5 http://myip.dk | grep "ha4" | sed -e 's/.*ha4">//g' -e 's/<\/span>.*//g'
}
ipaddr () {
    # determine local IP address
    ifconfig | grep "inet " | awk '{ print $2 }'
}

azure_agent() {
    # svc.sh only seems to work when run from its own directory ...
    # added default parameter 'status'
    local temp_pwd="$PWD"
    cd "$AZURE_WORKING_DIR" || return
    "${AZURE_WORKING_DIR}/svc.sh" "${1:-'status'}"
    result="$?"
    cd "$temp_pwd" || return
    unset temp_pwd
    return $result
}


dataurl() {
    local mimeType
    mimeType=$(file -b --mime-type "$1")
    if [[ "$mimeType" == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

digga() { dig +nocmd "$1" any +multiline +noall +answer; }
dist_hook() {
    # TODO not yet implemented
    return 0
    # https://stackoverflow.com/a/8969875
    # find -regextype posix-egrep -regex ".*(\.([chyl]|def|cpy|cob|conf|cfg)|(README|ChangeLog|AUTHORS|ABOUT-NLS|NEWS|THANKS|TODO|COPYING.*))$" -exec sed -i -e 's/\r*$/\r/' {} \;
    # OR
    # for F in Documents/*.{py,html}; do ...something with each '$F'... ; done
}

getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified."
        return 1
    fi
    local domain="${1}"
    echo "Testing ${domain}â€¦"
    echo ""
    local tmp
    local certText
    tmp=$(echo -e "GET / HTTP/1.0\nEOT" |
        openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)
    if [[ "${tmp}" == *"-----BEGIN CERTIFICATE-----"* ]]; then
        certText=$(echo "${tmp}" |
            openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
                no_serial, no_sigdump, no_signame, no_validity, no_version")
        echo "Common Name:"
        echo ""
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
        echo ""
        echo "Subject Alternative Name(s):"
        echo ""
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
            sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
        return 0
    else
        echo "ERROR: Certificate not found."
        return 1
    fi
}
