#!/bin/zsh

# Extracte de dominis d'un arxiu
function extractDomains() {
    # Extreu dominis dels URL en un fitxer i els desa a 'domains.txt'
    grep -oP '(?<=://)[^/]*' "$1" | sort -u | tee domains.txt
    echo "[*] Dominis guardats a domains.txt"
}

# Whois per cada domini en un fitxer
function whoisall() {
    # Fa un 'whois' per a cada domini en un fitxer i mostra només les primeres línies
    while read -r domain; do
        echo -e "\n--- $domain ---"
        whois "$domain" | head -n 20
    done < "$1"
}

# Identifica els tipus de hash en un fitxer
function hashidall() {
    # Detecta tipus de hash per a cada línia d'un fitxer
    while read -r hash; do
        echo -e "\n[+] $hash"
        hashid -m "$hash"
    done < "$1"
}


