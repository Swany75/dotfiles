"""Key bindings configuration for Qtile."""

from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile import qtile

from settings.constants import mod, terminal

def get_keys():
    """Return the list of key bindings."""
    keys = [
        # Window navigation
        Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
        Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
        Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
        
        # Window movement
        Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
        Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
        
        # Window resizing
        Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
        Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
        Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
        Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
        Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
        
        # Layout controls
        Key(
            [mod, "shift"],
            "Return",
            lazy.function(lambda qtile: qtile.current_layout.toggle_split()
                      if hasattr(qtile.current_layout, "toggle_split") else None),
            desc="Toggle split in Stack layout",
        ),
        Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
        Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
        Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
        Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
        
        # System controls
        Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
        Key([mod, "control"], "q", lazy.spawn("/home/swany/.config/rofi/power_menu.sh"), desc="Open the rofi power menu"),
        Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
        
        # Application shortcuts
        Key([mod], "m", lazy.spawn("rofi -show drun"), desc="Launch application menu"),
        Key([mod], "b", lazy.spawn("/usr/bin/brave-browser"), desc="Launch browser"),
        Key([mod], "c", lazy.spawn("/usr/bin/code"), desc="Launch code editor"),
        Key([mod], "e", lazy.spawn("/usr/bin/thunar"), desc="Launch file manager"),
        Key([mod], "g", lazy.spawn("github-desktop"), desc="Launch GitHub Desktop"),
        
        # Screenshots
        Key([mod, "shift"], "s", lazy.spawn("scrot '%Y-%m-%d_%H-%M-%S.png' -e 'mv $f /home/swany/Pictures/Screenshots/'"), 
            desc="Take a screenshot and save to /home/swany/Pictures/Screenshots"),
        
        # Screen lock
        Key([mod, "control"], "l", lazy.spawn("i3lock-fancy"), desc="Lock screen"),
        
        # Audio controls
        Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
        Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
        Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
        
        # Brightness controls
        Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
        Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set -10%")),
    ]
    
    # Add VT switching keys for Wayland
    """
    for vt in range(1, 9):
        keys.append(
            Key(
                [mod],
                str(vt),
                lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
                desc=f"Switch to VT{vt}",
            )
        )
    """
    return keys
