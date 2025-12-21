#!/bin/zsh

### Manual aliases ##################################################################################################################

# LS
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'

# CAT
alias cat='bat --style=plain --paging=never'

# VIM
alias nvim='/home/swany/.config/nvim/nvim-linux-x86_64.appimage'
alias neovim=nvim
alias nvchad=nvim
alias vim=nvim
alias vi=nvim

# Neofetch
alias neofetch='neofetch --ascii_distro debian'

# Kitty view images
alias kitten='kitty +kitten icat'

# Videogames Aliases
alias escambri='python3 /home/swany/Games/Escambri/main.py'
alias tictactoe='python3 /home/swany/Games/TicTacToe/main.py'

# Pentesting Aliases 
alias rockyou='/usr/share/wordlists/rockyou.txt'

# Zsh 
alias reloadzsh='source ~/.zshrc'

# Obsidian
alias obsidian='obsidian -disable-gpu'
