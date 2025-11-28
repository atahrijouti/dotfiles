const STATE_FILE = $"($nu.cache-dir)/system-theme.nuon" | path expand

def themes [] { ["light", "dark"] }

export def main [theme: string@themes] {
  let hx_theme = match $theme {
    "light" => "my_jetbrains_cyan_light"
    "dark" => "my_jetbrains_dark"
    _ => null
  }

  if ($hx_theme | is-empty) {
    print "Accepted values are : light / dark"
    return
  }

  mut state = (load-state)
  if $state.theme? == $theme {
    print $"Theme is already ($theme), skipping"
    return
  }

  mut c = try {
     open $"($env.HELIX_CONFIG)/themes/site-theme.toml"
  }

  $c.inherits = $hx_theme

  try {
    $c | save -f $"($env.HELIX_CONFIG)/themes/site-theme.toml"
  }

  $state.theme = $theme

  save-state $state
}

def load-state [] {
  if not ($STATE_FILE | path exists) { return {} }
  open $STATE_FILE
}

export def save-state [state: record] {
  let state_dir = $STATE_FILE | path dirname
  if not ($state_dir | path exists) { mkdir $state_dir }
  $state | save -f $STATE_FILE
}
