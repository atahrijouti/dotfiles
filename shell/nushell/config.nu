use std 'path add'

let os = $nu.os-info.name
let is_windows = $os == windows
let is_macos = $os == macos

if $is_windows {
  $env.HOME = $env.USERPROFILE
}
if $is_macos {
    path add /opt/homebrew/bin /opt/homebrew/sbin

    $env.HOMEBREW_PREFIX = "/opt/homebrew"
    $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
    $env.HOMEBREW_REPOSITORY = "/opt/homebrew"

    if not ($env.MANPATH? | is-empty) {
        $env.MANPATH = $":($env.MANPATH | str trim --left --char ':')"
    }

    $env.INFOPATH = $"/opt/homebrew/share/info:($env.INFOPATH? | default '')"
}

$env.DOTFILES = ($env.DOTFILES? | default "~/source/dotfiles" | path expand -n)
$env.NU_LIB_DIRS ++= [ ($nu.default-config-dir | path join nu) ]

# generate autoload files
if false {
  const autoload_dir = $nu.data-dir | path join vendor autoload
  ^starship init nu | save -f ($autoload_dir | path join "starship.nu")
  ^carapace _carapace nushell | save -f ($autoload_dir | path join "carapace.nu")
  ^mise activate nu | save -f ($autoload_dir | path join mise.nu)
}

###### nu config
$env.PROMPT_INDICATOR_VI_INSERT = "i "
$env.PROMPT_INDICATOR_VI_NORMAL = "y "
$env.TRANSIENT_PROMPT_COMMAND = "∂ "

$env.config.show_banner = false

$env.LS_COLORS = ""
$env.config.table.mode = 'none'

$env.config.highlight_resolved_externals = true
$env.config.color_config.shape_external = "red"
$env.config.color_config.shape_external_resolved = "cyan"


use nu/chezmoi
use nu/aliases.nu *
