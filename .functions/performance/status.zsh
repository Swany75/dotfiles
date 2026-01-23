#!/usr/bin/zsh

function status() {
    local show_cpu=false
    local show_ram=false
    local show_battery=false
    local show_gpu=false
    local show_disk=false
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
            --disk)
                show_disk=true
                show_all=false
                ;;
            *)
                echo "Usage: status [--cpu] [--ram] [--battery] [--gpu] [--disk]"
                echo "  No flags: Show all status information"
                echo "  --cpu:     Show CPU status only"
                echo "  --ram:     Show RAM status only"
                echo "  --battery: Show battery status only"
                echo "  --gpu:     Show GPU status only"
                echo "  --disk:    Show disk status only"
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
        show_disk=true
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
    
    if [[ "$show_disk" == true ]]; then
        diskStatus
    fi
}
