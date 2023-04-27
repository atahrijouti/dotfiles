#!/bin/zsh

DOTFILES_DIR=$(dirname -- "$0";)

# link
ln -s "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES_DIR/shell/starship/starship.toml" "$HOME/.config/starship.toml"
ln -s "$DOTFILES_DIR/shell/wezterm" "$HOME/.config/wezterm"
ln -s "$DOTFILES_DIR/ides/nvim" "$HOME/.config/nvim"