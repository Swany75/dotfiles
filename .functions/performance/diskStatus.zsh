#!/usr/bin/zsh

function diskStatus() {
    local disk_lines color disk_info device size used avail percent mount
    
    # Disk ASCII art placeholder - add your custom art here
    disk_lines=(
      "\n"
      "${colors[green]}╔╩╩╩╩╩╩═╩╩╗"
        "║ ╔═╗ ╔═╗ ║"
        "║ ║ ║ ╚═╝ ║"
        "║ ╚═╝ M.2 ║"
        "║ ╔═════╗ ║"
        "║ ╚═════╝ ║"
        "║ ╔═════╗ ║"
        "║ ╚═════╝ ║"
        "╚═════════╝${colors[reset]}"
    )
    
   
    # Print ASCII art if it exists
    if [[ -n "${disk_lines[1]}" ]]; then
        for line in "${disk_lines[@]}"; do
            echo "$line"
        done
     
        echo ""

        # Get disk information
        echo -e "\n${colors[cyan]}Disk Usage:${colors[reset]}\n"

    fi
    
    # Parse df output and display each disk
    while IFS= read -r line; do
        # Skip header
        if [[ "$line" =~ ^Filesystem ]]; then
            continue
        fi
        
        # Parse disk information
        device=$(echo "$line" | awk '{print $1}')
        size=$(echo "$line" | awk '{print $2}')
        used=$(echo "$line" | awk '{print $3}')
        avail=$(echo "$line" | awk '{print $4}')
        percent=$(echo "$line" | awk '{print $5}' | tr -d '%')
        mount=$(echo "$line" | awk '{print $6}')
        
        # Skip if percent is empty or not a number
        if [[ -z "$percent" ]] || ! [[ "$percent" =~ ^[0-9]+$ ]]; then
            continue
        fi
        
        # Determine color based on usage percentage
        if (( percent >= 0 && percent <= 25 )); then
            color=${colors[green]}
            symbol="🟢"
        elif (( percent >= 26 && percent <= 50 )); then
            color=${colors[yellow]}
            symbol="🟡"
        elif (( percent >= 51 && percent <= 75 )); then
            color=${colors[orange]}
            symbol="🟠"
        elif (( percent >= 76 && percent <= 100 )); then
            color=${colors[red]}
            symbol="🔴"
        fi
        
        # Convert sizes to human readable (df -h gives human readable)
        # Display disk information
        echo -e "${color}${symbol} ${device}${colors[reset]}"
        echo -e "  Mount: ${colors[cyan]}${mount}${colors[reset]}"
        echo -e "  Used: ${color}${percent}%${colors[reset]} (${used} / ${size})"
        echo -e "  Available: ${colors[white]}${avail}${colors[reset]}\n"
        
    done < <(df -h --output=source,size,used,avail,pcent,target --exclude-type=tmpfs --exclude-type=devtmpfs --exclude-type=squashfs --exclude-type=fuse --exclude-type=fuse.portal --exclude-type=fuse.gvfsd-fuse --exclude-type=cifs --exclude-type=nfs --exclude-type=nfs4 --exclude-type=efivarfs 2>/dev/null | grep -vE '^(tmpfs|devtmpfs|loop|udev|overlay|none|shm|run|efivarfs)' | grep -vE '\.appimage|\.AppImage|/Drive/' | awk '$6 == "/" || $6 == "/home"')
    
    echo -e "${colors[reset]}"
}
