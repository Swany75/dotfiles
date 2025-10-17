"""Screen configurations for Qtile."""

from libqtile import bar
from libqtile.config import Screen

from bars.widgets import get_bar_widgets

def get_screens():
    """Return the list of screens with their bars."""
    return [
        # Primary screen with systray
        Screen(
            top=bar.Bar(
                get_bar_widgets(include_systray=True),
                24,
            ),
        ),
        # Secondary screen without systray
        #Screen(
        #    top=bar.Bar(
        #        get_bar_widgets(include_systray=False),
        #        24,
        #    ),
        #),
    ]
