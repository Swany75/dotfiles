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

if command -v systemctl >/dev/null 2>&1; then
    INIT=systemd
else
    INIT=openrc
fi

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
        if [[ $INIT == systemd ]]; then
            systemctl poweroff
        else
            sudo halt
        fi
        ;;
    " Reboot")
        if [[ $INIT == systemd ]]; then
            systemctl reboot
        else
            sudo reboot
        fi
        ;;
    " Lock Screen")
        # Cambiar al locker que uses
        i3lock-fancy
        ;;
    " Suspend")
        if [[ $INIT == systemd ]]; then
            systemctl suspend
        else
            sudo pm-suspend
        fi
        ;;
    " Hibernate")
        if [[ $INIT == systemd ]]; then
            systemctl hibernate
        else
            sudo pm-hibernate
        fi
        ;;
    " Logout")
        if [[ $INIT == systemd ]]; then
            loginctl terminate-session "${XDG_SESSION_ID:-self}" 2>/dev/null || \
            loginctl kill-session "${XDG_SESSION_ID:-self}" 2>/dev/null || \
            pkill -TERM -s -1
        else
            # OpenRC / sesión X11 simple
            pkill -KILL -u "$USER"
        fi
        ;;
    " Cancel")
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
