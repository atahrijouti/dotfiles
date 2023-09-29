local wezterm = require("wezterm")

local M = {}

M.openLazyGitdown = function()
  return M.toggleProgramInPaneSplit({ program = "lazygit" })
end

M.openLfLeft = function()
  return M.toggleProgramInPaneSplit({ program = "lf", direction = "Left", size = 0.2 })
end

M.toggleProgramInPaneSplit = function(o)
  return function(window, _pane)
    local panes = window:mux_window():active_tab():panes()

    local targetPane = nil

    for _, pane in ipairs(panes) do
      local title = pane:get_title():gsub("C:\\Windows\\system32\\cmd.exe%s+-%s", "")
      -- local paneId = pane:pane_id()
      if title:match(nocase(o.program)) then
        targetPane = pane
      end
    end

    if targetPane then
      targetPane:activate()
      window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, targetPane)
      return
    else
      targetPane = _pane:split({ direction = o.direction and o.direction or "Bottom", size = o.size and o.size or 0.5 })
      targetPane:send_paste(o.program .. "\n")
    end
  end
end

return M
