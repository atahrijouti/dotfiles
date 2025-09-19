local M = {}

local wezterm = require("wezterm")
local mux = require("mux")

local act = wezterm.action

M.run = function(config)
  -- CTRL+SHIFT+A
  config.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 10000 }

  config.keys = {
    { key = "9", mods = "ALT", action = wezterm.action_callback(mux.openLazyGitdown()) },
    { key = "1", mods = "ALT", action = wezterm.action_callback(mux.openLfLeft()) },

    --
    -- panes
    --
    { key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitPane({ direction = "Right" }),
    },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "c", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

    -- activate pane
    { key = "h", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Down") },

    -- resize pane
    { key = "H", mods = "SUPER|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "L", mods = "SUPER|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "K", mods = "SUPER|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "J", mods = "SUPER|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "p", mods = "LEADER", action = act.ActivateKeyTable({ name = "pane_selection" }) },

    -- Clipboard
    -- { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    { key = "x", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
    { key = "w", mods = "LEADER", action = wezterm.action.QuickSelect },

    -- Search
    { key = "f", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },

    -- spawn
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.SpawnWindow },

    -- appliation
    { key = "q", mods = "LEADER", action = act.QuitApplication },
    { key = "h", mods = "LEADER", action = act.Hide },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    { key = ",", mods = "LEADER", action = act.ActivateCommandPalette },
    { key = ";", mods = "LEADER", action = act.ShowDebugOverlay },
    {
      key = "l",
      mods = "LEADER",
      action = wezterm.action.ShowLauncherArgs({
        flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|DOMAINS|KEY_ASSIGNMENTS|WORKSPACES|COMMANDS",
      }),
    },
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
  }

  config.key_tables = {
    pane_selection = {
      { key = "s", action = act.PaneSelect },
      { key = "m", action = act.PaneSelect({ mode = "SwapWithActive" }) },
      -- { key = 't', action = act.PaneSelect({ mode = 'MoveToNewTab' }) },
      -- { key = 'w', action = act.PaneSelect({ mode = 'MoveToNewWindow' }) },
    },
  }
end

return M
