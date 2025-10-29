#!/usr/bin/zsh

function ramStatus() {
    local total_kb used_b percent color symbol used_gb total_gb ram_lines i chips filled_chips

    total_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    total_gb=$(awk "BEGIN {printf \"%.2f\", $total_kb/1024/1024}")

    read _ used_b <<< $(free -b | awk '/Mem:/ {print $2, $3}')
    used_gb=$(awk "BEGIN {printf \"%.2f\", $used_b/1024/1024/1024}")

    percent=$(awk "BEGIN {printf \"%d\", ($used_b/($total_kb*1024))*100}")

    if   (( percent < 40 )); then
        color=${colors[green]}
        symbol="📗"
    elif (( percent < 75 )); then
        color=${colors[yellow]}
        symbol="📙"
    else
        color=${colors[red]}
        symbol="📕"
    fi

    ram_lines=(
      "╔════════════════════════╗"
      "║ ╔══╗ ╔══╗    ╔══╗ ╔══╗ ║"
      "║ ╚══╝ ╚══╝    ╚══╝ ╚══╝ ║"
      "║ ╔══╗ ╔══╗    ╔══╗ ╔══╗ ║"
      "║ ╚══╝ ╚══╝    ╚══╝ ╚══╝ ║"
      "╠╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦═╦╦╦╦╦╦╦╣"
    )

    echo -e "\n${color}"
    for line in "${ram_lines[@]}"; do
        echo "$line"
    done

    echo -e "\n${symbol} RAM Usage: ${used_gb} of ${total_gb}GB | ${percent}%"
    echo -e "${colors[reset]}"
}
