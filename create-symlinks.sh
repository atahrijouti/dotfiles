DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    echo "linking $source -> $target"
    ln -s "$source" "$target"
}

# link
link "shell/.zshrc"                     "$HOME/.zshrc"
link "shell/starship/starship.toml"     "$HOME/.config/starship.toml"
link "shell/wezterm"                    "$HOME/.config/wezterm"
link "ides/nvim"                        "$HOME/.config/nvim"
link "ides/lf"                          "$HOME/.config/lf"
link "ides/helix"                       "$HOME/.config/helix"
link "ides/emacs"                       "$HOME/.emacs.d"