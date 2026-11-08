-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

local home = os.getenv("HOME")

package.path = table.concat({
	home .. "/.config/?.lua",
	home .. "/.config/hypr/?.lua",
	home .. "/.config/hypr/?/init.lua",
	package.path,
}, ";")

pcall(function()
	local xdg = os.getenv("XDG_DATA_HOME")
	local base = (xdg ~= nil and xdg ~= "") and xdg or ((os.getenv("HOME") or "") .. "/.local/share")
	dofile(base .. "/quickshell/qs-monitors.lua")
end)

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})

hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},
	no_anim = true,
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- App rules
require("hypr.apps.steam")
require("hypr.apps.pavucontrol")
require("hypr.apps.jetbrains")
require("hypr.apps.localsend")
require("hypr.apps.telegram")
require("hypr.apps.bitwarden")
require("hypr.apps.xwaylandapps")
require("hypr.apps.mpv")
require("hypr.apps.spotify")

-- Toggle config flags dynamically.
--require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- For Noctalia Color templates
require("noctalia").apply_theme()
