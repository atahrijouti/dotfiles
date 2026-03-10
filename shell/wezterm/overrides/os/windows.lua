local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  config.font_size = 11
  config.default_prog = { "nu" }

  local launch_menu = {}

  table.insert(launch_menu, {
    label = "Nushell",
    args = { "nu" },
  })

  table.insert(launch_menu, {
    label = "ZSH - MSYS UCRT64",
    args = { "cmd.exe ", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell zsh" },
  })

  table.insert(launch_menu, {
    label = "Clink CMD",
    args = { "cmd.exe ", "/k" },
  })

  config.launch_menu = launch_menu


  table.insert(config.keys, { key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") })
  table.insert(config.keys, { key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") })
  table.insert(config.keys, { key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") })
  table.insert(config.keys, { key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") })
  table.insert(config.keys, { key = "H", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Left", 1 }) })
  table.insert(config.keys, { key = "L", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Right", 1 }) })
  table.insert(config.keys, { key = "K", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Up", 1 }) })
  table.insert(config.keys, { key = "J", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Down", 1 }) })
  
  return config
end

return M
