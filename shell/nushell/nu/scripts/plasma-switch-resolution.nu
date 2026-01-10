# kscreen-doctor output.1.mode.3440x1440@144; sleep 1sec; kscreen-doctor output.1.mode.1920x1080@60 output.1.hdr.disable
# kscreen-doctor output.1.mode.3440x1440@60; sleep 1sec; kscreen-doctor output.1.mode.3440x1440@144 output.1.hdr.disable
# kscreen-doctor output.1.mode.3440x1440@60; sleep 1sec; kscreen-doctor output.1.mode.3440x1440@144 output.1.hdr.enable


def modes [] { ["default", "streaming", "default-no-hdr"] }

export def main [mode: string@modes = "default"] {
  let recipe = match $mode {
    "default" => {
      ["output.1.mode.3440x1440@144" "output.1.hdr.enable"]
    },
    "streaming" => {
      ["output.1.mode.1920x1080@60" "output.1.hdr.disable"]
    },
    "default-no-hdr" => {
      ["output.1.mode.3440x1440@144" "output.1.hdr.disable"]
    },
    _ => null
  }

  if $recipe == null {
    print $"No recipe for mode ($mode)"
    return
  }

  kscreen-doctor output.1.mode.3440x1440@60;
  sleep 1sec;
  kscreen-doctor ...$recipe
}

