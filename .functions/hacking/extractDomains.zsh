#!/usr/bin/zsh

function extractDomains() {
    # Extreu dominis dels URL en un fitxer i els desa a 'domains.txt'
    grep -oP '(?<=://)[^/]*' "$1" | sort -u | tee domains.txt
    echo "[*] Dominis guardats a domains.txt"
}
