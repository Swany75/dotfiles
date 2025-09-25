#!/bin/bash

# Rofi System Actions Menu
# Save this as ~/.local/bin/rofi-power-menu or similar and make executable

# Define the options with Papirus icon theme names
# The \0icon\x1f syntax tells rofi to use the specified icon name from the icon theme
options=" Shutdown\0icon\x1fsystem-shutdown
 Reboot\0icon\x1fsystem-reboot
 Lock Screen\0icon\x1fsystem-lock-screen
 Suspend\0icon\x1fsystem-suspend
 Hibernate\0icon\x1fsystem-hibernate
 Logout\0icon\x1fsystem-log-out
 Cancel\0icon\x1fprocess-stop"

# Show the menu and get user choice
chosen=$(echo -e "$options" | rofi -dmenu -i -p "System Actions" \
    -show-icons \
    -theme-str 'window {width: 300px; height: 350px;}' \
    -theme-str 'listview {lines: 7;}' \
    -theme-str 'element-text {horizontal-align: 0;}' \
    -no-custom)

# Execute the chosen action
case $chosen in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Lock Screen")
        # Change this to your preferred screen locker
        # Common options: i3lock, xscreensaver-command -lock, gnome-screensaver-command -l
        i3lock-fancy
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Hibernate")
        systemctl hibernate
        ;;
    " Logout")
        # Simple and elegant logout - try universal methods
        loginctl terminate-session "${XDG_SESSION_ID:-self}" 2>/dev/null || \
        loginctl kill-session "${XDG_SESSION_ID:-self}" 2>/dev/null || \
        pkill -TERM -s -1
        ;;
    " Cancel")
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
