export EDITOR="hx"
export DOTFILES="$HOME/source/dotfiles"
export BUN_INSTALL="$HOME/.bun"

[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_VERBOSE=1

export NVM_DIR="$HOME/.nvm"


export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$DOTFILES/shell/bin:$PATH"
export PATH="$HOME/programs/bin:$PATH"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

[ -s "$HOME/.site-zshenv.zsh" ] && . "$HOME/.site-zshenv.zsh"
