#!/bin/zsh

### CONSTANTS #############################################################
TRASH_DIR="${HOME}/.trash"

# Ensure trash dir exists
if [[ ! -d "$TRASH_DIR" ]]; then
  mkdir -p "$TRASH_DIR"
fi

### MKCD ##################################################################

function mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory_name>"
        return 1
    fi

    mkdir -p "$1" && cd "$1" || return 1
}

### MAN (Manual) ##########################################################

man() {
  command man "$@" | col -bx | bat -l man -p
}

### Extract ###############################################################

function extract () {
    # Detecta el tipus d'arxiu i el descomprimeix
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "'$1' no es pot extreure amb extract()" ;;
        esac
    else
        echo "'$1' no és un arxiu vàlid"
    fi
}

### Backup ################################################################

function backup() {
    # Show help
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _show_message "Usage: backup <file_or_directory>
- For files: copies .bak in same dir and timestamped copy in ~/.backup
- For directories: copies .bak in same dir and compressed .zip in ~/.backup" "info"
        return 0
    fi

    # Check argument
    if [[ -z "$1" ]]; then
        _show_message "No file or directory specified" "error"
        return 1
    fi

    local target="$1"
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    local backup_dir="$HOME/.backup"

    # Create backup dir if not exists
    [[ ! -d "$backup_dir" ]] && mkdir -p "$backup_dir"

    if [[ -f "$target" ]]; then
        # File backup
        local base=$(basename "$target")
        local dir=$(dirname "$target")
        local bak_name="${base}_${timestamp}.bak"

        cp "$target" "$dir/$bak_name"
        cp "$target" "$backup_dir/$bak_name"

    elif [[ -d "$target" ]]; then
        # Directory backup
        local base=$(basename "$target")
        local dir=$(dirname "$target")
        local bak_name="${base}_${timestamp}.bak"
        local zip_name="${base}_${timestamp}.zip"

        cp -r "$target" "$dir/$bak_name"
        zip -r "$backup_dir/$zip_name" "$target" > /dev/null

    else
        _show_message "Target '$target' does not exist!" "error"
        return 1
    fi

    _show_message "Backup Completed" "plus"
}

### Copy Output from a file (CPUT) ########################################

function cput() {
    local file="$1"

    if [[ -z "$file" || ! -f "$file" ]]; then
        _show_message "File not found or not specified" "error"
        return 1
    fi

    # Detect clipboard command
    if command -v wl-copy &>/dev/null; then
        cat "$file" | wl-copy
        _show_message "File copied to clipboard" "plus"
    elif command -v xclip &>/dev/null; then
        cat "$file" | xclip -selection clipboard
        _show_message "File copied to clipboard" "plus"
    else
        _show_message "No clipboard command found (install wl-clipboard or xclip)" "error"
        return 1
    fi
}

### RM Function + Trash ###################################################

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

### Remove ################################################################

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

### Trash & ClearTrash ####################################################

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


### SET WALLPAPER ############################################################

function set_wallpaper() {
  local wallpaper_dir="$HOME/Pictures/Wallpapers"
  local valid_exts=("jpg" "jpeg" "png" "webp" "bmp")
  local images=()

  for file in "$wallpaper_dir"/*; do
    local filename="${file:t}"
    local ext="${filename:e}"

    if [[ -f "$file" && "$filename" != .* ]]; then
      for ext_allowed in "${valid_exts[@]}"; do
        if [[ "$ext" == "$ext_allowed" ]]; then
          images+=("$filename")
        fi
      done
    fi
  done

  if [[ ${#images[@]} -eq 0 ]]; then
    _show_message "No visible image wallpapers found!" error
    return 1
  fi

  # --- Amb argument: intentar posar-lo ---
  if [[ -n "$1" ]]; then
    local selected="$1"
    if [[ " ${images[@]} " == *" $selected "* ]]; then
      feh --bg-scale "$wallpaper_dir/$selected" &>/dev/null
      _show_message "Wallpaper '$selected' applied successfully!" info
    else
      _show_message "Wallpaper '$selected' not found!" error
      return 1
    fi
    return 0
  fi

  # --- Sense argument: menú interactiu ---
  _show_message "Available wallpapers (type name with extension):" info
  for img in "${(@u)images[@]}"; do
    echo -e "${colors[green]} - ${colors[cyan]}$img${colors[reset]}"
  done

  echo -ne "\n${colors[blue]}[?]${colors[green]} Enter wallpaper filename (with extension): ${colors[reset]}"
  read selected

  if [[ " ${images[@]} " == *" $selected "* ]]; then
    feh --bg-scale "$wallpaper_dir/$selected" &>/dev/null
    _show_message "Wallpaper '$selected' applied successfully!" info
  else
    _show_message "Wallpaper '$selected' not found!" error
    return 1
  fi
}
