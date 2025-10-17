"""Startup hooks for Qtile."""

import subprocess
from os import path
from libqtile import hook

@hook.subscribe.startup_once
def autostart():
    """Run autostart script once on startup."""
    subprocess.call([path.join(path.expanduser('~'), '.config', 'qtile', 'autostart.sh')])