#!/usr/bin/env bash
###############################################################################
# Setup_ssh.sh
#
# Setup SSH for use with GitHub
#
# - Current as of macOS version ...
# - - ProductName:	    Mac OS X
# - - ProductVersion:	10.14.3
# - - BuildVersion:	    18D42
#
# (part of Setup_macOS.sh)
# ## MacOS shell script to setup a new or refreshed MacOS computer.
# - Test machine: MacBook Pro 11,4 (Retina, 15-inch, Mid 2015)
# - 2.2 GHz Intel Core i7, 16 GB 1600 MHz DDR3, Intel Iris Pro 1536 MB
# - Many settings based on <https://github.com/mathiasbynens/dotfiles>
#
# LICENSE: MIT
#
# @category  CLI_Utility
# @package   CLI_Program
# @author    Michael Treanor  <skeptycal@gmail.com>
# @copyright 2018 (c) Michael Treanor
# @license   MIT <https://opensource.org/licenses/MIT>
# @version   GIT: 2.20.1
# @link      http://www.github.com/skeptycal
#
###############################################################################

# Based on instructions from GitHub: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

# Get macOS version
op_sys_version=`sw_vers -productVersion`

# file to store authentication information
use_get_my_info="$HOME/.ssh/get_my_info.php"

if [ ! -f "$use_get_my_info" ];
then
    # Use this if get_my_info.php exists
    echo -e "Using information on file ...\n\n"
    user_name=`get_my_info.php username`
    user_email=`get_my_info.php email`
    user_password=`get_my_info.php password`
else
    echo -e "Enter authorization information ...\n\n"
	# Get user information
	printf "Setup GitHub authentication on macOS\n"
	printf "************************************\n\n"
	printf "Enter your GitHub username: \n\n"
	read user_name
	printf "\n\n"
	printf "Enter your GitHub email address: \n\n"
	read user_email
	printf "\n\n"
	printf "Enter your GitHub password: \n\n"
	read user_password
	printf "\n\n"
fi

if [[ ${op_sys_version} > 10.12.2 ]]; then
    echo -e "Operating System is > 10.12.2 ... add ~/.ssh/config\n\n"
    echo -e "Host *\nAddKeysToAgent yes\nUseKeychain yes\nIdentityFile ~/.ssh/id_rsa\n" > $HOME/.ssh/config
else
    echo "Operating System Version $op_sys_version does not need ~/.ssh/config mod\n\n"
fi



exit

# Generate SSH key

ssh-keygen -t rsa -b 4096 -C $user_email

# For macOS 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

eval "$(ssh-agent -s)"

major_vers =

if [[ ${op_sys_version} > 10.12.2 ]];
then
    echo -e "Operating System is > 10.12.2 ... add ~/.ssh/config"
    echo -e "Host *\nAddKeysToAgent yes\nUseKeychain yes\nIdentityFile ~/.ssh/id_rsa\n" > $HOME/.ssh/config
else
    echo "Operating System does not need ~/.ssh/config mod"
fi

# /usr/bin/ssh-add -K ~/.ssh/id_rsa

# Reproducing content from AWS forums here, because I found it useful to my use case - I wanted to check which of my keys matched ones I had imported into AWS

# https://stackoverflow.com/questions/9607295/how-do-i-find-my-rsa-key-fingerprint

# openssl pkey -in ~/.ssh/ec2/primary.pem -pubout -outform DER | openssl md5 -c
