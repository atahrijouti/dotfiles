local wezterm = require("wezterm")

local M = {}

M.openLazyGitdown = function()
  return M.toggleProgramInPaneSplit({ program = "lazygit" })
end

M.openLfLeft = function()
  return M.toggleProgramInPaneSplit({ program = "lf", direction = "Left", size = 0.2 })
end

local getTargetProgramPaneDict = function(pane)
  local tab = pane:tab()
  local tabId = tab:tab_id() .. ""
  local window = tab:window()
  local windowId = window:window_id() .. ""

  if wezterm.GLOBAL.targetPane == nil then
    wezterm.GLOBAL.targetPane = {}
  end
  if wezterm.GLOBAL.targetPane[windowId] == nil then
    wezterm.GLOBAL.targetPane[windowId] = {}
  end
  if wezterm.GLOBAL.targetPane[windowId][tabId] == nil then
    wezterm.GLOBAL.targetPane[windowId][tabId] = {}
  end

  return wezterm.GLOBAL.targetPane[windowId][tabId]
end

---@param o {program: string, direction?: string, size?: number}
M.toggleProgramInPaneSplit = function(o)
  return function(window, pane)
    local targetDict = getTargetProgramPaneDict(pane)
    local programPaneId = targetDict[o.program]

    if programPaneId then
      local programPane = wezterm.mux.get_pane(programPaneId)
      programPane:activate()
      window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, programPane)
      targetDict[o.program] = nil
    else
      local newPane = pane:split({
        direction = o.direction and o.direction or "Bottom", size = o.size and o.size or 0.5
      })
      newPane:send_paste(o.program .. "\n")
      targetDict[o.program] = newPane:pane_id()
    end
  end
end

return M
