# Shell
set -o emacs

# Oh-My-Zsh
export ZSH="/Users/atahrijouti/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-lazyload)
source $ZSH/oh-my-zsh.sh

# Starship Prompt
eval "$(starship init zsh)"

# Lazy Load

# Homebrew
lazy_load_brew() {
    if type brew &>/dev/null
    then
        FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

        autoload -Uz compinit
        compinit
    fi
}
lazyload brew -- lazy_load_brew


# Rbenv
lazy_load_rbenv() {
    eval "$(rbenv init - zsh)"
}
lazyload rbenv -- lazy_load_rbenv

# SDKMan
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Jabba
lazy_load_jabba() {
    [ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh"
}
lazyload jabba -- lazy_load_jabba
# Lazy Load end

# NVM
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    . $NVM_DIR/nvm.sh
    . "$NVM_DIR/bash_completion"
fi

# Lf

lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
alias lf=lfcd

#aliases
alias ls="ls -F --color"
alias love="/Applications/love.app/Contents/MacOS/love"



source "$HOME/.work_zshrc"
