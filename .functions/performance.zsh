#!/usr/bin/zsh

# Ascii Art template
# ╔═╦═╗
# ║ ║ ║
# ╠═╬═╣
# ╚═╩═╝

### Battery Status ##########################################################

function batteryStatus() {
    local bat_device info percent bat_state color battery_lines i fill_level symbol

    # Get battery device
    bat_device=$(upower -e | grep -m1 'BAT')
    if [[ -z "$bat_device" ]]; then
        _show_message "Battery info not found!" "error"
        return 1
    fi

    # Get battery info
    info=$(upower -i "$bat_device")
    percent=$(echo "$info" | awk '/percentage/ {gsub(/%/,"",$2); print int($2)}')
    bat_state=$(echo "$info" | awk -F': ' '/state/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}')

    if [[ -z "$percent" ]]; then
        _show_message "Could not read battery data!" "error"
        return 1
    fi

    # Set color based on percentage
    if (( percent >= 75 )); then
        color=${colors[green]}
    elif (( percent >= 40 )); then
        color=${colors[yellow]}
    else
        color=${colors[red]}
    fi

    # Thresholds for fill level (1–5 bars)
    if   (( percent >= 80 )); then fill_level=5
    elif (( percent >= 60 )); then fill_level=4
    elif (( percent >= 40 )); then fill_level=3
    elif (( percent >= 20 )); then fill_level=2
    else fill_level=1
    fi

    # Choose battery symbol (synced with thresholds)
    if (( percent >= 80 )); then
        symbol="🔋"
    elif (( percent >= 60 )); then
        symbol="🔋"
    elif (( percent >= 40 )); then
        symbol="🔋"
    elif (( percent >= 20 )); then
        symbol="🪫"
    else
        symbol="🪫"
    fi

    # Battery ASCII art (8 lines)
    battery_lines=(
        "  ╔══╗   "  # 1 top connector
        "╔═╩══╩═╗ "  # 2 cap
        "║      ║ "  # 3 fillable
        "║      ║ "  # 4 fillable
        "║      ║ "  # 5 fillable
        "║      ║ "  # 6 fillable
        "║      ║ "  # 7 fillable
        "╚══════╝ "  # 8 bottom
    )

    # Fill from bottom up (rows 7 → 3)
    for ((i = 0; i < fill_level; i++)); do
        battery_lines[$((7 - i))]="║██████║ "
    done

    # Print battery
    echo -e "\n${color}"
    for line in "${battery_lines[@]}"; do
        echo "$line"
    done

    # Battery info below
    echo -e "\n${symbol} ${percent}%"
    if [[ "${bat_state:l}" == "charging" ]]; then
        echo -e "⚡ Charging"
    elif [[ "${bat_state:l}" == "discharging" ]]; then
        echo -e "🔽 Discharging"
    elif [[ "${bat_state:l}" == "full" ]]; then
        echo -e "✅ Full"
    fi
    echo -e "${colors[reset]}"
}

### CPU Status #############################################################

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
        " ║           ║"
        "═╣           ╠═"
        " ║           ║"
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

### Memory Status #########################################################

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


### GPU Status #############################################################

function gpuStatus() {
    local gpu_ascii color symbol gpu_info gpu_count temp usage
    
    # GPU ASCII art
    gpu_ascii=(
        "═╗"
        " ╠═══════════════╗"
        " ║ ╔═════╗ ╔═╦═╗ ║"
        " ║ ║ GPU ║ ╠═╬═╣ ║"
        " ║ ╚═════╝ ╚═╩═╝ ║"
        " ╠══╦╦╦╦╦╦╦╦╦╦╦╦═╝"
        " ║"
    )
    
    # Detect GPUs
    local -a gpu_list
    gpu_list=()
    
    # Try to get all GPUs from lspci
    while IFS= read -r line; do
        gpu_list+=("$line")
    done < <(lspci | grep -iE 'VGA|3D|Display')
    
    gpu_count=${#gpu_list[@]}
    
    if [[ $gpu_count -eq 0 ]]; then
        _show_message "No GPU detected!" "error"
        return 1
    fi
    
    # Determine color based on GPU status
    # Try to get NVIDIA GPU info if available
    if command -v nvidia-smi &>/dev/null; then
        temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n 1)
        usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n 1)
        
        if [[ -n "$temp" && -n "$usage" ]]; then
            if   (( temp < 60 && usage < 40 )); then
                color=${colors[green]}
                symbol="❄️"
            elif (( temp < 80 && usage < 80 )); then
                color=${colors[yellow]}
                symbol="🔥"
            else
                color=${colors[red]}
                symbol="🌋"
            fi
        else
            color=${colors[blue]}
            symbol="🎮"
        fi
    else
        color=${colors[blue]}
        symbol="🎮"
    fi
    
    # Print ASCII art
    echo -e "\n${color}"
    for line in "${gpu_ascii[@]}"; do
        echo "$line"
    done
    
    # Print GPU count
    _show_message "Detected GPUs:" "info" "${gpu_count}"
    
    # List all GPUs
    local idx=1
    for gpu in "${gpu_list[@]}"; do
        # Extract GPU name (remove bus ID and "VGA compatible controller:" prefix)
        local gpu_name=$(echo "$gpu" | sed -E 's/^[0-9a-f:.]+\s+(VGA compatible controller|3D controller|Display controller):\s*//')
        _show_message "GPU ${idx}:" "plus" "${gpu_name}"
        
        # If NVIDIA GPU, show additional stats for the first one
        if [[ $idx -eq 1 ]] && command -v nvidia-smi &>/dev/null && echo "$gpu" | grep -iq "nvidia"; then
            local mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | head -n 1)
            local mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -n 1)
            
            if [[ -n "$temp" ]]; then
                _show_message "Temperature:" "minus" "${temp}°C"
            fi
            if [[ -n "$usage" ]]; then
                _show_message "Utilization:" "minus" "${usage}%"
            fi
            if [[ -n "$mem_used" && -n "$mem_total" ]]; then
                _show_message "Memory:" "minus" "${mem_used}MB / ${mem_total}MB"
            fi
        fi
        
        ((idx++))
    done
}

### Combined Status ########################################################

function status() {
    local show_cpu=false
    local show_ram=false
    local show_battery=false
    local show_gpu=false
    local show_all=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --cpu)
                show_cpu=true
                show_all=false
                ;;
            --ram)
                show_ram=true
                show_all=false
                ;;
            --battery)
                show_battery=true
                show_all=false
                ;;
            --gpu)
                show_gpu=true
                show_all=false
                ;;
            *)
                echo "Usage: status [--cpu] [--ram] [--battery] [--gpu]"
                echo "  No flags: Show all status information"
                echo "  --cpu:     Show CPU status only"
                echo "  --ram:     Show RAM status only"
                echo "  --battery: Show battery status only"
                echo "  --gpu:     Show GPU status only"
                return 1
                ;;
        esac
        shift
    done
    
    # Show all if no specific flags
    if [[ "$show_all" == true ]]; then
        show_cpu=true
        show_ram=true
        show_battery=true
        show_gpu=true
    fi
    
    # Display requested status information
    if [[ "$show_cpu" == true ]]; then
        cpuStatus
    fi
    
    if [[ "$show_ram" == true ]]; then
        ramStatus
    fi
    
    if [[ "$show_battery" == true ]]; then
        batteryStatus
    fi
    
    if [[ "$show_gpu" == true ]]; then
        gpuStatus
    fi
}
