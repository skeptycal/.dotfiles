#!/usr/bin/env bash
# -*- coding: utf-8 -*-
###############################################################################
# booker - change text files to audio files on macOS Catalina
#   usage: booker [-t] [-i]
#   options
#       -t | --test | test    -   test mode (uses test directories only)
#       -i | --init | init    -   initialize and setup current folder
#
# version 0.4.0
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################

# read pdf's
#   say -f mynovel.txt -o myaudiobook.aiff
#   read each pdf in the specified folder
#   create a voice file
#   move voice files to new folder
#   move completed pdf's out to 'done' folder

# TODO
#   add to iTunes playlist
###############################################################################

source "$(which ssm)" # standard script modules

pdf_debug='0'
param1="$1"
param1='-t' # debug only

[[ -z "$PDF_MAIN_FOLDER" ]] && PDF_MAIN_FOLDER="${HOME}/Documents/reference/booker"
[[ "$pdf_debug" == '1' ]] && PDF_MAIN_FOLDER="$PDF_MAIN_FOLDER/pdf_test"
pdf_setup_folders

function pdf_setup_folders() {
    PDF_TODO="$PDF_MAIN_FOLDER/pdf_todo"
    PDF_DONE="$PDF_MAIN_FOLDER/pdf_done"
    PDF_AUDIO="$PDF_MAIN_FOLDER/pdf_audio"
    LOGFILE="$PDF_MAIN_FOLDER/booker.log"
    if ! [ -d "$PDF_MAIN_FOLDER/pdf_todo" ]; then
        mkdir "$PDF_AUDIO" || exit_usage "directory error creating $PDF_AUDIO" $pdf_usage
        mkdir "$PDF_DONE" || exit_usage "directory error creating $PDF_DONE" $pdf_usage
        mkdir "$PDF_TODO" || exit_usage "directory error creating $PDF_TODO" $pdf_usage
        touch "$LOGFILE"
    fi
}

function get_options() {

    while (("$#")); do
        case $1 in
        -t | --test | test)
            pdf_debug='1'
            warn "Running in Test Mode."
            warn "  The only files that will be altered are in the test directory."
            ;;
        -i | --init | init)
            PDF_MAIN_FOLDER="$PWD"
            pdf_setup_folders
            ;;
        *)
            PDF_MAIN_FOLDER="$1"

            ;;

        esac
        shift
    done
}

function output_file_details() {
    attn "==== debug info ===="
    green "file: $filename"
    green "dir: $dir"
    green "base: $base_name"
    green "ext: $extension"
    green "name_only: $name_only"
    green "done name: $done_name"
    green "audio_name: $audio_name"
    green "audio_full: $audio_full"
    green "current command:  say -f $filename -o $audio_full"
}

function booker_main() {
    get_options
    me "Booker - converting text files to audio format."
    me "==============================================="
    blue "$(date)"
    # cycle through all files in source directory $PDF_TODO
    for filename in $PDF_TODO/*; do
        if [ -s "$filename" ]; then
            # get filename parts
            parse_filename
            # get new filename for audio output file in $PDF_AUDIO
            get_safe_new_filename "$name_only" "$PDF_AUDIO" 'aiff'
            audio_name="$new_safe_name_only"
            audio_full="$new_safe_name"
            # get new filename for destination folder $PDF_DONE
            get_safe_new_filename "$name_only" "$PDF_DONE" "$extension"
            done_name_only="$new_safe_name_only"
            done_name="$new_safe_name"
            # log file details in test mode
            [[ "$pdf_debug" == '1' ]] && output_file_details
            # convert file to audio
            say -f "$filename" -o "$audio_full"
            if [ $? -eq 0 ]; then
                canary "success: $base_name -> $audio_name"
                [[ "$pdf_debug" == '0' ]] && mv "$filename" "$done_name"
            else
                cherry "->!!! Error processing $base_name."
                rm -rf "$audio_full"
            fi
        else
            attn "Completed processing files in $PDF_TODO"
        fi
    done
}

booker_main
