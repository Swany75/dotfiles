#!/usr/bin/zsh

function cpuStatus() {
    local usage temp color cpu_lines symbol

    usage=$(top -bn1 | awk '/^%Cpu/ {print 100 - $8}')   # total usage
    usage=${usage%.*}

    temp=$(sensors 2>/dev/null | awk '/^Package id 0:/ {gsub(/\+|\..*/,"",$4); print $4}' | head -n 1)
    if [[ -z "$temp" ]]; then
        # fallback (some distros expose temp via /sys)
        if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
            temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
        else
            temp="N/A"
        fi
    fi

    if [[ "$temp" != "N/A" ]]; then
        if   (( temp < 50 && usage < 40 )); then
            color=${colors[green]}
            symbol="🧊"
        elif (( temp < 70 && usage < 80 )); then
            color=${colors[yellow]}
            symbol="🔥"
        else
            color=${colors[red]}
            symbol="💀"
        fi
    else
        # fallback if temp is unavailable → use usage only
        if   (( usage < 40 )); then
            color=${colors[green]}
            symbol="🧊"
        elif (( usage < 80 )); then
            color=${colors[yellow]}
            symbol="🔥"
        else
            color=${colors[red]}
            symbol="💀"
        fi
    fi

    cpu_lines=(
        " ╔═╩═╩═╩═╩═╩═╗"
        "═╣           ╠═"
        "═╣           ╠═"
        "═╣           ╠═"
        "═╣           ╠═"
        "═╣           ╠═"
        " ╚═╦═╦═╦═╦═╦═╝"
    )

    echo -e "\n${color}"
    for line in "${cpu_lines[@]}"; do
        echo "$line"
    done

    echo -e "\n${symbol} CPU Usage: ${usage}%"
    echo -e "🌡️Temperature: ${temp}°C"
    echo -e "${colors[reset]}"
}
