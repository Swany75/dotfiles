#!/bin/zsh

trap _ctrl_c INT

# Help function compatible with Python yq (jq syntax)
function help() {
    local HELP_YAML="$HOME/.functions/_help.yaml"
    
    # Check dependencies
    if ! command -v yq &> /dev/null; then
        _show_message "yq is required but not installed." "error"
        _show_message "Install with:\nDebian: sudo apt install yq\nArch: pacman -S yq" "info"
        return 1
    fi
    
    if [[ ! -f "$HELP_YAML" ]]; then
        _show_message "Help file not found:" "error" "$HELP_YAML"
        _show_message "Make sure your _help.yaml file exists in the correct location." "info"
        return 1
    fi
    
    # Test YAML parsing with Python yq (jq syntax)
    local yq_test
    yq_test=$(yq 'keys' "$HELP_YAML" 2>&1)
    if [[ $? -ne 0 ]]; then
        _show_message "Invalid YAML format in" "error" "$HELP_YAML"
        _show_message "YQ Error:" "info" "$yq_test"
        return 1
    fi
    
    # Load modules with error handling (Python yq syntax)
    local my_modules
    my_modules=($(yq 'keys | .[]' "$HELP_YAML" 2>/dev/null | tr -d '\r' | tr -d '"'))
    
    if [[ ${#my_modules[@]} -eq 0 ]]; then
        _show_message "No modules found in help file" "error"
        return 1
    fi
    
    while true; do
        clear
        local header="$(_calcSpaces '    Welcome to the custom functions help panel' 52)"
        echo -e "${colors[purple]}┌────────────────────────────────────────────────────┐${colors[reset]}"
        echo -e "${colors[purple]}│${colors[cyan]}$header${colors[purple]}│${colors[reset]}"
        echo -e "${colors[purple]}└────────────────────────────────────────────────────┘${colors[reset]}"
        echo -e "${colors[green]}[?]${colors[reset]} ${colors[cyan]}Which module do you want to view?${colors[reset]}\n"
        
        # Print module list
        local i=1
        for module in "${my_modules[@]}"; do
            [[ -z "$module" ]] && continue  # Skip empty entries
            echo -e "${colors[yellow]} $(printf "%02d" $i))${colors[reset]} ${colors[blue]}$module${colors[reset]}"
            ((i++))
        done
        
        echo -ne "\n${colors[green]}➤${colors[reset]} ${colors[cyan]}Select module number (q to quit):${colors[reset]} "
        read choice
        
        [[ "$choice" =~ ^[Qq]$ ]] && return 0
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#my_modules[@]} )); then
            _show_module "${my_modules[$choice]}" "$HELP_YAML"
        else
            _show_message "Invalid selection." "error"
        fi
        
        _show_message "Press ENTER to return to the menu..." "plus"
        read
    done
}

# Show module function compatible with Python yq
function _show_module() {
    local module="$1"
    local HELP_YAML="$2"
    
    # Verify module exists (Python yq syntax)
    if ! yq "has(\"$module\")" "$HELP_YAML" 2>/dev/null | grep -q "true"; then
        _show_message "Module '$module' not found!" "error"
        return 1
    fi
    
    clear
    echo -e "${colors[yellow]}Module: ${colors[cyan]}$module${colors[reset]}\n"
    
    # Get functions with Python yq syntax
    local funcs_list
    funcs_list=$(yq ".\"$module\".functions // {} | keys | .[]" "$HELP_YAML" 2>/dev/null | tr -d '"')
    
    if [[ -n "$funcs_list" ]]; then
        while IFS= read -r func_name; do
            [[ -z "$func_name" ]] && continue
            local desc=$(yq ".\"$module\".functions.\"$func_name\".description" "$HELP_YAML" 2>/dev/null | tr -d '"')
            echo -e "  ${colors[green]}$func_name${colors[reset]} → $desc"
        done <<< "$funcs_list"
    else
        _show_message "No functions found for this module" "error"
    fi
    
    # Optional info message
    local info
    info=$(yq ".\"$module\".info // \"\"" "$HELP_YAML" 2>/dev/null | tr -d '"')
    [[ -n "$info" && "$info" != "null" ]] && _show_message "$info" "info"
}
