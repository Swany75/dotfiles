#!/usr/bin/zsh

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
