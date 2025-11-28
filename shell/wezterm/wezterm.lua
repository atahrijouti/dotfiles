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
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  require("overrides.os.linux").run(config)
end
print(wezterm.target_triple)
-- specific machine override
if wezterm.hostname() == "x240" then
  require("overrides.machine.x240").run(config)
end

if wezterm.hostname() == "purple-lake" then
  require("overrides.machine.purple-lake").run(config)
end

if wezterm.hostname() == "Saphire-Tower" then
  require("overrides.machine.saphire-tower").run(config)
end

return config
