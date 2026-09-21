local wallpaper_dir = os.getenv("HOME") .. "/Pictures/Wallpapers"

-- Wallpaper shown at login (fallback)
local wallpaper = wallpaper_dir .. "/1294900.jpg"

-- Last selected wallpaper.
local wallpaper_cache = os.getenv("HOME") .. "/.cache/current-wallpaper"

-- ---------------------------------------------------------------- autostart

hl.env("HYPRCURSOR_THEME", "cz-Hickson-White")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
	-- Slow app launch fix -- set systemd vars before starting session services.
	hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")

	-- Omarchy session services worth keeping (these are not the Quickshell shell).
	hl.exec_cmd("omarchy-provision-first-run")
	hl.exec_cmd("omarchy-powerprofiles-init")
	hl.exec_cmd(o.launch("omarchy-hyprland-monitor-watch"))
	hl.exec_cmd(o.launch("udiskie --automount --no-notify --no-tray"))

	-- My desktop: bar, notification daemon, wallpaper, idle manager.
	hl.exec_cmd(o.launch("waybar"))
	hl.exec_cmd(o.launch("mako"))

	hl.exec_cmd(
		o.launch(
			"sh -c 'if [ -f "
				.. o.shell_quote(wallpaper_cache)
				.. " ]; then "
				.. 'swaybg -i "$(cat '
				.. o.shell_quote(wallpaper_cache)
				.. ')" -m fill; '
				.. "else "
				.. "swaybg -i "
				.. o.shell_quote(wallpaper)
				.. " -m fill; "
				.. "fi'"
		)
	)

	hl.exec_cmd(o.launch("hypridle"))

	-- Run post-boot hooks after startup config has loaded.
	hl.exec_cmd("sleep 2 && omarchy-hook post-boot")
end)

o.bind("SUPER + CTRL + W", "Next wallpaper", "cycle-wallpaper " .. o.shell_quote(wallpaper_dir) .. " next")
o.bind("SUPER + CTRL + SHIFT + W", "Previous wallpaper", "cycle-wallpaper " .. o.shell_quote(wallpaper_dir) .. " prev")
