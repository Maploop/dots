-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
local colors = require("colors")
-- old border; AB6BFF
hl.config({
	general = {
		layout = "dwindle",
		gaps_in = 3,
		gaps_out = 6,
		border_size = 2,
		col = {
			active_border = colors.fg,
			inactive_border = colors.border,
		},
		resize_on_border = false,
		allow_tearing = false,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		focus_on_activate = true,
		anr_missed_pings = 3,
		on_focus_under_fullscreen = 1,
		initial_workspace_tracking = 0,
		allow_session_lock_restore = true,
	},
	cursor = {
		hide_on_key_press = false,
		warp_on_change_workspace = false,
	},
	binds = {
		hide_special_on_workspace_change = true,
	},
	decoration = {
		rounding = 0,
		rounding_power = 2,

		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			vibrancy = 0.0,
		},

		-- Use theme default
		active_opacity = 0.98,
		inactive_opacity = 0.92,
		fullscreen_opacity = 1.0,
	},
	group = {
		groupbar = {
			font_size = 12,
			font_family = "Adawaita Mono Nerd Font",
			font_weight_active = "ultraheavy",
			font_weight_inactive = "normal",
			indicator_height = 1,
			indicator_gap = 5,
			height = 22,
			gaps_in = 5,
			gaps_out = 0,
			text_color = "rgb(ffffff)",
			text_color_inactive = "rgba(ffffff90)",
			col = {
				active = "rgba(00000040)",
				inactive = "rgba(00000020)",
			},
			gradients = true,
			gradient_rounding = 0,
			gradient_round_only_edges = false,
		},
	},
})

hl.layer_rule({
	name = "qs-bar-glass",
	match = { namespace = "qs-bar" },
	blur = true,
	ignore_alpha = 0.1,
})

hl.layer_rule({
	name = "qs-picker-order",
	match = { namespace = "qs-screenshot-picker" },
	order = 10,
})

hl.layer_rule({
	name = "qs-notifications-order",
	match = { namespace = "qs-notifications" },
	order = 20,
})

hl.window_rule({
	name = "float-transparency",
	match = { float = true },
	opacity = "0.85 override 0.85 override",
})

hl.curve("calm", {
	type = "bezier",
	points = {
		{ 0.25, 0.9 },
		{ 0.35, 1.0 },
	},
})

hl.curve("smoothOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.curve("smooth", { type = "bezier", points = { { 0.22, 1 }, { 0.1, 1.1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0.85 }, { 0.25, 1.0 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.08 } } })
hl.curve("linearish", { type = "bezier", points = { { 0.3, 0.0 }, { 0.7, 1.0 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "smooth", style = "popin 95%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "smooth", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "quick", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "quick" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "smooth", style = "slidefade 5%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "smooth", style = "slidefadevert 5%" })

hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "quick", style = "popin 95%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "quick", style = "popin 95%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "linearish" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "linearish" })

hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "smooth" })
