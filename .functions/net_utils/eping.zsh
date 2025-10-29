#!/usr/bin/zsh

function eping() {
  trap _ctrl_c INT

  local ip="$1"
  if [[ -z "$ip" ]]; then
    _show_message "Usage:" "error" "eping <ip-address>"
    return 1
  fi

  # Detect OS type from first TTL
  local first_ping ttl os_name
  first_ping=$(ping -c 1 -W 2 "$ip" 2>/dev/null | grep -i ttl=)
  if [[ -z "$first_ping" ]]; then
    _show_message "No response from" "error" "${ip}"
    return 1
  fi

  ttl=$(echo "$first_ping" | grep -oE "ttl=[0-9]+" | cut -d= -f2)

  # More accurate OS detection based on default TTL values
  if (( ttl >= 1 && ttl <= 64 )); then
    os_name="Unix"
  elif (( ttl >= 65 && ttl <= 128 )); then
    os_name="Windows"
  elif (( ttl >= 129 && ttl <= 255 )); then
    os_name="Network Device"
  else
    os_name="Unknown"
  fi

  _show_message "The Machine's OS is:" "plus" "${colors[red]}${os_name}${colors[reset]}"

  # Start continuous ping with colors
  echo -e "${colors[cyan]}── Ping Results ───────────────────────────────────────────────${colors[reset]}\n"
  ping "$ip" | while IFS= read -r line; do
    if [[ "$line" =~ "bytes from" ]]; then
      echo -e "${colors[green]}$line${colors[reset]}"
    elif [[ "$line" =~ "packet loss" ]]; then
      echo -e "${colors[yellow]}$line${colors[reset]}"
    elif [[ "$line" =~ "PING" ]]; then
      echo -e "${colors[cyan]}$line${colors[reset]}"
    elif [[ "$line" =~ "Unreachable" ]]; then
      echo -e "${colors[red]}$line${colors[reset]}"
    else
      echo -e "${colors[gray]}$line${colors[reset]}"
    fi
  done

}
