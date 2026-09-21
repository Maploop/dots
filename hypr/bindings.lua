local mainMod = "SUPER"

o.bind(mainMod .. " + Q", "Close window", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")

o.bind(mainMod .. " + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind(mainMod .. " + P", "Pseudo window", hl.dsp.window.pseudo())
o.bind(mainMod .. " + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind(mainMod .. " + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind(mainMod .. " + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
o.bind(mainMod .. " + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind(mainMod .. " + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
o.bind(mainMod .. " + ALT + Home", "Save window width", "omarchy-hyprland-window-width save")
o.bind(mainMod .. " + Home", "Restore window width", "omarchy-hyprland-window-width restore")
o.bind(mainMod .. " + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind(mainMod .. " + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind(mainMod .. " + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind(mainMod .. " + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind(mainMod .. " + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	o.bind(mainMod .. " + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
	o.bind(
		mainMod .. " + SHIFT + " .. key,
		"Move window to workspace " .. workspace,
		hl.dsp.window.move({ workspace = tostring(workspace) })
	)
	o.bind(
		mainMod .. " + SHIFT + ALT + " .. key,
		"Move window silently to workspace " .. workspace,
		hl.dsp.window.move({ workspace = tostring(workspace), follow = false })
	)
end

o.bind(mainMod .. " + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind(
	mainMod .. " + ALT + S",
	"Move window to scratchpad",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

o.bind(mainMod .. " + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind(mainMod .. " + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind(mainMod .. " + CTRL + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous" }))

o.bind(mainMod .. " + SHIFT + ALT + LEFT", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind(mainMod .. " + SHIFT + ALT + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind(mainMod .. " + SHIFT + ALT + UP", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind(mainMod .. " + SHIFT + ALT + DOWN", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

o.bind(mainMod .. " + SHIFT + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind(mainMod .. " + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind(mainMod .. " + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind(mainMod .. " + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

o.bind("CTRL + ALT + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("CTRL + ALT + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

o.bind(mainMod .. " + code:20", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind(mainMod .. " + code:21", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind(mainMod .. " + SHIFT + code:20", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind(mainMod .. " + SHIFT + code:21", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

o.bind(
	mainMod .. " + ALT + code:20",
	"Expand window left a little",
	hl.dsp.window.resize({ x = -25, y = 0, relative = true })
)
o.bind(mainMod .. " + ALT + code:21", "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
o.bind(
	mainMod .. " + SHIFT + ALT + code:20",
	"Shrink window up a little",
	hl.dsp.window.resize({ x = 0, y = -25, relative = true })
)
o.bind(
	mainMod .. " + SHIFT + ALT + code:21",
	"Expand window down a little",
	hl.dsp.window.resize({ x = 0, y = 25, relative = true })
)

o.bind(mainMod .. " + CTRL + code:20", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
o.bind(mainMod .. " + CTRL + code:21", "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
o.bind(
	mainMod .. " + CTRL + SHIFT + code:20",
	"Shrink window up a lot",
	hl.dsp.window.resize({ x = 0, y = -300, relative = true })
)
o.bind(
	mainMod .. " + CTRL + SHIFT + code:21",
	"Expand window down a lot",
	hl.dsp.window.resize({ x = 0, y = 300, relative = true })
)

o.bind(mainMod .. " + mouse_down", "Scroll active workspace forward", hl.dsp.focus({ workspace = "e+1" }))
o.bind(mainMod .. " + mouse_up", "Scroll active workspace backward", hl.dsp.focus({ workspace = "e-1" }))

o.bind(mainMod .. " + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
o.bind(mainMod .. " + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

o.bind(mainMod .. " + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind(mainMod .. " + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))

o.bind(mainMod .. " + ALT + LEFT", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind(mainMod .. " + ALT + RIGHT", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind(mainMod .. " + ALT + UP", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind(mainMod .. " + ALT + DOWN", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

o.bind(mainMod .. " + ALT + TAB", "Next window in group", hl.dsp.group.next())
o.bind(mainMod .. " + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())

o.bind(mainMod .. " + CTRL + LEFT", "Move grouped window focus left", hl.dsp.group.prev())
o.bind(mainMod .. " + CTRL + RIGHT", "Move grouped window focus right", hl.dsp.group.next())

o.bind(mainMod .. " + ALT + mouse_down", "Next window in group", hl.dsp.group.next())
o.bind(mainMod .. " + ALT + mouse_up", "Previous window in group", hl.dsp.group.prev())

for index = 1, 5 do
	o.bind(
		mainMod .. " + ALT + code:" .. tostring(index + 9),
		"Switch to group window " .. index,
		hl.dsp.group.active({ index = index })
	)
end

o.bind(mainMod .. " + SLASH", "Monitor scaling up", "omarchy-hyprland-monitor-scaling up")
o.bind(mainMod .. " + ALT + SLASH", "Monitor scaling down", "omarchy-hyprland-monitor-scaling down")

hl.unbind(mainMod .. " + C")
hl.unbind(mainMod .. " + V")
hl.unbind(mainMod .. " + SLASH")
o.bind(mainMod .. " + SLASH", "pavu", "pavucontrol")

o.bind(mainMod .. " + D", "Open Application Launcher", "rofi -show drun")
o.bind(mainMod .. " + SHIFT + Q", "Toggle Oma SHell", "toggle-omarchy-shell")
o.bind(mainMod .. " + ESCAPE ", "Swaylock", "swaylock")
o.bind(mainMod .. " + PERIOD", "Rofimoji", "rofimoji")
o.bind(mainMod .. " + E", "Nautilus", "nautilus")
o.bind(mainMod .. " + W", "Wallpaper Selector", "wallpaper-selector")
o.bind(mainMod .. " + SHIFT + N", "Open Network Manager", "kitty gazelle")
o.bind(mainMod .. " + RETURN", "Terminal", "kitty")
