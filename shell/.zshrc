HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
unsetopt beep
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

autoload -Uz compinit
compinit

# Brew
[ -s "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Starship
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

# Rbenv
[ -x "$(command -v rbenv)" ] && eval "$(rbenv init - zsh)"

# Jabba
[ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh"

# NVM
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    . $NVM_DIR/nvm.sh
    . "$NVM_DIR/bash_completion"
fi

[ -s "$HOME/.zsh_aliases" ] && \. "$HOME/.zsh_aliases"

# Better word navigation
autoload -U select-word-style
select-word-style bash
