#!/usr/bin/zsh

function smart() {
    # Show help
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _show_message "Usage: smart [disk]
- No args : scan and check all detected drives
- [disk]  : check a specific drive (e.g. /dev/sda, /dev/nvme0)" "info"
        return 0
    fi

    # Check dependency
    if ! command -v smartctl &>/dev/null; then
        _show_message "smartctl not found." "error" "Install it with: sudo pacman -S smartmontools  OR  sudo apt install smartmontools"
        return 1
    fi

    # Collect target drives
    local -a drives
    if [[ -n "$1" ]]; then
        drives=("$1")
    else
        # Auto-detect block devices (sda, sdb..., nvme0n1, nvme1n1...)
        drives=($(lsblk -dno NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}'))
        if [[ ${#drives[@]} -eq 0 ]]; then
            _show_message "No drives detected." "error"
            return 1
        fi
    fi

    echo -e "\n${colors[purple]}╔══════════════════════════════════════════════════════╗"
    echo -e "║        ${colors[white]}S.M.A.R.T  Drive Health Report${colors[purple]}               ║"
    echo -e "╚══════════════════════════════════════════════════════╝${colors[reset]}"

    local overall_ok=true

    for drive in "${drives[@]}"; do
        echo -e "\n${colors[cyan]}┌─────────────────────────────────────────────────────"
        echo -e "│ ${colors[yellow]}Drive: ${colors[white]}$drive${colors[reset]}"

        # Check if SMART is supported
        local info
        info=$(sudo smartctl -i "$drive" 2>&1)
        if echo "$info" | grep -qi "unable to open\|permission denied\|no such"; then
            echo -e "${colors[cyan]}│ ${colors[red]}[!] ${colors[yellow]}Cannot access $drive${colors[reset]}"
            echo -e "${colors[cyan]}└─────────────────────────────────────────────────────${colors[reset]}"
            overall_ok=false
            continue
        fi

        # Model / transport type
        local model transport capacity
        model=$(echo "$info"     | grep -i "Device Model\|Model Number\|Product:"  | head -1 | awk -F: '{gsub(/^ /,"",$2); print $2}' | xargs)
        transport=$(echo "$info" | grep -i "Transport protocol\|SATA Version\|NVMe" | head -1 | awk -F: '{print $1}' | xargs)
        capacity=$(echo "$info"  | grep -i "User Capacity\|Total NVM Capacity"      | head -1 | awk -F: '{gsub(/^ /,"",$2); print $2}' | xargs)

        [[ -n "$model"    ]] && echo -e "${colors[cyan]}│ ${colors[gray]}Model    : ${colors[white]}$model${colors[reset]}"
        [[ -n "$capacity" ]] && echo -e "${colors[cyan]}│ ${colors[gray]}Capacity : ${colors[white]}$capacity${colors[reset]}"

        # Overall health
        local health
        health=$(sudo smartctl -H "$drive" 2>&1 | grep -i "overall\|result\|status" | tail -1)
        if echo "$health" | grep -qi "PASSED\|OK"; then
            echo -e "${colors[cyan]}│ ${colors[gray]}Health   : ${colors[green]}✔  PASSED${colors[reset]}"
        else
            echo -e "${colors[cyan]}│ ${colors[gray]}Health   : ${colors[red]}✘  FAILED / UNKNOWN${colors[reset]}"
            overall_ok=false
        fi

        # Temperature
        local temp
        temp=$(sudo smartctl -A "$drive" 2>&1 | grep -i "temperature\|Airflow_Temp" | grep -v "^$" | head -1 | awk '{print $(NF)}')
        if [[ -n "$temp" && "$temp" =~ ^[0-9]+$ ]]; then
            if   (( temp <= 40 )); then
                echo -e "${colors[cyan]}│ ${colors[gray]}Temp     : ${colors[green]}${temp}°C  ●  Cool${colors[reset]}"
            elif (( temp <= 55 )); then
                echo -e "${colors[cyan]}│ ${colors[gray]}Temp     : ${colors[yellow]}${temp}°C  ●  Warm${colors[reset]}"
            else
                echo -e "${colors[cyan]}│ ${colors[gray]}Temp     : ${colors[red]}${temp}°C  ●  HOT!${colors[reset]}"
                overall_ok=false
            fi
        fi

        # Reallocated sectors & pending sectors
        local realloc pending
        realloc=$(sudo smartctl -A "$drive" 2>&1 | awk '/Reallocated_Sector_Ct/{print $10}')
        pending=$(sudo smartctl -A "$drive" 2>&1 | awk '/Current_Pending_Sector/{print $10}')

        if [[ -n "$realloc" ]]; then
            if (( realloc == 0 )); then
                echo -e "${colors[cyan]}│ ${colors[gray]}Realloc  : ${colors[green]}$realloc  ✔${colors[reset]}"
            else
                echo -e "${colors[cyan]}│ ${colors[gray]}Realloc  : ${colors[red]}$realloc  ✘  Bad sectors detected!${colors[reset]}"
                overall_ok=false
            fi
        fi

        if [[ -n "$pending" ]]; then
            if (( pending == 0 )); then
                echo -e "${colors[cyan]}│ ${colors[gray]}Pending  : ${colors[green]}$pending  ✔${colors[reset]}"
            else
                echo -e "${colors[cyan]}│ ${colors[gray]}Pending  : ${colors[red]}$pending  ✘  Sectors pending reallocation!${colors[reset]}"
                overall_ok=false
            fi
        fi

        # Power-on hours
        local poh
        poh=$(sudo smartctl -A "$drive" 2>&1 | awk '/Power_On_Hours/{print $10}')
        [[ -n "$poh" ]] && echo -e "${colors[cyan]}│ ${colors[gray]}Power-on : ${colors[white]}${poh} hours${colors[reset]}"

        # NVMe specific: media errors & critical warnings
        local nvme_err nvme_warn
        nvme_err=$(sudo smartctl -A "$drive" 2>&1 | grep -i "Media and Data Integrity Errors" | awk '{print $NF}')
        nvme_warn=$(sudo smartctl -A "$drive" 2>&1 | grep -i "Critical Warning" | awk '{print $NF}')

        if [[ -n "$nvme_err" ]]; then
            if (( nvme_err == 0 )); then
                echo -e "${colors[cyan]}│ ${colors[gray]}NVMe Err : ${colors[green]}$nvme_err  ✔${colors[reset]}"
            else
                echo -e "${colors[cyan]}│ ${colors[gray]}NVMe Err : ${colors[red]}$nvme_err  ✘${colors[reset]}"
                overall_ok=false
            fi
        fi
        if [[ -n "$nvme_warn" && "$nvme_warn" != "0x00" && "$nvme_warn" != "0" ]]; then
            echo -e "${colors[cyan]}│ ${colors[gray]}NVMe Warn: ${colors[red]}$nvme_warn  ✘${colors[reset]}"
            overall_ok=false
        fi

        echo -e "${colors[cyan]}└─────────────────────────────────────────────────────${colors[reset]}"
    done

    echo ""
    if $overall_ok; then
        _show_message "All drives are healthy." "plus"
    else
        _show_message "One or more drives need attention!" "error"
    fi
}
