local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font({ family = "Geist Mono", weight = "Medium" })
config.font_size = 16.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 48,
	right = 48,
	top = 48,
	bottom = 48,
}

config.enable_tab_bar = false

return config
