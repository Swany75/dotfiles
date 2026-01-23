#!/usr/bin/zsh

TRASH_DIR="${HOME}/.trash"

# Ensure trash dir exists
if [[ ! -d "$TRASH_DIR" ]]; then
  mkdir -p "$TRASH_DIR"
fi

rm() {
  local OPTIND opt
  local files=()

  # Ensure trash directory exists
  if [[ ! -d "$TRASH_DIR" ]]; then
    mkdir -p "$TRASH_DIR"
  fi

  # Parse options but silently ignore -r and -f
  while getopts ":rf" opt; do
    case $opt in
      r|f)
        # Ignore -r and -f options silently
        ;;
      \?)
        echo "rm: invalid option -- $OPTARG"
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  files=("$@")

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "rm: missing operand"
    return 1
  fi

  for f in "${files[@]}"; do
    if [[ -e "$f" ]]; then
      local base=$(basename -- "$f")
      local target="$TRASH_DIR/$base"
      # If target exists, add timestamp prefix
      if [[ -e "$target" ]]; then
        target="$TRASH_DIR/$(date +%s)_$base"
      fi
      mv -- "$f" "$target"
      if [[ $? -ne 0 ]]; then
        echo "rm: failed to move '$f' to trash"
      fi
    else
      echo "rm: cannot remove '$f': No such file or directory"
    fi
  done
}

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
     sudo /bin/rm -rf -- "$TRASH_DIR"/*
    _show_message "Trash successfully emptied." "plus"
  else
    _show_message "Cancelled." "minus"
  fi
}
