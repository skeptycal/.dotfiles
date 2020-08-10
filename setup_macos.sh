#!/usr/bin/env bash
###############################################################################
# Setup_MacOS.sh
#
# - Current as of macOS version ...
# - - ProductName:	    Mac OS X
# - - ProductVersion:	10.14.3
# - - BuildVersion:	    18D42
#
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
# General Setup
###############################################################################

# Close any open System Preferences panes, to prevent them from overriding settings we are about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password up front
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Stop Apache Server (if needed)
sudo apachectl stop &> /dev/null
brew services stop httpd &> /dev/null
brew services stop php &> /dev/null

# Make sure all server instances are killed
sudo pkill -f /usr/local/Cellar/httpd* &> /dev/null
sudo pkill -f /usr/sbin/httpd* &> /dev/null
sudo pkill -f /usr/local/opt/httpd* &> /dev/null

###############################################################################
# Updates & Cleanup
###############################################################################

clear
printf "\e[33;1m%s\n""\n\n#################################################### "
printf "\e[33;1m%s\n"%s'--> Installation and configuration for MacBook Pro.\n\n'

# TODO Can I install xcode and CL tools automatically?
printf "\e[37;1m%s\n""Install XCode, Magnet, Amphetamine, Display Menu, Slack, Kindle, etc from the app store ...\n"
printf "\e[31;1m%s\n"" **Be sure you have opened Xcode and agreed to the terms of use.**\n\n"

printf "\e[37;1m%s\n""\nPress <ctrl-C> to exit now or any other key to continue...\n\n"

read   # ! Pause

printf "  Performing Disk Cleanup ...\n\n"

