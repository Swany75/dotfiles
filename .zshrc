# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Manual configuration

PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/sbin/

# Load Aliases
[ -f /home/swany/.aliases.zsh ] && source /home/swany/.aliases.zsh

# Inicia l'agent SSH i carrega la clau (async)
{ eval "$(ssh-agent -s)" > /dev/null && ssh-add ~/.ssh/git &> /dev/null } &!

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh

# Fix tecles Home/End amb Kitty
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

### Functions #######################################################################################################################

ZSH_FUNC_DIR="/home/swany/.functions"

# Load _core.zsh immediately (required by other functions)
source "$ZSH_FUNC_DIR/_core.zsh"

# Lazy-load all other functions - they load on first use
for func_file in "$ZSH_FUNC_DIR"/**/*.zsh(N); do
  [[ "$func_file" == *"_core.zsh" ]] && continue
  
  # Extract function names and create lazy loaders
  for func_name in $(grep -oP '^(?:function )?\K[a-zA-Z_][a-zA-Z0-9_]*(?=\s*\(\))' "$func_file" 2>/dev/null); do
    eval "$func_name() { unfunction $func_name 2>/dev/null; source '$func_file'; $func_name \"\$@\"; }"
  done
done
unset func_file func_name

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

ZSH_AUTOSUGGEST_STRATEGY=() 

# Activa l'entorn Python personal
if [[ -d "/home/swany/myenv" ]]; then
  source "/home/swany/myenv/bin/activate"
fi

### NVM Configuration ##################################################### 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm use 22 >/dev/null 2>&1

source /home/swany/Repos/powerlevel10k/powerlevel10k.zsh-theme

# Created by `pipx` on 2025-04-23 09:04:21
export PATH="$PATH:/home/swany/.local/bin"
export PATH=$PATH:~/.npm-global/bin

export NVM_DIR="$HOME/.nvm"
# Lazy load NVM - loads on first use
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize
