# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

"""
Qtile Configuration - Modular Structure

This is the main configuration file that imports all the modular components.
The configuration is organized into the following modules:

- settings/: Constants, colors, and configuration variables
- keybindings/: Key binding configurations  
- groups/: Workspace/group configurations
- layouts/: Window layout configurations
- bars/: Status bar and widget configurations
- hooks/: Startup hooks and scripts
"""

# Core imports from individual modules
from settings.constants import widget_defaults, mod, terminal
from settings.mouse import get_mouse

from keybindings.keys import get_keys
from groups.workspaces import get_groups, get_group_keys
from layouts.layouts import get_layouts, get_floating_layout
from bars.screens import get_screens

# Import hooks (this registers the startup hook)
import hooks.startup

# Main configuration variables
keys = get_keys()
groups = get_groups()

# Add group switching keys to the keys list
keys.extend(get_group_keys(groups))

# Layout configuration
layouts = get_layouts()
floating_layout = get_floating_layout()

# Widget defaults (imported from settings)
extension_defaults = widget_defaults.copy()

# Screen configuration
screens = get_screens()

# Mouse configuration
mouse = get_mouse()

# General configuration
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

# Wayland backend configuration
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24

# Java applications compatibility
wmname = "LG3D"
