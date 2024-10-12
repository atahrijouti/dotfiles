export EDITOR="hx"
export DOTFILES="$HOME/source/dotfiles"

export HELIX_RUNTIME="$HOME/source/helix/runtime"

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/go/bin:$PATH"
export PATH="$DOTFILES/shell/bin:$PATH"
export PATH="$HOME/programs/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
