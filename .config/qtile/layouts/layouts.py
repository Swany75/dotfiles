"""Layout configuration for Qtile."""

from libqtile import layout
from libqtile.config import Match

from settings.constants import colors

def get_layout_config():
    """Return layout configuration dictionary."""
    return {
        'border_focus': colors['cyan'],
        'border_width': 1,
        'margin': 4,
    }

def get_layouts():
    """Return the list of available layouts."""
    layout_conf = get_layout_config()
    
    return [
        layout.MonadTall(**layout_conf),
        layout.MonadWide(**layout_conf),
        layout.Max(),
    ]

def get_floating_layout():
    """Return floating layout configuration."""
    return layout.Floating(
        float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),  # gitk
            Match(wm_class="makebranch"),  # gitk
            Match(wm_class="maketag"),  # gitk
            Match(wm_class="ssh-askpass"),  # ssh-askpass
            Match(title="branchdialog"),  # gitk
            Match(title="pinentry"),  # GPG key password entry
        ],
        border_focus=colors['purple'],
    )