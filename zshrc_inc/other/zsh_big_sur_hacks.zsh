#? -----------------------------> Install issues on macOS Big Sur

    #* Disable Sleep Image
        #Disabling the Safe Sleep feature means that contents in RAM will not be backed up to the drive should your Mac need to hibernate. When you start your machine back up, your Mac will perform a normal reboot without restoring windows, and opened files.
        # Removing the File:
        # sudo rm /private/var/vm/sleepimage
        #
        # Prevent the File from Being Rebuilt:
        # pmset -g | grep hibernatemode
        # sudo pmset -a hibernatemode 0
        # pmset -g | grep hibernatemode

        # Reference: https://www.techradar.com/how-to/computing/apple/how-to-remove-the-disk-hogging-sleepimage-file-from-your-mac-1305738



    # Reference: https://github.com/pyenv/pyenv/issues/1219

    # BPO="${BREW_PREFIX}/opt/"

	# addflagfrombrew() {
	# 	LDFLAGS="$LDFLAGS -L${BPO}${1}/lib"
	# 	CFLAGS="$CFLAGS -I${BPO}${1}/include"
	# 	CPPFLAGS="$CPPFLAGS -I${BPO}${1}/include"
	# 	PKG_CONFIG_PATH="$PKG_CONFIG_PATH ${BPO}${1}/lib/pkgconfig"
	# }

	# libs=( 'readline' 'openssl' 'zlib' 'libxml2' 'llvm')
	# for lib in $libs; do addflagfrombrew $lib; done;

	# # xcode
    # CFLAGS="$CFLAGS -I$(xcrun --show-sdk-path)/usr/include"

	# # llvm
	# LDFLAGS="$LDFLAGS -L${BPO}llvm/lib -Wl,-rpath,${BPO}llvm/lib"

    # CPPFLAGS="${CFLAGS}${CPPFLAGS}"

	# For compilers to find zlib you may need to set:
	# export LDFLAGS="-L/usr/local/opt/zlib/lib"
	# export CPPFLAGS="-I/usr/local/opt/zlib/include"

	# For pkg-config to find zlib you may need to set:
	# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
