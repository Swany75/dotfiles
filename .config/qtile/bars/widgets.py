"""Widget configurations for Qtile bars."""

from libqtile import widget, qtile
from settings.constants import colors, HOSTNAME, IP

def get_bar_widgets(include_systray=True):
    """Return the list of widgets for the bar."""
    widgets = [
        # Qtile Button #############################################################
        widget.TextBox(
            text='   ',
            font='Hack Nerd Font',
            background=colors['amstrad_dark'],
            foreground=colors['cyan'],
            fontsize=16,
            padding=0,
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('rofi -show drun')},
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['dark'],
            foreground=colors['amstrad_dark'],
            padding=0,
            fontsize=23,
        ),
        widget.Sep(
            linewidth=0,
            padding=175,  # Adjust this value to change the distance
            background=colors['dark'],
        ),
        ### Workspace Switcher #####################################################
        widget.GroupBox(
            foreground=colors['light'],
            background=colors['dark'],
            font='Hack Nerd Font',
            fontsize = 16,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            border_width=1,
            active=colors['yellow_spyro1'],
            inactive=colors['white'],
            rounded=False,
            highlight_method='block',
            this_current_screen_border=colors['purple_spyro1'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
        ),

    ]
    widgets.append(widget.Spacer(background=colors['dark']))

    # Add systray only to the first screen
    if include_systray:
        widgets.append(
            widget.Systray( 
                background=colors['dark'],
                foreground=colors['dark'],
            )
        )
    
    # Continue with the rest of the widgets
    
    # Spacer to push widgets to the right

    ### Info Widgets ####################################################
    widgets.extend([
        widget.TextBox(
            text=' ',
            font='Hack Nerd Font',
            background=colors['dark'],
            foreground=colors['amstrad_blue'],
            padding=0,
            fontsize=42,
        ),
        widget.TextBox(
            text=f"{HOSTNAME} ",
            font='Hack Nerd Font',
            background=colors['amstrad_blue'], 
            foreground=colors['white']
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_blue'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_blue'],
            foreground=colors['amstrad_green'],
            padding=0,
            fontsize=42,
        ),
        widget.TextBox(
            text=f"{IP} ",
            font='Hack Nerd Font',
                background=colors['amstrad_green'], 
                foreground=colors['white']
            ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_green'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_green'],
            foreground=colors['amstrad_grey'],
            padding=0,
            fontsize=42,
        ),
        widget.KeyboardLayout(
            configured_keyboards=['es', 'ca'],
            foreground=colors['white'],
            background=colors['amstrad_grey'],
        ),
        widget.Sep(
            linewidth=0,
            padding=7,
            background=colors['amstrad_grey'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_grey'],
            foreground=colors['amstrad_dark'],
            padding=0,
            fontsize=30,
        ),
        widget.Battery(
            format=' {char} {percent:2.0%} {hour:d}:{min:02d} ',
            charge_char='󰂄',  # Charging icon
            discharge_char='󰁹',  # Battery icon
            empty_char='󰂎',  # Empty battery
            full_char='󰁹',  # Full battery
            unknown_char='󰂑',  # Unknown status
            
            # Color coding based on battery level
            low_percentage=0.15,
            low_foreground='#ff5555',  # Red for low battery
            low_background=None,
            
            # Styling
            foreground=colors['light'],  # Purple/blue color
            background=colors['amstrad_grey'],

            # Behavior
            update_interval=30,
            notify_below=15,  # Desktop notification when below 15%
            
            # Display options
            show_short_text=False,
            hide_threshold=None,  # Set to a value like 0.99 to hide when nearly full
            
            # Font
            fontsize=14,
            font='Hack Nerd Font',
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_grey'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_grey'],
            foreground=colors['amstrad_dark'],
            padding=0,
            fontsize=30,
        ),
        widget.DF(
            format="  {r:.1f} GB",
            visible_on_warn=False,
            partition="/",
            warn_space=10,
            update_interval=60,
            font='Hack Nerd Font',
            foreground=colors['white'],
            background=colors['amstrad_grey'],
            warn_color=colors['white'],
            padding=5,
            scale=0.5
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_grey'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_grey'],
            foreground=colors['amstrad_dark'],
            padding=0,
            fontsize=30,
        ),
        widget.CurrentLayout(
            background=colors['amstrad_grey'],
            foreground=colors['white'],
            padding=5,
        ),
        widget.CurrentLayoutIcon(
            background=colors['amstrad_grey'],
            foreground=colors['white'],
            scale=0.55,
            padding=5,
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_grey'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_grey'],
            foreground=colors['amstrad_green'],
            padding=0,
            fontsize=42,
        ),
        widget.Clock(
            background=colors['amstrad_green'],
            foreground=colors['white'],
            font='Hack Nerd Font',
            format='  %d/%m/%Y - %H:%M',
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_green'],
        ),
        widget.TextBox(
            text='',
            font='Hack Nerd Font',
            background=colors['amstrad_green'],
            foreground=colors['amstrad_red'],
            padding=0,
            fontsize=42,
        ),
        widget.TextBox(
            text=" ",
            fontsize=16,
            font='Hack Nerd Font',
            background=colors['amstrad_red'],
            foreground=colors['white'],
            padding=0,
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('/home/swany/.config/rofi/power_menu.sh')},
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
            background=colors['amstrad_red'],
        ),

    ])

    return widgets
