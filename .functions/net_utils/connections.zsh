#!/usr/bin/zsh

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
