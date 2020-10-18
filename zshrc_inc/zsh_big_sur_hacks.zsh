#? -----------------------------> Install issues on macOS Big Sur
    # Reference: https://github.com/pyenv/pyenv/issues/1219

    BPO="${BREW_PREFIX}/opt/"

	addflagfrombrew() {
		LDFLAGS="$LDFLAGS -L${BPO}${1}/lib"
		CFLAGS="$CFLAGS -I${BPO}${1}/include"
		CPPFLAGS="$CPPFLAGS -I${BPO}${1}/include"
		PKG_CONFIG_PATH="$PKG_CONFIG_PATH ${BPO}${1}/lib/pkgconfig"
	}

	libs=( 'readline' 'openssl' 'zlib' 'libxml2' 'llvm')
	for lib in $libs; do addflagfrombrew $lib; done;

	# xcode
    CFLAGS="$CFLAGS -I$(xcrun --show-sdk-path)/usr/include"

	# llvm
	LDFLAGS="$LDFLAGS -L${BPO}llvm/lib -Wl,-rpath,${BPO}llvm/lib"

    CPPFLAGS="${CFLAGS}${CPPFLAGS}"
