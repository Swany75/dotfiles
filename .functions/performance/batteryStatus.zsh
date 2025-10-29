#!/usr/bin/zsh

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
