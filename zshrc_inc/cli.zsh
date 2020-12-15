#!/usr/bin/env zsh
# -*- coding: utf-8 -*-
    # shellcheck shell=bash
    # shellcheck source=/dev/null
    # shellcheck disable=2178,2128,2206,2034
#? -----------------------------> cli.zsh - functions for macOS with zsh
	#*	cli functions
	#*  main dev / test environment
	#*  - zsh 5.8 (x86_64-apple-darwin20.0)
	#* 	- Darwin Kernel Version 20.1.0: Sat Oct 31 00:07:11 PDT 2020
	#*  - go version go1.15.3 darwin/amd64
	#* 	- Python 3.8.6 (default, Oct  8 2020, 14:06:32)
	#* 	- Clang 12.0.0 (clang-1200.0.32.2)
	#*	copyright (c) 2019 Michael Treanor
	#*	MIT License - https://www.github.com/skeptycal
#? -----------------------------> https://www.github.com/skeptycal

# Fun fact: sysctl is available from the terminal in recovery mode, while
# many other tools are not.

# ref: https://serverfault.com/questions/112711/how-can-i-get-cpu-count-and-total-ram-from-the-os-x-command-line

function create_system_header_data_file() {
	# ref: https://serverfault.com/questions/112711/how-can-i-get-cpu-count-and-total-ram-from-the-os-x-command-line
	# e.g.
		#   Model Name: MacBook Pro
		#   Model Identifier: MacBookPro11,4
		#   Processor Name: Quad-Core Intel Core i7
		#   Processor Speed: 2.2 GHz
		#   Number of Processors: 1
		#   Total Number of Cores: 4
		#   L2 Cache (per Core): 256 KB
		#   L3 Cache: 6 MB
		#   Hyper-Threading Technology: Enabled
		#   Memory: 16 GB
	rm -rf ~/local_coding/clash/header_data.txt
	/usr/sbin/system_profiler SPHardwareDataType | tail -n +5 | head -n -6 >~/local_coding/clash/header_data.txt
}

function bcli_trim_whitespace() {
    # Function courtesy of http://stackoverflow.com/a/3352015
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}
