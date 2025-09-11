DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    echo "linking $source -> $target"
    ln -s "$source" "$target"
}

# link
link "shell/zsh/.zshrc"                 "$HOME/.zshrc"
link "shell/zsh/.zshenv"                "$HOME/.zshenv"
link "shell/zsh/.zsh_aliases"           "$HOME/.zsh_aliases"
link "shell/starship/starship.toml"     "$HOME/.config/starship.toml"
link "shell/wezterm"                    "$HOME/.config/wezterm"
link "ides/nvim"                        "$HOME/.config/nvim"
link "ides/lf"                          "$HOME/.config/lf"
link "ides/helix"                       "$HOME/.config/helix"
link "ides/zed"                         "$HOME/.config/zed"
link "ides/emacs"                       "$HOME/.emacs.d"
link "ides/yazi/init.lua"               "$HOME/.config/yazi/init.lua" 
link "ides/yazi/keymap.toml"            "$HOME/.config/yazi/keymap.toml" 
link "ides/yazi/yazi.toml"              "$HOME/.config/yazi/yazi.toml" 
