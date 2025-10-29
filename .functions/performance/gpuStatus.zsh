#!/usr/bin/zsh

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
