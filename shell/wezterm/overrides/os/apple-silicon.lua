local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  table.insert(config.keys, { key = "q", mods = "CMD", action = act.QuitApplication })
  table.insert(config.keys, { key = "h", mods = "CMD", action = act.HideApplication })
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })

  local launch_menu = {}
  table.insert(launch_menu, {
    label = "Nushell",
    args = { "/opt/homebrew/bin/nu" },
  })
  config.launch_menu = launch_menu

  config.default_prog = { "/opt/homebrew/bin/nu" }

  return config
end

return M
