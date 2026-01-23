#!/usr/bin/zsh

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
