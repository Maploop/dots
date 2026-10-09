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

-- Toggle config flags dynamically.
--require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
