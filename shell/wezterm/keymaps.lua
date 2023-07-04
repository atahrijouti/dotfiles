local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  -- CTRL+SHIFT+A
  config.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 10000 }

  config.keys = {
    --
    -- panes
    --
    { key = "-", mods = "LEADER",    action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
    { key = "c", mods = "LEADER",    action = act.CloseCurrentPane({ confirm = true }) },
    -- activate pane
    { key = 'h', mods = "SUPER|ALT", action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = "SUPER|ALT", action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = "SUPER|ALT", action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = "SUPER|ALT", action = act.ActivatePaneDirection 'Down' },
    -- resize pane
    { key = 'H', mods = "SUPER|ALT", action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'L', mods = "SUPER|ALT", action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'K', mods = "SUPER|ALT", action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'J', mods = "SUPER|ALT", action = act.AdjustPaneSize { 'Down', 1 } },
    -- Clipboard
    -- { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL",      action = act.PasteFrom("Clipboard") },
    { key = "x", mods = "LEADER",    action = wezterm.action.ActivateCopyMode },

    -- Search
    { key = "f", mods = "LEADER",    action = act.Search("CurrentSelectionOrEmptyString") },

    -- tabs
    { key = "t", mods = "LEADER",    action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "LEADER",    action = act.CloseCurrentTab({ confirm = true }) },

    -- appliation
    { key = "q", mods = "LEADER",    action = act.QuitApplication },
    { key = "h", mods = "LEADER",    action = act.Hide },
    { key = ",", mods = "LEADER",    action = act.ActivateCommandPalette },
    { key = ";", mods = "LEADER",    action = act.ShowDebugOverlay },
    { key = "n", mods = "LEADER",    action = act.SpawnWindow },

  }

  config.key_tables = {
    activate_pane = {
      { key = 'h',     action = act.ActivatePaneDirection 'Left' },
      { key = 'l',     action = act.ActivatePaneDirection 'Right' },
      { key = 'k',     action = act.ActivatePaneDirection 'Up' },
      { key = 'j',     action = act.ActivatePaneDirection 'Down' },
      { key = 'Enter', action = 'PopKeyTable' },
    },
  }
end

return M
