#!/bin/bash

INTERFACES=("enp4s0" "wlo1" "docker0" "lo")
ICACHE="/tmp/polybar_network_interface_index"

# Si no hi ha fitxer d'estat, posem Ethernet (index 0) per defecte
if [ ! -f "$ICACHE" ]; then
  echo 0 > "$ICACHE"
fi

# Si s'executa amb argument 'next', canvia la interfície
if [ "$1" = "next" ]; then
  current_index=$(cat "$ICACHE")
  next_index=$(( (current_index + 1) % ${#INTERFACES[@]} ))
  echo $next_index > "$ICACHE"
  exit 0
fi

# Funció per obtenir IP de la interfície
get_ip() {
  ip addr show "$1" | grep "inet " | awk '{print $2}' | cut -d/ -f1
}

# Intentem trobar una interfície amb IP vàlida
current_index=$(cat "$ICACHE")
count=${#INTERFACES[@]}
checked=0

while [ $checked -lt $count ]; do
  interface="${INTERFACES[$current_index]}"
  ip=$(get_ip "$interface")
  
  # Ignora Ethernet i WiFi si no tenen IP
  if [[ "$interface" == "enp4s0" || "$interface" == "wlo1" ]]; then
    if [ -n "$ip" ]; then
      break
    fi
  else
    # Per docker0, lo o altres, accepta la que sigui (inclus si no té IP)
    break
  fi

  # Si no ha trobat IP vàlida, prova la següent interfície
  current_index=$(( (current_index + 1) % count ))
  checked=$((checked + 1))
done

# Assigna l'interfície final a mostrar
interface="${INTERFACES[$current_index]}"
ip=$(get_ip "$interface")

# Emoji segons interfície
case $interface in
  enp4s0) emoji="󰈀" ;;
  wlo1) emoji="" ;;
  docker0) emoji="" ;;
  lo) emoji="󱦙" ;;
  *) emoji="" ;;
esac

# Mostrar IP o missatge d'error
if [[ ( "$interface" == "enp4s0" || "$interface" == "wlo1" ) && -z "$ip" ]]; then
  # Creu vermella i "No IP"
  echo "%{F#FF0000} %{F#FFFFFF}No IP%{u-}"
elif [[ "$interface" == "lo" && -n "$ip" ]]; then
  # Emoji groc per loopback amb IP
  echo "%{F#FFD700}$emoji %{F#FFFFFF}$ip%{u-}"
elif [ -z "$ip" ]; then
  # Per docker0 o lo sense IP, no mostrar res
  echo ""
else
  # La resta amb emoji blau i IP
  echo "%{F#2495e7}$emoji %{F#FFFFFF}$ip%{u-}"
fi
