local wezterm = require("wezterm")
local keymaps = require("keymaps")
local options = require("options")

local config = wezterm.config_builder()

options.run(config)
keymaps.run(config)

-- operating system overrides
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  require("overrides.os.windows").run(config)
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  require("overrides.os.apple-silicon").run(config)
end

-- specific machine override
if wezterm.hostname() == "x240" then
  require("overrides.machine.x240").run(config)
end

return config
