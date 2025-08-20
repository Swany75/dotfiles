#!/bin/zsh

TRASH_DIR="${HOME}/.trash"

# Ensure trash dir exists
if [[ ! -d "$TRASH_DIR" ]]; then
  mkdir -p "$TRASH_DIR"
fi

# Function: permanently delete files from anywhere
remove() {
  if [ -z "$1" ]; then
    _show_message "Usage: remove <file>" "error"
    return 1
  fi

  _show_message "Are you sure you want to permanently delete" "info" "$* ${colors[yellow]}[y/N]${colors[cyan]}:"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    command rm -rf -- "$@"
    _show_message "Deleted permanently." "plus"
  else
    _show_message "Cancelled." "minus"
  fi
}

# Function: show contents of trash
trash() {
  if [ "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
    _show_message "Trash contents:" "info"
    ls -lh -- "$TRASH_DIR"
  else
    _show_message "Trash is empty." "minus"
  fi
}

# Function: empty the trash with confirmation
clear_trash() {
  if [ ! "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
    _show_message "Trash is already empty." "info"
    return
  fi

  _show_message "This will permanently delete ALL contents in the trash!" "error"
  printf "${colors[cyan]}Continue? ${colors[yellow]}[y/N]: ${colors[reset]}"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    /bin/rm -rf -- "$TRASH_DIR"/*
    _show_message "Trash successfully emptied." "plus"
  else
    _show_message "Cancelled." "minus"
  fi
}

# Function: prompt once per Friday to empty or view trash
_empty_trash_prompt_once_per_friday() {
  local weekday today control_file
  weekday=$(date +%u)           # 5 = Friday
  today=$(date +%F)
  control_file="/tmp/.trash_cleanup_shown_$today"

  if [ "$weekday" -eq 5 ] && [ ! -f "$control_file" ] && [ "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
    _show_message "There are files in your trash. Empty now? (y/N), or view contents? (v)" "minus"
    read -r response
    case "$response" in
      [Yy]) clean_trash; touch "$control_file" ;;
      [Vv]) show_trash; touch "$control_file" ;;
      *) _show_message "Trash preserved." "info" ;;
    esac
  fi
}

# Run the prompt on every shell launch (only triggers on Fridays)
_empty_trash_prompt_once_per_friday
