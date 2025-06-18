#!/bin/zsh

### Functions #######################################################################################################################

# Make Tree
function mkt(){
	mkdir nmap content exploits scripts
}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}

# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

function scanPorts() {
    local host="${1:-127.0.0.1}"
    local start_port="${2:-1}"
    local end_port="${3:-1024}"

    _show_message "Starting port scan on $host ports $start_port-$end_port..." "info"
    tput civis

    trap _ctrl_c INT

    for port in $(seq $start_port $end_port); do
        (echo > /dev/tcp/"$host"/"$port") 2>/dev/null && echo "[+] $port - OPEN" &
    done

    wait
    tput cnorm
    _show_message "Port scan finished." "info"
}

### scanNet: escaneja hosts actius a una subxarxa (per defecte 192.168.1.x) ###

function scanNet() {
    local subnet="${1:-192.168.1}"
    _show_message "Starting network scan on $subnet.1-254..." "info"
    trap _ctrl_c INT

    for i in $(seq 1 254); do
        timeout 1 bash -c "ping -c 1 $subnet.$i &>/dev/null" && echo "[+] Host $subnet.$i - ACTIVE" &
    done

    wait
    _show_message "Network scan finished." "info"
}

# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	               echo {} is a binary file ||
	                (bat --style=numbers --color=always {} ||
	                 highlight -O ansi -l {} ||
	                 coderay {} ||
	                 rougify {} ||
	                 cat {}) 2> /dev/null | head -500'

	else
	       fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                        echo {} is a binary file ||
	                        (bat --style=numbers --color=always {} ||
	                         highlight -O ansi -l {} ||
	                         coderay {} ||
	                         rougify {} ||
	                         cat {}) 2> /dev/null | head -500'
	fi
}

