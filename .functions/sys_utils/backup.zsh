#!/usr/bin/zsh

function backup() {
    # Show help
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _show_message "Usage: backup <file_or_directory>
- For files: copies .bak in same dir and timestamped copy in ~/.backup
- For directories: copies .bak in same dir and compressed .zip in ~/.backup" "info"
        return 0
    fi

    # Check argument
    if [[ -z "$1" ]]; then
        _show_message "No file or directory specified" "error"
        return 1
    fi

    local target="$1"
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    local backup_dir="$HOME/.backup"

    # Create backup dir if not exists
    [[ ! -d "$backup_dir" ]] && mkdir -p "$backup_dir"

    if [[ -f "$target" ]]; then
        # File backup
        local base=$(basename "$target")
        local dir=$(dirname "$target")
        local bak_name="${base}_${timestamp}.bak"

        cp "$target" "$dir/$bak_name"
        cp "$target" "$backup_dir/$bak_name"

    elif [[ -d "$target" ]]; then
        # Directory backup
        local base=$(basename "$target")
        local dir=$(dirname "$target")
        local bak_name="${base}_${timestamp}.bak"
        local zip_name="${base}_${timestamp}.zip"

        cp -r "$target" "$dir/$bak_name"
        zip -r "$backup_dir/$zip_name" "$target" > /dev/null

    else
        _show_message "Target '$target' does not exist!" "error"
        return 1
    fi

    _show_message "Backup Completed" "plus"
}
