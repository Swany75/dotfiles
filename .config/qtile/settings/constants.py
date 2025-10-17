"""Constants and configuration variables for Qtile."""

import os
import socket
import psutil

# System information
def get_hostname():
    name_file = os.path.join(os.path.dirname(__file__), 'name.txt')
    if os.path.exists(name_file):
        try:
            with open(name_file, 'r') as f:
                first_line = f.readline().strip()
                if first_line:
                    return first_line
        except Exception:
            pass
    return socket.gethostname()

HOSTNAME = get_hostname()

def get_ip():
    for iface, addrs in psutil.net_if_addrs().items():
        for addr in addrs:
            if addr.family == socket.AF_INET and not addr.address.startswith('127.'):
                return addr.address
    return None

IP = get_ip()

# Terminal and modifier key
mod = "mod4"
terminal = "kitty"

# Color scheme
colors = {
    'dark': '#0f101a',
    'grey': '#353c4a',
    'light': '#f1ffff',
    'text': '#0f101a',
    'focus': '#a151d3',
    'active': '#f1ffff',
    'inactive': '#4c566a',
    'urgent': '#F07178',
    'purple_spyro1': '#7038A1',
    'yellow_spyro1': '#F6D600',
    'purple_spyro2': '#8B3CDE',
    'yellow_spyro2': '#FFD600',
    'color1': '#a151d3',
    'color2': '#F07178',
    'color3': '#fb9f7f',
    'color4': '#ffd47e',
    'purple': '#9B4F96',
    'cyan': '#00FFFF',
    'pinky': '#F4A8A8',
    'yellow': '#F9E04D',
    'white': '#FFFFFF',
    'amstrad_red': '#E10600',
    'amstrad_blue': '#0061A0',
    'amstrad_green': '#48A23F',
    'amstrad_grey': '#53565A',
    'amstrad_black': '#040404',
    'amstrad_dark': '#454849',
    'yellow_mini': '#FFD700',
}

# Widget defaults
widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
