# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=2230,2086

# *############################################## directories
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'
alias cdc="cd $HOME/Documents/coding"
alias cdw="cd $HOME/Documents/work"
alias cdd="cd $HOME/Sites"
alias cdb="cd $HOME/Dropbox"
alias dl="cd $HOME/Downloads"
alias dt="cd $HOME/Desktop"
alias ftree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias filetree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

# alias lsln='ls -AF | grep '@' | cut -d '@' -f 1 ' # will include directories
# find . -maxdepth 1 -type l # will include directories
alias ll="ls -A | perl -nle 'print if -l and not -d;'"
alias lsd='ls -1Ad */'

# *############################################## search, filter, list
alias ducks='du -ck * | sort -rn | head -11'
alias toomuch='du -sh ~'
alias howmuch='du -sh '
alias treetotal='tree | tail -1' # needs 'brew install tree'
# alias fd="find \$PWD -type d -name "
# alias ff="find \$PWD -type f -name "

ff() { find "$PWD" -type f -name "$1"; }

fd() { find "$PWD" -type d -name "$1"; }

# *############################################## utilities
alias hs="history | grep "
alias map="xargs -n1"
alias sudo="sudo "
alias trim="sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g'"
alias now='date +"%T"'
alias nowdate='date +"%m-%d-%Y"'
alias week="date +%V"
alias mount="mount | column -t"
# alias allopen="sudo lsof -i -P | grep" # used function instead ...
alias egrep="egrep ${colorflag}"
alias fgrep="fgrep ${colorflag}"
alias plistbuddy="/usr/libexec/PlistBuddy"
command -v grunt >/dev/null && alias grunt="grunt --stack"
command -v hd >/dev/null || alias hd="hexdump -C"
command -v md5sum >/dev/null || alias md5sum="md5"
command -v sha1sum >/dev/null || alias sha1sum="shasum"

# *############################################## # maintenance
# alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; sudo npm install npm -g; sudo npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup"
# alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
# alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
# alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"
# alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# *###########################################################################
# listings
# echo "\$colorflag= $colorflag"
# colorflag=' -G'
alias ls="ls --group-directories-first ${colorflag}"           # normal wide
alias lsd="ls -dh ${colorflag} -- */"                          # dirs only
alias l.="ls -lhFAd .* --group-directories-first ${colorflag}" # dotfiles
alias la="ls -lhFA --group-directories-first ${colorflag}"     # all files
alias ll="ls -lhF --group-directories-first ${colorflag}"      # normal list
alias lsa="ls -lhFArt ${colorflag}"                            # sort by date
alias lss="ls -lhFArs ${colorflag}"                            # sort by size
alias lw="ls -hF --group-directories-first ${colorflag}"       # detailed wide

# *###########################################################################
# change directories
# alias -- -="cd -"
# alias -- -='cd -'
# alias .....="cd ../../../.."
# alias ....="cd ../../.."
# alias ...="cd ../.."
# alias ..="cd .."
# alias 1='cd -'
# alias 2='cd -2'
# alias 3='cd -3'
# alias 4='cd -4'
# alias 5='cd -5'
# alias 6='cd -6'
# alias 7='cd -7'
# alias 8='cd -8'
# alias 9='cd -9'
