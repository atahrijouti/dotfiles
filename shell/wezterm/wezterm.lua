local wezterm = require("wezterm")
local act = wezterm.action
local helpers = require("helpers")

local config = wezterm.config_builder()

config.color_scheme = helpers.scheme_for_appearance(helpers.get_appearance())

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.line_height = 1.10

config.audible_bell = "Disabled"

config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font_size = 10
	if wezterm.hostname() == "x240" then
		config.font_size = 11
	end
	config.default_prog = { "cmd.exe", "/k" }
end

local cmdKey = "SUPER"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	cmdKey = "CTRL"
end

config.keys = {
	{ key = ",", mods = cmdKey, action = act.ActivateCommandPalette },
	{ key = ";", mods = cmdKey, action = act.ShowDebugOverlay },
	{ key = "c", mods = cmdKey, action = act.CopyTo("Clipboard") },
	{ key = "v", mods = cmdKey, action = act.PasteFrom("Clipboard") },
	{ key = "q", mods = cmdKey, action = act.QuitApplication },
	{ key = "h", mods = cmdKey, action = act.HideApplication },
}

return config
