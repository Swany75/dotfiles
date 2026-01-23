# Qtile Configuration - Modular Structure

This Qtile configuration has been organized into separate modules for better maintainability and readability.

## Directory Structure

```
qtile/
├── config.py                 # Main configuration file
├── config.py.backup          # Backup of original monolithic config
├── autostart.sh              # Autostart script
├── settings/                 # Configuration constants and variables
│   ├── __init__.py
│   ├── constants.py          # Colors, system info, widget defaults
│   └── mouse.py              # Mouse configuration
├── keybindings/              # Key binding configurations
│   ├── __init__.py
│   └── keys.py               # All key bindings
├── groups/                   # Workspace/group configurations
│   ├── __init__.py
│   └── workspaces.py         # Group definitions and key bindings
├── layouts/                  # Window layout configurations
│   ├── __init__.py
│   └── layouts.py            # Layout definitions and floating rules
├── bars/                     # Status bar and widget configurations
│   ├── __init__.py
│   ├── widgets.py            # Widget definitions and helper functions
│   └── screens.py            # Screen configurations
└── hooks/                    # Startup hooks and scripts
    ├── __init__.py
    └── startup.py            # Startup hooks
```

## Module Descriptions

### settings/
Contains all constants, color schemes, and configuration variables:
- **constants.py**: System information (hostname, IP), color scheme, widget defaults
- **mouse.py**: Mouse drag and click configurations

### keybindings/
Contains all key binding configurations:
- **keys.py**: Window navigation, layout controls, application shortcuts, hardware controls

### groups/
Contains workspace/group configurations:
- **workspaces.py**: Group definitions with icons and key bindings for switching

### layouts/
Contains window layout configurations:
- **layouts.py**: Layout definitions (MonadTall, MonadWide, Max) and floating window rules

### bars/
Contains status bar and widget configurations:
- **widgets.py**: Widget definitions, helper functions for separators and powerline arrows
- **screens.py**: Screen configurations with different bars for primary/secondary screens

### hooks/
Contains startup hooks and scripts:
- **startup.py**: Autostart hook that runs the autostart.sh script

## Benefits of This Structure

1. **Maintainability**: Each module focuses on a specific aspect of the configuration
2. **Reusability**: Modules can be easily shared between different configurations
3. **Readability**: Smaller, focused files are easier to understand and modify
4. **Modularity**: Changes to one aspect (e.g., colors) are isolated to specific files
5. **Extensibility**: New features can be added as new modules without cluttering the main config

## How to Modify

- **Change colors**: Edit `settings/constants.py`
- **Add/modify key bindings**: Edit `keybindings/keys.py`
- **Change workspaces**: Edit `groups/workspaces.py`
- **Modify layouts**: Edit `layouts/layouts.py`
- **Customize bar**: Edit `bars/widgets.py` or `bars/screens.py`
- **Add startup programs**: Edit `hooks/startup.py` or `autostart.sh`

## Backup

Your original configuration has been backed up as `config.py.backup` and can be restored if needed.

## Testing

After making changes, you can reload the configuration with `Mod + Control + R` or restart Qtile to test your modifications.