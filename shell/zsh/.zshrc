if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fpath=(
        $(brew --prefix)/share/zsh/site-functions
        $(brew --prefix)/share/zsh-completions
        $fpath
    )
fi

# Options
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
unsetopt beep
setopt hist_ignore_all_dups

# Keybindings
bindkey -e
autoload -U select-word-style
select-word-style bash

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Completion
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' menu select

fpath=(
    $HOME/.local/share/zsh/site-functions
    $fpath
)

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

autoload -Uz compinit
compinit

# Starship
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# fzf
[ -x "$(command -v fzf)" ] && source <(fzf --zsh)


# Rbenv
[ -x "$(command -v rbenv)" ] && eval "$(rbenv init - zsh)"

# Jabba
[ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh"

# NVM
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    source $NVM_DIR/nvm.sh
    source "$NVM_DIR/bash_completion"
fi

# Aliases
[ -s "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
