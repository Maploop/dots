local wallpaper_dir = os.getenv("HOME") .. "/Pictures/Wallpapers"

-- Wallpaper shown at login (fallback)
local wallpaper = wallpaper_dir .. "/1294900.jpg"

-- Last selected wallpaper.
local wallpaper_cache = os.getenv("HOME") .. "/.cache/current-wallpaper"

-- ---------------------------------------------------------------- autostart

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function launch(command)
	return "uwsm-app -- " .. command
end

hl.env("HYPRCURSOR_THEME", "cz-Hickson-White")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
	-- Slow app launch fix -- set systemd vars before starting session services.
	hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("powerprofilesctl set performance")

	hl.exec_cmd(launch("udiskie --automount --no-tray"))

	-- My desktop: bar, notification daemon, wallpaper, idle manager.
	hl.exec_cmd(launch("waybar"))
	hl.exec_cmd(launch("mako"))

	hl.exec_cmd(
		launch(
			"sh -c 'if [ -f "
				.. shell_quote(wallpaper_cache)
				.. " ]; then "
				.. 'swaybg -i "$(cat '
				.. shell_quote(wallpaper_cache)
				.. ')" -m fill; '
				.. "else "
				.. "swaybg -i "
				.. shell_quote(wallpaper)
				.. " -m fill; "
				.. "fi'"
		)
	)

	hl.exec_cmd(launch("hypridle"))
end)

hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("cycle-wallpaper " .. shell_quote(wallpaper_dir) .. " next"))
hl.bind("SUPER + CTRL + SHIFT + W", hl.dsp.exec_cmd("cycle-wallpaper " .. shell_quote(wallpaper_dir) .. " prev"))
