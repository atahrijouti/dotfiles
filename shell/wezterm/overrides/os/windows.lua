local M = {}

M.run = function(config)
  config.font_size = 11
  config.default_prog = { "cmd.exe ", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell zsh" }

  local launch_menu = {}

  table.insert(launch_menu, {
    label = "ZSH - MSYS UCRT64",
    args = { "cmd.exe ", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell zsh" },
  })

  table.insert(launch_menu, {
    label = "Clink CMD",
    args = { "cmd.exe ", "/k" },
  })

  config.launch_menu = launch_menu
  return config
end

return M
