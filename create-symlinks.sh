#!/bin/zsh

DOTFILES_DIR=$(dirname -- "$0";)

link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"

    ln -s "$source" "$target"
}

# link
link "shell/.zshrc"                     "$HOME/.zshrc"
link "shell/starship/starship.toml"     "$HOME/.config/starship.toml"
link "shell/wezterm"                    "$HOME/.config/wezterm"
link "ides/nvim"                        "$HOME/.config/nvim"