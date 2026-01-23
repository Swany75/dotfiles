#!/usr/bin/zsh

function ifaces() {
    local c="${colors[@]}"  # només per posar aquí, no cal fer servir

    show_help() {
        echo -e "\n${colors[cyan]}ifaces help menu${colors[reset]}"
        echo -e "  ${colors[green]}-i${colors[reset]}   →  Show all interfaces"
        echo -e "  ${colors[green]}-I${colors[reset]}   →  Show active interfaces with IP"
        echo -e "  ${colors[green]}-M${colors[reset]}   →  Show MAC addresses of interfaces"
        echo -e "  ${colors[green]}-A${colors[reset]}   →  Show interfaces with IP and MAC"
        echo -e "  ${colors[green]}-p${colors[reset]}   →  Ask and show public IP address\n"
    }

    case "$1" in
        -I)
            echo
            ip -o -4 addr show | while read -r _ iface _ addr _; do
                ip_addr=${addr%%/*}
                printf "${colors[green]}%-10s${colors[reset]} ${colors[blue]}%s${colors[reset]}\n" "$iface:" "$ip_addr"
            done
            echo
            ;;
        -i)
            echo
            ip -o link show | awk -v g="${colors[green]}" -v r="${colors[reset]}" '{printf "%s%s%s\n", g, $2, r}' | sed 's/://'
            echo
            ;;
        -M)
            echo
            ip link show | awk -v g="${colors[green]}" -v m="${colors[magenta]}" -v r="${colors[reset]}" '
                /^[0-9]+: / { iface=$2; gsub(":", "", iface) }
                /link\/ether/ { printf "%s%-10s%s %s%s%s\n", g, iface ":", r, m, $2, r }'
            echo
            ;;
        -A)
            echo
            ip -o link show | while read -r _ iface _; do
                iface=${iface%:}
                mac=$(ip link show "$iface" | awk '/link\/ether/ {print $2}')
                ip=$(ip -4 -o addr show "$iface" | awk '{print $4}' | cut -d/ -f1)
                printf "${colors[green]}%-10s${colors[reset]} ${colors[blue]}%-15s${colors[reset]} ${colors[magenta]}%s${colors[reset]}\n" "$iface:" "${ip:-–}" "${mac:-–}"
            done
            echo
            ;;
        -p)
            echo -ne "\n${colors[cyan]}Show public IP? (y/N): ${colors[reset]}"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                ip_publica=$(curl -s https://api.ipify.org)
                echo -e "\n${colors[green]}Public IP:${colors[reset]} ${colors[blue]}${ip_publica}${colors[reset]}\n"
            fi
            ;;
        -h|"")
            show_help
            ;;
        *)
            show_help
            ;;
    esac
}
