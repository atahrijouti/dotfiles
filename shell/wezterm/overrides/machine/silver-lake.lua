local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(config.keys, { key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") })
    table.insert(config.keys, { key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") })
    table.insert(config.keys, { key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") })
    table.insert(config.keys, { key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") })
    table.insert(config.keys, { key = "H", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Left", 1 }) })
    table.insert(config.keys, { key = "L", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Right", 1 }) })
    table.insert(config.keys, { key = "K", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Up", 1 }) })
    table.insert(config.keys, { key = "J", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Down", 1 }) })
  end

  return config
end

return M
