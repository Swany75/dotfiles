#!/usr/bin/zsh

function compress() {
    if [ -z "$1" ]; then
        _show_message "Usage: compress <file_or_folder> [-t type]" "error"
        return 1
    fi

    local target
    local type="zip"  # default type
    local cmd

    # parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t|--type)
                type="$2"
                shift 2
                ;;
            --type=*)
                type="${1#*=}"
                shift
                ;;
            -*)
                _show_message "Unknown option:" "error" $1
                return 1
                ;;
            *)
                target="$1"
                shift
                ;;
        esac
    done

    if [ -z "$target" ]; then
        _show_message "No target specified" "error"
        return 1
    fi

    local output="${target%/}.$type"

    # Determine command for type
    case "$type" in
        zip)   cmd="zip" ;;
        rar)   cmd="rar" ;;
        tar)   cmd="tar" ;;
        tar.gz|tgz) cmd="tar" ;;
        tar.bz2|tbz2) cmd="tar" ;;
        7z|7zip) cmd="7z" ;;
        gzip)  cmd="gzip" ;;
        *) 
            _show_message "Compression type '$type' not supported" "error"
            return 1
            ;;
    esac

    # Check if command exists
    if ! command -v "$cmd" >/dev/null 2>&1; then
        _show_message "'$cmd' command not found" "error"
        return 1
    fi

    # Compress based on type
    case "$type" in
        zip)
            zip -r "$output" "$target" ;;
        rar)
            rar a "$output" "$target" ;;
        tar)
            tar cf "$output" "$target" ;;
        tar.gz|tgz)
            tar czf "$output" "$target" ;;
        tar.bz2|tbz2)
            tar cjf "$output" "$target" ;;
        7z|7zip)
            7z a "$output" "$target" ;;
        gzip)
            if [ -d "$target" ]; then
                _show_message "gzip can only compress single files, not directories" "error"
                return 1
            fi
            gzip -c "$target" > "$output" ;;
    esac

    _show_message "Created $output" "plus"
}
