#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="/home/atj/source/dotfiles"

copy() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"

    # If target is a symlink, remove it
    if [ -L "$target" ]; then
        echo "removing symlink $target"
        rm "$target"
    fi

    # Ensure parent dir exists
    mkdir -p "$(dirname "$target")"

    echo "copying $source -> $target"
    cp -r "$source" "$target"
}

# copy instead of link

copy  "shell/starship/starship.toml" "$HOME/.config/starship.toml"
copy  "shell/wezterm" "$HOME/.config/wezterm"
copy  "ides/lf" "$HOME/.config/lf"
copy  "ides/helix" "$HOME/.config/helix"
copy  "ides/zed" "$HOME/.config/zed"
copy  "ides/yazi/init.lua" "$HOME/.config/yazi/init.lua"
copy  "ides/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
copy  "ides/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
copy  "shell/zsh/.zshenv" "$HOME/.zshenv"
copy  "shell/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
copy  "ides/emacs" "$HOME/.emacs.d"
copy  "shell/zsh/.zshrc" "$HOME/.zshrc"
