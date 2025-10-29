#!/usr/bin/zsh

function chintnm() {
  trap _ctrl_c INT
  
  if [[ $# -ne 2 ]]; then
    _show_message "Usage: chintnm <old_name> <new_name>" error
    return 1
  fi

  local old_if=$1
  local new_if=$2

  # Comprovem si la interfície existeix
  if ! ip link show "$old_if" &>/dev/null; then
    _show_message "Interface $old_if not found" error
    return 1
  fi

  _show_message "Changing interface name from $old_if to $new_if..." info

  # Desactivem i canviem nom
  sudo ip link set "$old_if" down || {
    _show_message "Failed to bring $old_if down" error
    return 1
  }

  sudo ip link set "$old_if" name "$new_if" || {
    _show_message "Failed to rename $old_if to $new_if" error
    sudo ip link set "$old_if" up
    return 1
  }

  sudo ip link set "$new_if" up || {
    _show_message "Failed to bring $new_if up" error
    return 1
  }

  _show_message "Interface renamed successfully: $old_if → $new_if" plus
}
