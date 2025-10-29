#!/usr/bin/zsh

function remember() {
    local timestamp=$(date '+%d/%m/%Y %H:%M:%S')
    local message="$*"
    echo "$timestamp|$message" >> ~/.notes
    _show_message "Note saved:" plus "$message"
}
