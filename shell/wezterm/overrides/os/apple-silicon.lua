local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  table.insert(config.keys, { key = "q", mods = "CMD", action = act.QuitApplication })
  table.insert(config.keys, { key = "h", mods = "CMD", action = act.HideApplication })
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  return config
end

return M
