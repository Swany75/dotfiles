#!/usr/bin/zsh

function scanNet() {
    local subnet="${1:-192.168.1}"
    _show_message "Starting network scan on $subnet.1-254..." "info"
    trap _ctrl_c INT

    for i in $(seq 1 254); do
        timeout 1 bash -c "ping -c 1 $subnet.$i &>/dev/null" && echo "[+] Host $subnet.$i - ACTIVE" &
    done

    wait
    _show_message "Network scan finished." "info"
}
