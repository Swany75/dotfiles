#!/usr/bin/zsh

discordupdate() {
  local url="https://discord.com/api/download/stable?platform=linux&format=deb"
  local file="/tmp/discord_latest.deb"

  _show_message "Downloading the latest version of Discord..." info
  curl -L "$url" -o "$file"

  if [[ $? -ne 0 ]]; then
    _show_message "Failed to download Discord. Check your connection." error
    return 1
  fi

  _show_message "Installing the package..." plus
  sudo dpkg -i "$file"

  if [[ $? -ne 0 ]]; then
    _show_message "Error during installation." error
    return 1
  fi

  _show_message "Discord successfully updated!" plus

  rm -f "$file"
}
