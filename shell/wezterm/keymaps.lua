local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  -- CTRL+SHIFT+A
  config.leader = { key = "A", mods = "CTRL", timeout_milliseconds = 10000 }

  config.keys = {
    -- panes
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "c", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

    -- Clipboard
    -- { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    { key = "x", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

    -- Search
    { key = "f", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },

    -- tabs
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

    -- appliation
    { key = "q", mods = "LEADER", action = act.QuitApplication },
    { key = "h", mods = "LEADER", action = act.Hide },
    { key = ",", mods = "LEADER", action = act.ActivateCommandPalette },
    { key = ";", mods = "LEADER", action = act.ShowDebugOverlay },
  }
end

return M
