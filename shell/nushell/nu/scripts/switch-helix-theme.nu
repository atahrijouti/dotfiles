#!/usr/bin/env nu

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

  mut c = try {
     open $"($env.HELIX_CONFIG)/themes/site-theme.toml"
  }

  $c.inherits = $hx_theme

  try {
    $c | save -f $"($env.HELIX_CONFIG)/themes/site-theme.toml"
  }

}


