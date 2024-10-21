local M = {}

M.run = function(config)
  if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
    config.enable_wayland = false
  else
    config.enable_wayland = true
  end

  return config
end

return M
