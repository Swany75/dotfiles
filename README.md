# 🐧 Swany's Linux Dotfiles

A comprehensive collection of Linux configuration files optimized for cybersecurity professionals and power users. This repository contains carefully crafted dotfiles for multiple desktop environments, with a focus on productivity, aesthetics, and security-oriented workflows.

## 🚀 Featured Desktop Environments

### 👾 Bspwm
**Binary Space Partitioning Window Manager** - A fully configured tiling window manager setup

![Bspwm Screenshot](https://github.com/user-attachments/assets/fff0d40c-fd30-4984-a966-3d3641d238eb)

### 🐍 Qtile 
**Python-based Tiling Window Manager** - A modular, Python-powered tiling setup

<img width="1920" height="1080" alt="qtile_desktop" src="https://github.com/user-attachments/assets/0bbdfb1a-f1e8-44da-b945-e7b6d2240f80" />

### 🍃 Cinnamon
*Coming Soon - Traditional desktop environment configuration*

### 🌌 Cosmic
*Coming Soon - Next-generation desktop environment*

## ⚙️ Core Components

### 🐚 Shell Configuration
- **Zsh** with Powerlevel10k theme for enhanced productivity
- **Custom function library** organized into categories:
  - 🔒 **Hacking & Security Tools** - Domain extraction, whois automation, penetration testing utilities
  - 🌐 **Network Utilities** - Advanced network monitoring and management
  - 🔧 **System Administration** - Performance monitoring, system maintenance
  - 📝 **Note Taking & Documentation** - Efficient workflows for security research
  - 🎨 **ASCII Art & Visual Tools** - Terminal eye-candy and information display

### 🎛️ System Tools
- **Polybar** - Feature-rich status bar with custom modules:
  - VPN status monitoring
  - Ethernet connection status
  - "Victim to hack" target tracking
  - Battery and clock widgets
- **Rofi** - Application launcher with custom themes and power menus
- **Neovim** with NvChad configuration for modern development
- **Kitty** terminal emulator with optimized settings
- **Picom** compositor for smooth visual effects

## 🔧 Installation

### Prerequisites
Ensure you have the following packages installed:
```bash
# Arch Linux / Manjaro
sudo pacman -S bspwm sxhkd polybar rofi kitty neovim picom zsh qtile python-psutil

# Ubuntu / Debian
sudo apt install bspwm sxhkd polybar rofi kitty neovim picom zsh qtile python3-psutil

# Python dependencies (for Qtile)
pip install -r requirements.txt
```

### Quick Setup
```bash
# Clone the repository
git clone https://github.com/Swany75/dotfiles.git ~/dotfiles

# Backup your existing configs (recommended)
mkdir ~/dotfiles-backup
cp -r ~/.config ~/dotfiles-backup/
cp ~/.zshrc ~/.p10k.zsh ~/dotfiles-backup/ 2>/dev/null || true

# Deploy configurations
cp -r ~/dotfiles/.config/* ~/.config/
cp ~/dotfiles/.zshrc ~/dotfiles/.p10k.zsh ~/dotfiles/.aliases.zsh ~/

# Install Zsh functions
mkdir -p ~/.functions
cp -r ~/dotfiles/.functions/* ~/.functions/

# Make scripts executable
chmod +x ~/.config/polybar/scripts/*
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/bspwm/bspwmrc
```

### Post-Installation
1. Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for Zsh theme
2. Configure Neovim by running `:PackerInstall` or `:Lazy` (depending on your plugin manager)
3. Set Zsh as your default shell: `chsh -s $(which zsh)`
4. Log out and back in to apply all changes

## 🎯 Cybersecurity Features

This dotfiles collection includes specialized tools for cybersecurity professionals:

- **Target Management**: Polybar integration for tracking current penetration testing targets
- **Network Monitoring**: Real-time VPN and network status indicators  
- **Automation Scripts**: Custom functions for reconnaissance and information gathering
- **Secure Workflows**: Optimized terminal environment for security research

## 📁 Repository Structure

```
dotfiles/
├── .config/
│   ├── bspwm/          # Window manager configuration
│   ├── qtile/          # Python-based window manager setup
│   ├── polybar/        # Status bar with custom scripts
│   ├── rofi/           # Application launcher themes
│   ├── nvim/           # Neovim with NvChad setup
│   ├── kitty/          # Terminal emulator config
│   ├── picom/          # Compositor settings
│   └── neofetch/       # System information display
├── .functions/         # Organized Zsh function library
├── Pictures/
│   └── Wallpapers/     # Desktop wallpapers collection
├── .zshrc             # Main Zsh configuration
├── .p10k.zsh          # Powerlevel10k theme settings
├── .aliases.zsh       # Custom aliases
├── .gitignore         # Git ignore patterns
├── requirements.txt   # Python dependencies
└── root/              # Root user configurations
```

## 🎨 Customization

### Themes & Colors
- Polybar themes are located in `.config/polybar/colors.ini`
- Rofi themes can be found in `.config/rofi/`
- Terminal color schemes are configured in Kitty config

### Adding Custom Functions
Add new functions to the appropriate category in `.functions/`:
```bash
# Example: Add to .functions/my_custom.zsh
function my_function() {
    echo "Custom function for specific workflow"
}
```

## 🙏 Acknowledgments & Resources

### Primary Learning Sources
This configuration was inspired by and built upon excellent tutorials from:
- **[S4vitar](https://hack4u.io/cursos/personalizacion-de-entorno-en-linux/)** - Terminal customization and Bspwm setup for cybersecurity
- **[Antonio Sarosi](https://mastermind.ac/curso/creando-tu-propio-entorno-de-escritorio-en-arch)** - Qtile and general desktop environment configuration

### Community Repositories
- [jorgeloopzz/dotfiles](https://github.com/jorgeloopzz/dotfiles)
- [gh0stzk/dotfiles](https://github.com/gh0stzk/dotfiles)
- [archcraft-os/archcraft](https://github.com/archcraft-os/archcraft)
- [Alpharivs/dotfiles](https://github.com/Alpharivs/dotfiles)
- [antoniosarosi/dotfiles](https://github.com/antoniosarosi/dotfiles)
- [davatorium/rofi-themes](https://github.com/davatorium/rofi-themes)

### Video Tutorials
- [ASÍ es el ENTORNO de un HACKER](https://www.youtube.com/watch?v=fshLf6u8B-w)
- [Configurar ENTORNO PROFESIONAL de HACKING y CIBERSEGURIDAD con Bspwm](https://www.youtube.com/watch?v=7o7JqeToFzg)
- [CONVIERTE TU LINUX EN UN ENTORNO PROFESIONAL DE TRABAJO (2021)](https://www.youtube.com/watch?v=mHLwfI1nHHY)
- [Como instalar y configuar Polybar](https://www.youtube.com/watch?v=mRY5qisOBhk)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

---

**⚡ Happy Hacking!** - *Crafted with ❤️ for the Linux and cybersecurity community*