# Empty the Trash on all mounted volumes and the main HDD, clear system logs, clear download history
sudo rm -rfv /Volumes/*/.Trashes &> /dev/null
sudo rm -rfv ~/.Trash &> /dev/null
sudo rm -rfv /private/var/log/asl/*.asl &> /dev/null
sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent' &> /dev/null

# Recursively delete `.DS_Store` files (optional)
sudo find . -type f -name '*.DS_Store' -ls -delete &> /dev/null

###############################################################################
# Install new software
###############################################################################

printf "Installing / updating Homebrew as needed ...\n\n"
[[ $(command -v brew) == "" ]] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

printf "Installing / updating Node as needed ...\n\n"
[[ $(command -v node) == "" ]] && brew install node &> /dev/null

printf "\n\nUpdating Ruby and Gems ...\n\n"
# Install latest ruby even though macOS has a version
brew install ruby &> /dev/null
sudo gem update -q --system &> /dev/null
sudo gem update -qf &> /dev/null
sudo gem cleanup -q &> /dev/null

# Interactive Ruby
# https://www.ruby-lang.org/en/documentation/quickstart/
gem install irb

# http://rvm.io/ - Ruby Version Manager (RVM)
# ! causing issues as of 2/14/19
# gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &> /dev/null
# curl -sSL https://get.rvm.io | bash -s stable --rails
# rvm autolibs 4
# rvm cleanup all
# source $HOME/.rvm/scripts/rvm



# Cleanup and checkup
brew update &> /dev/null && brew doctor &> /dev/null && brew cleanup &> /dev/null
###############################################################################
# Script Content
###############################################################################


printf "Updating Xcode tools and macOS ...\n\n"
sudo xcode-select --install &> /dev/null
sudo softwareupdate -i -a

# Gather Information

kernel_name=`uname -s`
kernel_release=`uname -r`
arch_name=`uname -m`
device_version=`uname -i`
op_sys_name=`sw_vers -productName`
op_sys_version=`sw_vers -productVersion`
sec_virtual_flag=`system_profiler SPSoftwareDataType | grep Secure | tr -d ' \t'`
sip_flag=`system_profiler SPSoftwareDataType | grep Integrity | tr -d ' \t'`

printf "\e[33;1m%s\n"
printf "This device is a $arch_name based device.\n"
printf "(apple hardware version $device_version).\n"
printf "It is running on $op_sys_name version $op_sys_version.\n"
printf "The kernel is $kernel_name version $kernel_release.\n"
printf "$sec_virtual_flag\n"
printf "$sip_flag\n"

printf "\nBasic system software is in place and updated. Ready for specific packages.\n"
printf "\nPress <ctrl-C> to exit now or any other key to continue...\n\n"

read   # ! Pause

# Good time to check ...
brew install --with-toolchain llvm &> /dev/null
brew upgrade llvm
brew install cmake &> /dev/null
brew upgrade cmake
brew install openssl &> /dev/null
brew upgrade openssl

brew install go
brew install direnv
brew install django-completion

# Kinda handy ... For Mac and Linux Operation Systems use the following curl command
# to install git, docker, kubectl, helm and IBM Cloud Developer Tools CLI.
printf "Installing IBM Cloud Developer Tools.\n"
printf "Includes Git, Docker, Kubectl, Helm, and IBM CLI ...\n\n"

sudo curl -sL https://ibm.biz/idt-installer | bash

printf "\n\nInstalling gnupg, bash, ruby, npm (with node), httpd (apache2), composer, sqlite, and php ...\n\n"
# Install gnupg (gpg), bash, ruby, npm (with node), httpd, composer, sqlite, php
brew install gnupg bash ruby npm httpd composer php

# Restart Apache Server
brew reinstall httpd &> /dev/null
brew reinstall php &> /dev/null
brew services start httpd
brew services start php

# Update npm to latest version
printf "\n\nUpdating npm and node ...\n"
sudo npm install npm -g
sudo npm update -g

# Install Composer
printf "\n\nInstalling Composer ...\n\n"
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "printf hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 printf "ERROR: Invalid Composer installer signature\n\n"
else
    php composer-setup.php --quiet
    printf "Composer installation successful.\n\n"
fi

rm composer-setup.php
# Yes, it is redundant ...
sudo composer self-update

# Install python (and python@2 for backwards compatability)
printf "\n\nInstalling Latest Python and iPython (and 2.x for compatability) ...\n\n"
brew install python ipython python@2

# Install anaconda (optional)
printf "\n\nInstalling Latest Anaconda (add it to the path!) ...\n\n"
brew cask install anaconda

# Fix annoying possible install issues
brew install docker &> /dev/null
brew link --overwrite docker &> /dev/null
brew reinstall pinentry &> /dev/null


git config --global user.signingkey $(php $HOME/.dotfiles/git_gpg.php)

# Cleanup and checkup
# * Warning: Calling 'brew prune' is deprecated! Use 'brew cleanup' instead.
brew up &> /dev/null
brew doctor &> /dev/null
brew cleanup &> /dev/null

printf "\e[33;1m%s\n""\n\n#################################################### "
printf "\e[33;1m%s\n"%s'--> Installation Complete.\n\n'

printf "This device is a $arch_name based device.\n"
printf "(apple hardware version $device_version).\n"
printf "It is running on $op_sys_name version $op_sys_version.\n"
printf "The kernel is $kernel_name version $kernel_release.\n"
printf "$sec_virtual_flag\n"
printf "$sip_flag\n\n"

# Verify Versions
xcode_version=`xcode-select -v`
brew_version=`brew --version | awk 'NR == 1 {print}'`
git_version=`git --version`
gpg_version=`gpg --version | awk 'NR == 1 {print}'`

httpd_version=`httpd -v`
sqlite_version=`sqlite --version`
php_version=`php -v | awk 'NR == 1 {print}'`
composer_version=`composer -V`

python_version=`python --version`
pip_version=`pip --version`
conda_version=`conda -V`
ipython_version=`ipython --version`

ruby_version=`ruby -v`
rvm_version=`rvm -v`
irb_version=`irb -v`
gem_version=`gem -v`

node_version=`node -v`
npm_version=`npm -v`
java_version=`java --version`

# Verify Versions
printf "\e[33;1m%s\n""\n\n####################################################\n"
printf "xcode_version=`xcode-select -v`\n"
printf "brew_version=`brew --version | awk 'NR == 1 {print}'`\n"
printf "git_version=`git --version`\n"
printf "gpg_version=`gpg --version | awk 'NR == 1 {print}'`\n"

printf "\e[33;1m%s\n""\n\n####################################################\n"
printf "httpd_version=`httpd -v`\n"
printf "sqlite_version=`sqlite --version`\n"
printf "php_version=`php -v | awk 'NR == 1 {print}'`\n"
printf "composer_version=`composer -V`\n"

printf "\e[33;1m%s\n""\n\n####################################################\n"
printf "python_version=`python --version`\n"
printf "pip_version=`pip --version`\n"
printf "conda_version=`conda -V`\n"
printf "ipython_version=`ipython --version`\n"

printf "\e[33;1m%s\n""\n\n####################################################\n"
printf "ruby_version=`ruby -v`\n"
printf "rvm_version=`rvm -v | awk 'NR == 1 {print}'`\n"
printf "irb_version=`irb -v`\n"
printf "gem_version=`gem -v`\n"

printf "\e[33;1m%s\n""\n\n####################################################\n"
printf "node_version=`node -v`\n"
printf "npm_version=`npm -v`\n"
printf "java_version=`java --version`\n"


npm install -g nodemon



exit



# Locate Database Information
# * locate database location: /var/db/locate.database
# * Script to update the locate database: /usr/libexec/locate.updatedb
# * Job that starts the database rebuild:
# *   /System/Library/LaunchDaemons/com.apple.locate.plist

################################################################################
# # General Cleanup
# ###############################################################################

# # Brew Update, Cleanup and Repairs
# # Warning: Calling 'brew prune' is deprecated! Use 'brew cleanup' instead.
brew up &> /dev/null
brew doctor &> /dev/null
brew cleanup &> /dev/null

# # # General Cleanup and Update
# find . -type f -name '*.DS_Store' -ls -delete &> /dev/null
# sudo rm -rfv /Volumes/*/.Trashes &> /dev/null
# sudo rm -rfv ~/.Trash &> /dev/null
# sudo rm -rfv /private/var/log/asl/*.asl &> /dev/null
# sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent' &> /dev/null
