HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
unsetopt beep
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

setopt hist_ignore_all_dups

# Better word navigation
autoload -U select-word-style
select-word-style bash

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Brew
if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi


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

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ATJ
[ -s "$HOME/.zsh_aliases" ] && \. "$HOME/.zsh_aliases"

