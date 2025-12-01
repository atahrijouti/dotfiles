use std 'path add'

const os = $nu.os-info.name
const is_windows = $os == windows
const is_macos = $os == macos
const NU_FOLDER = ($nu.default-config-dir | path join nu)

$env.EDITOR = 'hx'
$env.HELIX_CONFIG = ($env.HOME | path join ".config/helix")

$env.DOTFILES = ($env.DOTFILES? | default "~/source/dotfiles" | path expand -n)
const NU_LIB_DIRS = [ $NU_FOLDER ]
$env.NU_LIB_DIRS ++= $NU_LIB_DIRS

if $is_windows {
  $env.HOME = $env.USERPROFILE
  $env.HELIX_CONFIG = ($env.HOME | path join "AppData/Roaming/helix")
}

if $is_macos {
  $env.HOMEBREW_PREFIX = "/opt/homebrew"
  $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
  $env.HOMEBREW_REPOSITORY = "/opt/homebrew"

  if not ($env.MANPATH? | is-empty) {
      $env.MANPATH = $":($env.MANPATH | str trim --left --char ':')"
  }

  $env.INFOPATH = $"/opt/homebrew/share/info:($env.INFOPATH? | default '')"
  $env.PNPM_HOME = $env.HOME | path join Library/pnpm
  $env.BUN_INSTALL = $env.HOME | path join .bun  
  $env.M2_HOME = $env.HOME | path join Library/programs/maven  
  $env.NODE_EXTRA_CA_CERTS = $env.HOME | path join .certs/cert.pem
  $env.SSL_CERT_FILE = $env.HOME | path join .certs/cert.pem
  $env.CURL_SSL_BACKEND = "secure-transport"

  path add --append /usr/local/bin  
  path add --append /opt/homebrew/bin
  path add --append /opt/homebrew/sbin
  path add --append /Applications/WezTerm.app/Contents/MacOS
  path add --append ($env.HOME | path join "Library/Application Support/JetBrains/Toolbox/scripts")
  path add --append ($env.HOME | path join "Library/programs/bin")
  path add --append ($env.HOME | path join ".bin")
  path add --append ($env.HOME | path join ".local/bin")
  path add --append ($env.HOME | path join "Library/pnpm")
  path add --append ($env.HOME | path join ".cargo/bin")
  path add --append ($env.HOME | path join ".rd/bin")
  path add --append ($env.BUN_INSTALL| path join bin)
  path add --append ($env.HOME | path join "go/bin")
  path add --append ($env.M2_HOME | path join bin)
}

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


use chezmoi
use scripts
