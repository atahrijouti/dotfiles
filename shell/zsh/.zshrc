HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
unsetopt beep
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Starship
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

[ -x "$(command -v rbenv)" ] && eval "$(rbenv init - zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

[ -s "$HOME/.zsh_aliases" ] && \. "$HOME/.zsh_aliases"

# Better word navigation
autoload -U select-word-style
select-word-style bash
