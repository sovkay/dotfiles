local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font configuration
config.font = wezterm.font("Monaspace Argon")
config.font_size = 15.0
config.font_rules = {
	{ intensity = "Bold", font = wezterm.font("Monaspace Argon", { weight = "Bold" }) },
	{ italic = true, font = wezterm.font("Monaspace Argon", { style = "Italic" }) },
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("Monaspace Argon", { weight = "Bold", style = "Italic" }),
	},
}

-- Shell
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

-- Window appearance
config.window_padding = { left = 16, right = 16, top = 16, bottom = 0 }
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.98
config.macos_window_background_blur = 32

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = 2.0
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Bell
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 0,
	fade_out_duration_ms = 0,
}

-- macOS specific
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Performance
config.max_fps = 120
config.animation_fps = 60

-- Tokyo Night color scheme
config.colors = {
	foreground = "#c0caf5",
	background = "#1a1b26",
	cursor_fg = "#1a1b26",
	cursor_bg = "#c0caf5",
	cursor_border = "#c0caf5",
	selection_fg = "#c0caf5",
	selection_bg = "#33467c",

	ansi = {
		"#15161e", -- black
		"#f7768e", -- red
		"#9ece6a", -- green
		"#e0af68", -- yellow
		"#7aa2f7", -- blue
		"#bb9af7", -- magenta
		"#7dcfff", -- cyan
		"#a9b1d6", -- white
	},
	brights = {
		"#414868", -- bright black
		"#f7768e", -- bright red
		"#9ece6a", -- bright green
		"#e0af68", -- bright yellow
		"#7aa2f7", -- bright blue
		"#bb9af7", -- bright magenta
		"#7dcfff", -- bright cyan
		"#c0caf5", -- bright white
	},

	tab_bar = {
		background = "#15161e",
		active_tab = { bg_color = "#1a1b26", fg_color = "#7aa2f7" },
		inactive_tab = { bg_color = "#1a1b26", fg_color = "#545c7e" },
		inactive_tab_hover = { bg_color = "#1a1b26", fg_color = "#7aa2f7" },
		new_tab = { bg_color = "#15161e", fg_color = "#545c7e" },
		new_tab_hover = { bg_color = "#1a1b26", fg_color = "#7aa2f7" },
	},
}

-- Keybindings
config.keys = {
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "CMD", action = wezterm.action.ActivateTab(8) },
	{ key = "]", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "[", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") },
}

return config
