# generate autoload files
# const autoload_dir = $nu.data-dir | path join vendor autoload
# starship init nu | save -f ($autoload_dir | path join "starship.nu")
# carapace _carapace nushell | save -f ($autoload_dir | path join "carapace.nu")

$env.PROMPT_INDICATOR_VI_INSERT = "i "
$env.PROMPT_INDICATOR_VI_NORMAL = "y "
$env.TRANSIENT_PROMPT_COMMAND = "∂ "

$env.config.show_banner = false

$env.LS_COLORS = ""
$env.config.table.mode = 'none'


# aliases
def --env --wrapped lfcd [...args: string] { 
  cd (lf -print-last-dir ...$args)
}

alias l = lfcd
alias lg = lazygit

