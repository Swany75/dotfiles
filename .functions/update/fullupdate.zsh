#!/usr/bin/zsh

fullupdate() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt dist-upgrade -y
  discordupdate
  npm install -g @github/copilot@latest
}
