local M = {}

M.run = function(config)
  config.font_size = 10
  config.default_prog = { "cmd.exe", "/k" }
  return config
end

return M
