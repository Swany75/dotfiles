#!/bin/zsh

function remember() {
    local timestamp=$(date '+%d/%m/%Y %H:%M:%S')
    local message="$*"
    echo "$timestamp|$message" >> ~/.notes
    _show_message "Note saved:" plus "$message"
}

function notes() {
    if [[ ! -s ~/.notes ]]; then
        _show_message "You have no notes yet!" info
        return
    else
        echo -e "\n\n${colors[purple]}─── Notes ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────${colors[reset]}\n"
        grep '|' ~/.notes | while IFS='|' read -r datetime note; do
            local date_part="${datetime%% *}"    # date DD/MM/YYYY
            local time_part="${datetime#* }"     # time HH:MM:SS

            echo -e "${colors[yellow]}$date_part${colors[reset]} - ${colors[green]}$time_part${colors[reset]} | ${colors[cyan]} $note${colors[reset]}"
        done
        echo
    fi
}

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
