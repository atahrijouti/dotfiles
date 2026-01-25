def --env --wrapped lfcd [...args: string] {
  cd (lf -print-last-dir ...$args)
}

export alias l = lfcd
export alias lg = lazygit
export alias 'g h' = cd ~
export alias 'g d' = cd ~/source/dotfiles
export alias 'g p' = cd ~/playground/
export alias 'g t' = cd ~/playground/clone-tris
export alias 'g c' = cd $nu.default-config-dir

# apps
export alias ffmpeg = ^ffmpeg -hide_banner
export alias ffprobe = ^ffprobe -hide_banner
