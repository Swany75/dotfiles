#!/usr/bin/zsh

function whoisall() {
    # Fa un 'whois' per a cada domini en un fitxer i mostra només les primeres línies
    while read -r domain; do
        echo -e "\n--- $domain ---"
        whois "$domain" | head -n 20
    done < "$1"
}
