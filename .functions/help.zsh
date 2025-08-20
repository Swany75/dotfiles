#!/bin/zsh

trap _ctrl_c INT

function help() {
  while true; do
    clear
    header="$(_calcSpaces '    Welcome to the custom functions help panel' 52)"
    echo -e "${colors[purple]}┌────────────────────────────────────────────────────┐${colors[reset]}"
    echo -e "${colors[purple]}│${colors[cyan]}$header${colors[purple]}│${colors[reset]}"
    echo -e "${colors[purple]}└────────────────────────────────────────────────────┘${colors[reset]}"
    echo -e "${colors[green]}[?]${colors[reset]} ${colors[cyan]}Which module do you want to view?${colors[reset]}\n"

    echo -e "${colors[yellow]} 01)${colors[reset]} ${colors[blue]}_core        ${colors[reset]} - Support functions used by other modules"
    echo -e "${colors[yellow]} 02)${colors[reset]} ${colors[blue]}ascii_art    ${colors[reset]} - Fun ASCII banners"
    echo -e "${colors[yellow]} 03)${colors[reset]} ${colors[blue]}extract_files${colors[reset]} - Extract compressed files"
    echo -e "${colors[yellow]} 04)${colors[reset]} ${colors[blue]}hacking      ${colors[reset]} - Tools for URL, whois, hashes"
    echo -e "${colors[yellow]} 05)${colors[reset]} ${colors[blue]}net_utils    ${colors[reset]} - Network tools and target setter"
    echo -e "${colors[yellow]} 06)${colors[reset]} ${colors[blue]}notes        ${colors[reset]} - Simple notes manager"
    echo -e "${colors[yellow]} 07)${colors[reset]} ${colors[blue]}polybar      ${colors[reset]} - Polybar helpers"
    echo -e "${colors[yellow]} 08)${colors[reset]} ${colors[blue]}random_stuff ${colors[reset]} - Random or funny commands"
    echo -e "${colors[yellow]} 09)${colors[reset]} ${colors[blue]}s4vitar      ${colors[reset]} - Automation and tools inspired by s4vitar"
    echo -e "${colors[yellow]} 10)${colors[reset]} ${colors[blue]}sys_utils    ${colors[reset]} - System tools and helpers"
    echo -e "${colors[yellow]} 11)${colors[reset]} ${colors[blue]}trash        ${colors[reset]} - Safe delete and trash system"
    echo -e "${colors[yellow]} 12)${colors[reset]} ${colors[blue]}wallpapers   ${colors[reset]} - Wallpaper manager"
    echo -e "${colors[yellow]} 13)${colors[reset]} ${colors[blue]}help         ${colors[reset]} - This help menu"

    echo -ne "\n${colors[green]}➤${colors[reset]} ${colors[cyan]}Select module number:${colors[reset]} "
    read choice

    clear
    case $choice in
      1)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}_core${colors[reset]}\n"
        echo -e "  ${colors[green]}_ctrl_c${colors[reset]}      → Handles Ctrl+C and exits cleanly"
        echo -e "  ${colors[green]}_show_message${colors[reset]} → Displays colored status/info messages\n"
        # Substituir per show_message el seguent text tipus INFO
        echo -e "${colors[gray]}These are internal utility functions used to enhance other modules.${colors[reset]}"
        ;;
      2)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}ASCII Art${colors[reset]}\n"
        echo -e "  ${colors[green]}ascii_demon${colors[reset]}   → Prints a red ASCII demon"
        ;;
      3)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Extract Files${colors[reset]\n}"
        echo -e "  ${colors[green]}extract${colors[reset]}       → Extracts common compressed files"
        ;;
      4)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Hacking${colors[reset]}\n"
        echo -e "  ${colors[green]}extractDomains${colors[reset]} → Extract domains from URLs in a file"
        echo -e "  ${colors[green]}whoisall${colors[reset]}       → WHOIS lookup for domains"
        echo -e "  ${colors[green]}hashidall${colors[reset]}      → Detect hash types from a file"
        ;;
      5)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Net Utils${colors[reset]}\n"
        echo -e "  ${colors[green]}ifaces${colors[reset]}         → Show interface info (IP, MAC, public IP)"
        echo -e "  ${colors[green]}settarget${colors[reset]}      → Save target IP and name"
        echo -e "  ${colors[green]}cleartarget${colors[reset]}    → Clear saved target info"
        ;;
      6)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Notes${colors[reset]}\n"
        echo -e "  ${colors[green]}remember${colors[reset]}       → Save a note with a timestamp"
        echo -e "  ${colors[green]}notes${colors[reset]}          → View all saved notes"
        echo -e "  ${colors[green]}clear_notes${colors[reset]}    → Clear all notes with confirmation"
        ;;
      7)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Polybar${colors[reset]}\n"
        echo -e "  ${colors[green]}settarget${colors[reset]} / ${colors[green]}cleartarget${colors[reset]} → Used in Polybar scripts"
        ;;
      8)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Random Stuff${colors[reset]}\n"
        echo -e "  ${colors[green]}tetas${colors[reset]}          → Print a list of funny synonyms"
        echo -e "  ${colors[green]}jagger${colors[reset]}         → Set Jägermeister wallpaper"
        ;;
      9)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}S4vitar${colors[reset]}\n"
        echo -e "  ${colors[green]}auto_enum, install_tools${colors[reset]} → Automations inspired by s4vitar"
        ;;
      10)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}System Utils${colors[reset]}\n"
        echo -e "  ${colors[green]}mkt${colors[reset]}            → Create dirs for recon (nmap, etc.)"
        echo -e "  ${colors[green]}rmk${colors[reset]}            → Secure delete (scrub + shred)"
        echo -e "  ${colors[green]}extractPorts${colors[reset]}   → Extract IPs and ports from Nmap output"
        echo -e "  ${colors[green]}scanPorts${colors[reset]}      → TCP port scanner"
        echo -e "  ${colors[green]}scanNet${colors[reset]}        → Ping sweep on subnet"
        echo -e "  ${colors[green]}fzf-lovely${colors[reset]}     → Enhanced fzf with file previews"
        ;;
      11)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Trash${colors[reset]}\n"
        echo -e "  ${colors[green]}rm (override)${colors[reset]}  → Move files to ~/.trash"
        echo -e "  ${colors[green]}remove${colors[reset]}         → Permanently delete with prompt"
        echo -e "  ${colors[green]}trash${colors[reset]}          → View trash contents"
        echo -e "  ${colors[green]}clear_trash${colors[reset]}    → Empty trash with confirmation"
        ;;
      12)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Wallpapers${colors[reset]}\n"
        echo -e "  ${colors[green]}set_wallpaper${colors[reset]}  → (Placeholder, not implemented yet)"
        ;;
      13)
        echo -e "${colors[yellow]}Module: ${colors[cyan]}Help${colors[reset]}\n"
        echo -e "  ${colors[green]}help${colors[reset]}           → Show this menu"
        ;;
      *)
        _show_message "Invalid selection." "error"
        ;;
    esac

    _show_message "Press ENTER to return to the main menu  |  Ctrl+C to exit the program" plus ""
    read
  done
}
