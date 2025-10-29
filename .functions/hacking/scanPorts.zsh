#!/usr/bin/zsh

function scanPorts() {
    local host="${1:-127.0.0.1}"
    local start_port="${2:-1}"
    local end_port="${3:-1024}"

    _show_message "Starting port scan on $host ports $start_port-$end_port..." "info"
    tput civis

    trap _ctrl_c INT

    for port in $(seq $start_port $end_port); do
        (echo > /dev/tcp/"$host"/"$port") 2>/dev/null && echo "[+] $port - OPEN" &
    done

    wait
    tput cnorm
    _show_message "Port scan finished." "info"
}
