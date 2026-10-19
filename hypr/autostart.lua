local cursor_theme = "macOS"

hl.env("HYPRCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_THEME", cursor_theme)
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("XCURSOR_SIZE", 24)

hl.on("hyprland.start", function()
	-- Slow app launch fix -- set systemd vars before starting session services.
	hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("powerprofilesctl set performance")

	hl.exec_cmd("qs")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hyprctl setcursor " .. cursor_theme .. " 24")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. cursor_theme .. "''")
	hl.exec_cmd("cp -r ~/.local/share/icons/" .. cursor_theme .. " ~/.local/share/icons/default")
	hl.exec_cmd("hypridle")
end)
