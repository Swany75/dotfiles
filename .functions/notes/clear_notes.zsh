#!/usr/bin/zsh

function clear_notes() {
    if [[ ! -f ~/.notes ]] || [[ ! -s ~/.notes ]]; then
        _show_message "There is no notes file to clear." error
        return
    fi

    echo -ne "\n${colors[yellow]}Are you sure you want to delete all notes? (y/N) ${colors[reset]}\n" && read -r answer

    case "$answer" in
        [yY])
            echo "" > ~/.notes
            _show_message "All notes have been deleted." minus
            ;;
        *)
            _show_message "Action cancelled." info
            ;;
    esac
}
