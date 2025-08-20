#!/bin/zsh

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

function connections() {
  _show_message "Showing active connections..." info

  # SSH Sessions (from 'who')
  ssh_sessions=$(who | grep -E '(\(|\bpts\b)')
  if [[ -n "$ssh_sessions" ]]; then
    echo -e "${colors[cyan]}── SSH Sessions ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────${colors[reset]}"
    echo "$ssh_sessions" | while read -r user tty date time ip; do
      ip_clean=${ip//[\(\)]/}
      [[ -z "$ip_clean" ]] && ip_clean="localhost"
      echo -e "${colors[green]}User:${colors[reset]} $user"
      echo -e "${colors[green]}Terminal:${colors[reset]} $tty"
      echo -e "${colors[green]}Time:${colors[reset]} $date $time"
      echo -e "${colors[green]}IP:${colors[reset]} $ip_clean"
      echo
    done
  fi

  # tmate sessions
  tmate_sessions=$(pgrep -af tmate)
  if [[ -n "$tmate_sessions" ]]; then
    echo -e "${colors[cyan]}── tmate Sessions (if any) ───────────────────────────────────────────────────────────────────────────────────────────────────────────────${colors[reset]}"
    echo "$tmate_sessions" | while read -r line; do
      echo -e "${colors[yellow]}$line${colors[reset]}"
    done
  fi

  # Active SSH network connections
  ssh_network=$(ss -tp | grep ssh)
  if [[ -n "$ssh_network" ]]; then
    echo -e "${colors[cyan]}── Active SSH Network Connections ────────────────────────────────────────────────────────────────────────────────────────────────────────${colors[reset]}"
    echo "$ssh_network" | while read -r line; do
      echo -e "${colors[magenta]}$line${colors[reset]}"
    done
  fi

  # Other active sessions from 'w'
  other_sessions=$(w -h | awk '{printf "%-10s %-10s %-10s %-15s\n", $1, $2, $3, $NF}')
  if [[ -n "$other_sessions" ]]; then
    echo -e "${colors[cyan]}── Other Active Sessions ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────${colors[reset]}"
    echo "$other_sessions" | while read -r u t l ip; do
      echo -e "${colors[blue]}User:${colors[reset]} $u ${colors[blue]}Terminal:${colors[reset]} $t ${colors[blue]}Login:${colors[reset]} $l ${colors[blue]}From:${colors[reset]} $ip"
    done
  fi
}

function chintnm() {
  trap _ctrl_c INT
  
  if [[ $# -ne 2 ]]; then
    _show_message "Usage: chintnm <old_name> <new_name>" error
    return 1
  fi

  local old_if=$1
  local new_if=$2

  # Comprovem si la interfície existeix
  if ! ip link show "$old_if" &>/dev/null; then
    _show_message "Interface $old_if not found" error
    return 1
  fi

  _show_message "Changing interface name from $old_if to $new_if..." info

  # Desactivem i canviem nom
  sudo ip link set "$old_if" down || {
    _show_message "Failed to bring $old_if down" error
    return 1
  }

  sudo ip link set "$old_if" name "$new_if" || {
    _show_message "Failed to rename $old_if to $new_if" error
    sudo ip link set "$old_if" up
    return 1
  }

  sudo ip link set "$new_if" up || {
    _show_message "Failed to bring $new_if up" error
    return 1
  }

  _show_message "Interface renamed successfully: $old_if → $new_if" plus
}
