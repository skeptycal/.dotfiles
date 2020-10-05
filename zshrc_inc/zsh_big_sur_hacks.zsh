#? -----------------------------> Install issues on macOS Big Sur
    # Reference: https://github.com/pyenv/pyenv/issues/1219

    BPO="${BREW_PREFIX}/opt/"
    LDFLAGS="-L${BPO}readline/lib -L${BPO}openssl/lib -L${BPO}zlib/lib"
    CFLAGS="-I${BPO}readline/include -I${BPO}openssl/include -I${BPO}zlib/include -I$(xcrun --show-sdk-path)/usr/include"
    CPPFLAGS=${CFLAGS}
