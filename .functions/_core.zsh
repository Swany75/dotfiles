#!/bin/zsh

### Colors ##########################################################################################################################

declare -A colors=(
  [orange]='\033[38;5;208m'
  [green]='\033[0;32m'
  [red]='\033[0;31m'
  [blue]='\033[0;34m'
  [yellow]='\033[0;33m'
  [purple]='\033[0;35m'
  [turquoise]='\033[0;36m'
  [gray]='\033[0;37m'
  [magenta]='\033[0;35m'
  [cyan]='\033[0;36m'
  [black]='\033[0;30m'
  [white]='\033[0;97m'
  [reset]='\033[0m'
)

### Functions Privades #######################################################################################################

function _ctrl_c(){
  echo -e "\n\n${colors[red]}[!] ${colors[yellow]}Exiting...${colors[reset]}\n"
  tput cnorm; exit 1
}

function _calcSpaces() {
  local text=$1
  local maxlen=$2
  local lenText=${#text}
  local spaces=$(( maxlen - lenText ))

  if (( spaces > 0 )); then
    printf "%s%*s" "$text" "$spaces" ""
  else
    echo "${text[1,maxlen]}"
  fi
}

function _show_message() {
  local message="$1"
  local symbol="${2:-plus}"
  local extra="$3"

  case "$symbol" in
    error)
      echo -e "\n\n${colors[red]}[!] ${colors[yellow]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    inverse_error)
      echo -e "\n\n${colors[red]}[¡] ${colors[yellow]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    question)
      echo -e "\n${colors[blue]}[?] ${colors[green]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    inverse_question)
      echo -e "\n${colors[blue]}[¿] ${colors[green]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    info)
      echo -e "\n${colors[green]}[i] ${colors[cyan]}$message ${colors[red]}$extra${colors[reset]}\n"
      ;;
    minus)
      echo -e "\n${colors[yellow]}[-] ${colors[cyan]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    plus)
      echo -e "\n${colors[yellow]}[+] ${colors[cyan]}$message ${colors[white]}$extra${colors[reset]}\n"
      ;;
    euro)
      echo -e "\n${colors[green]}[€] ${colors[cyan]}$message ${colors[yellow]}$extra€ ${colors[reset]}"
      ;;
    dollar)
      echo -e "\n${colors[green]}[$] ${colors[cyan]}$message ${colors[yellow]}$extra$ ${colors[reset]}"
      ;;
    asterisk)
      echo -e "\n${colors[purple]}[*] ${colors[pink]}$message ${colors[cyan]}$extra${colors[reset]}"
      ;;
  esac
}
