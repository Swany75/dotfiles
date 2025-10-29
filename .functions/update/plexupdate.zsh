#!/usr/bin/zsh

plexupdate() {
  local url="https://plex.tv/downloads/latest/5?channel=16&build=linux-x86_64&distro=debian&X-Plex-Token=xxxxxxxxxxxxxxxxxxxx"
  local file="/tmp/plexmediaserver_latest.deb"

  _show_message "Downloading the latest version of Plex Media Server..." info
  curl -L "$url" -o "$file"

  if [[ $? -ne 0 ]]; then
    _show_message "Failed to download Plex. Check your connection or token." error
    return 1
  fi

  _show_message "Installing the package..." plus
  sudo dpkg -i "$file"

  if [[ $? -ne 0 ]]; then
    _show_message "Error during installation." error
    return 1
  fi

  _show_message "Restarting Plex Media Server..." info
  sudo systemctl restart plexmediaserver

  if [[ $? -eq 0 ]]; then
    _show_message "Plex successfully updated and restarted!" plus
  else
    _show_message "Failed to restart Plex. Check the service status." error
  fi

  # Optional: delete the downloaded package
  rm -f "$file"
}
