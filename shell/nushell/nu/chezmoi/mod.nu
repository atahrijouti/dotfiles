# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export use commands/diff.nu
export use commands/magic.nu
export use commands/resolve-conflicts.nu
export use commands/status.nu
export use commands/sync.nu

## mappings
export use commands/mappings.nu
