#!/usr/bin/zsh

function cput() {
    local file="$1"

    if [[ -z "$file" || ! -f "$file" ]]; then
        _show_message "File not found or not specified" "error"
        return 1
    fi

    # Detect clipboard command
    if command -v wl-copy &>/dev/null; then
        cat "$file" | wl-copy
        _show_message "File copied to clipboard" "plus"
    elif command -v xclip &>/dev/null; then
        cat "$file" | xclip -selection clipboard
        _show_message "File copied to clipboard" "plus"
    else
        _show_message "No clipboard command found (install wl-clipboard or xclip)" "error"
        return 1
    fi
}
