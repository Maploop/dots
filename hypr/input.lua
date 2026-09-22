-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		-- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
		kb_layout = "us",
		kb_options = "grp:alt_shift_toggle,compose:caps",

		-- Increase sensitivity for mouse/trackpad (default: 0).
		sensitivity = 0,

		-- Turn off mouse acceleration (default: adaptive).
		accel_profile = "flat",

		repeat_rate = 40,
		repeat_delay = 250,
		numlock_by_default = true,
	},

	misc = {
		key_press_enables_dpms = true,
		mouse_move_enables_dpms = true,
	},
})

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
