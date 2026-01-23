"""Workspace groups configuration for Qtile."""

from libqtile.config import Group, Key
from libqtile.lazy import lazy

from settings.constants import mod

def get_groups():
    """Return the list of groups (workspaces)."""
    return [Group(i) for i in [
        "  ", "  ", "  ", " 󰉋 ", "  ", "  ", "  ", "  ", "  ", "  "
    ]]

def get_group_keys(groups):
    """Return key bindings for switching between groups."""
    keys = []
    # Map keys 1-9,0 to workspaces 0-8,9
    key_mapping = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
    
    for i, group in enumerate(groups):
        if i < len(key_mapping):
            actual_key = key_mapping[i]
            keys.extend([
                # Switch to workspace N
                Key([mod], actual_key, lazy.group[group.name].toscreen()),
                # Send window to workspace N
                Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
            ])
    return keys
