#!/usr/bin/zsh

function hashidall() {
    # Detecta tipus de hash per a cada línia d'un fitxer
    while read -r hash; do
        echo -e "\n[+] $hash"
        hashid -m "$hash"
    done < "$1"
}
