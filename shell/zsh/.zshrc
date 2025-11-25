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
    $HOME/.zfunc
    $fpath
)

source "$HOME/.zplug/init.zsh"

zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    fpath=(
        $(brew --prefix)/share/zsh/site-functions
        $(brew --prefix)/share/zsh-completions
        $fpath
    )
fi

autoload -Uz compinit
compinit -C

# Starship
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
 
# fzf
[ -x "$(command -v fzf)" ] && source <(fzf --zsh)

# Rbenv
# [ -x "$(command -v rbenv)" ] && eval "$(rbenv init - zsh)"

# SKMan
# [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# NVM
# if [ -s "$HOME/.nvm/nvm.sh" ]; then
#     export NVM_DIR="$HOME/.nvm"
#     source $NVM_DIR/nvm.sh
#     source "$NVM_DIR/bash_completion"
# fi

# Mise
[ -s "$HOME/.local/bin/mise" ] && eval "$($HOME/.local/bin/mise activate zsh)"

if [ -d "$HOME/Applications/Emacs.app/Contents/MacOS/bin" ]; then
  export PATH="$HOME/Applications/Emacs.app/Contents/MacOS/bin:$PATH"
fi

# Aliases
[ -s "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"



