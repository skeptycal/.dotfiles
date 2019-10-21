#!/usr/bin/env bash
# Colors used for xterm decoration in scripts
# format: ["red"]=$'\e[0;31m'

export declare -A text_colors=(
    ["default"]=0
    ["black"]=30
    ["red"]=31
    ["green"]=32
    ["brown"]=33
    ["blue"]=34
    ["magenta"]=35
    ["cyan"]=36
    ["lgray"]=37
    ["b_black"]=40
    ["b_red"]=41
    ["b_green"]=42
    ["b_brown"]=43
    ["b_blue"]=44
    ["b_magenta"]=45
    ["b_cyan"]=46
    ["b_lgray"]=47
)

export declare -A formats=(
    ["bold"]=1
    ["under"]=4
    ["blink"]=5
    ["invert"]=7
)

# Just a global preference ...
export default_color="green"
# Initialize global string
ansi_string=""

# Encode choices to ansi color code string
#    $1 (int) foreground color
#    $2 (int) background color (optional)
#    $3 (int) formatting code (optional)

function encode_ansi_color() {
    ansi_string=""
    if [ -n "$1" ] && [ -n ${text_colors[$1]} ];
    then
		# set foreground color
		fg=${text_colors[$1]}
        if [ -n "$2" ] && [ -n ${text_colors[$2]} ];
        then
            # set background color
            bg=int(${text_colors[$2]}) + 10)
        else
            # use default color
            bg=""
        fi;
        # optional formatting
        case "$3" in
            "1457") 
                fc = "$3"
                ;;
            *)
                fc = ""
                ;;
        esac
	else
		# use default color
		fg=${text_colors["$default"]}
        bg=""
        fc=""
	fi;

    # printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
    # \e[0;30;47m
    ansi_string="\e[$fc;$fg;$bgm"
}


# Colorized echo
#    $1 is escaped text to print
#    $2 is optional foreground color name (from $text_colors)
#    $3 is optional background color name (from $text_colors)
#    $4 (int) is optional formatting (1) bold, (4) underline, (5) blink, (7) invert     
#       TODO italic (not implemented)
#    $5 (boolean) True: do not reset color (default is to reset)
#    $6 (boolean) True: do not add newline (default is to add \n)
#    format for hash table; echo ${MYMAP[foo]} --> bar
#
#    TODO : parse for MarkDown


function ec() {
	if [ -n "$1" ] 
	then
		encode_ansi_color($1, $2, $3)
        if [ -n "$4" ];
        then
            clear_code=""
        else
            clear_code="\e[0m"
        fi;
        if [ -n "$5" ];
        then
            nl_code=""
        else
            nl_code="\n"
        fi;

        # Use colors to echo text
        # printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
		echo -e "\e[0;$fg$bgm$clear_code$nl_code"
	else
        echo ""
	fi
	
#################################################################################
# * Terminals compatibility  https://misc.flogisoft.com/bash/tip_colors_and_formatting
#   
#   Terminal	    Formatting	                                        Colors	        Comment
#                   Bold   Dim	  Underlined Blink	invert	  Hidden	8  16  88  256
#   aTerm	        ok	    -	      ok	  -	      ok        -	    ok	~	-	-	Lighter background instead of blink.
#   Eterm	        ~	    -	      ok	  -	      ok        -	    ok	~	-	ok	Lighter color instead of Bold. Lighter background instead of blink. Can overline a text with the “^[[6m” sequence.
#   GNOME 	        ok	    ok    	  ok	  ok	  ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.
#   Guake	        ok	    ok    	  ok	  ok	  ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.
#   Konsole	        ok	    -	      ok	  ok      ok	    -	    ok	ok	-	ok	
#   Nautilus 	    ok	    ok    	  ok	  ok	  ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.
#   rxvt	        ok	    -	      ok	  ~	      ok        -	    ok	ok	ok	-	If the background is not set to the default color, Blink make it lighter instead of blinking. Support of italic text with the “^[[3m” sequence.
#   Terminator	    ok	    ok    	  ok	  -       ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.
#   Tilda	        ok	    -	      ok	  ok      ok	    -	    ok	ok	-	-	Underline instead of Dim. Convert 256-colors in 16-colors.
#   XFCE4 Terminal	ok	    ok    	  ok	  ok	  ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.
#   XTerm	        ok	    -	      ok	  ok      ok	    ok	    ok	ok	-	ok	
#   xvt	            ok	    -	      ok	  -	      ok        -	    -	-	-	-	
#   Linux  TTY	    ok	    -	      -	      - 	  ok	    -	    ok	~	-	-	Specials colors instead of Dim and Underlined. Lighter background instead of Blink, Bug with 88/256 colors.
#   VTE Terminal 3)	ok	    ok    	  ok	  ok	  ok	    ok	    ok	ok	-	ok	Strikeout with the “^[[9m” sequence.


#################################################################################
# from: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
 
function show_bash_colors() {
	if [[ $TERM == xterm* ]]
	then
        for fgbg in 38 48 ; do # Foreground / Background
            for color in {0..255} ; do # Colors
                # Display the color
                printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
                # Display 6 colors per lines
                if [ $((($color + 1) % 6)) == 4 ] ; then
                    echo # New line
                fi
            done
            echo # New line
        done
	fi
    echo -e "\n\033[4;31mLight Colors\033[0m \t\t\t  \033[1;4;31mDark Colors\033[0m"
    echo -e " \e[0;30;47m Black     \e[0m   0;30m \t\t \e[1;30;40m Dark Gray   \e[0m  1;30m"
    echo -e " \e[0;31;47m Red       \e[0m   0;31m \t\t \e[1;31;40m Dark Red    \e[0m  1;31m"
    echo -e " \e[0;32;47m Green     \e[0m   0;32m \t\t \e[1;32;40m Dark Green  \e[0m  1;32m"
    echo -e " \e[0;33;47m Brown     \e[0m   0;33m \t\t \e[1;33;40m Yellow      \e[0m  1;33m"
    echo -e " \e[0;34;47m Blue      \e[0m   0;34m \t\t \e[1;34;40m Dark Blue   \e[0m  1;34m"
    echo -e " \e[0;35;47m Magenta   \e[0m   0;35m \t\t \e[1;35;40m Dark Magenta\e[0m  1;35m"
    echo -e " \e[0;36;47m Cyan      \e[0m   0;36m \t\t \e[1;36;40m Dark Cyan   \e[0m  1;36m"
    echo -e " \e[0;37;47m Light Gray\e[0m   0;37m \t\t \e[1;37;40m White       \e[0m  1;37m"

    for color in $text_colors;
    do
        echo -e "${text_colors[color]}test"
    done
}

# ! test
show_bash_colors


    # ["dgray"]=$'30'
    # ["dred"]=$'31'
    # ["dgreen"]=$'32'
    # ["yellow"]=$'33'
    # ["dblue"]=$'34'
    # ["dmagenta"]=$'35'
    # ["dcyan"]=$'36'
    # ["white"]=$'37'

    # ["b_dgray"]=$'40'
    # ["b_dred"]=$'41'
    # ["b_dgreen"]=$'42'
    # ["b_yellow"]=$'43'
    # ["b_dblue"]=$'44'
    # ["b_dmagenta"]=$'45'
    # ["b_dcyan"]=$'46'
    # ["b_white"]=$'47'