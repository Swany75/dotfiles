#!/usr/bin/zsh

function cput() {
    local file="$1"

    if [[ -z "$file" || ! -f "$file" ]]; then
        _show_message "File not found or not specified" "error"
        return 1
    fi

    # Prioritza wl-copy només si Wayland està actiu
    if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &>/dev/null; then
        cat "$file" | wl-copy
        _show_message "File copied to clipboard (Wayland)" "plus"
        return 0
    fi

    # Si X11 està disponible, utilitza xclip
    if command -v xclip &>/dev/null; then
        cat "$file" | xclip -selection clipboard
        _show_message "File copied to clipboard (X11)" "plus"
        return 0
    fi

    # Fallback a wl-copy encara que WAYLAND_DISPLAY no estigui definit
    if command -v wl-copy &>/dev/null; then
        cat "$file" | wl-copy
        _show_message "File copied to clipboard (Wayland fallback)" "plus"
        return 0
    fi

    _show_message "No clipboard command found (install wl-clipboard or xclip)" "error"
    return 1
}

