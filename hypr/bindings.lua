local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	hl.bind(
		mainMod .. " + " .. key,
		hl.dsp.focus({ workspace = tostring(workspace) })
	)
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace) })
	)
	hl.bind(
		mainMod .. " + SHIFT + ALT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace), follow = false })
	)
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(
	mainMod .. " + ALT + S",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }))

hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + TAB", hl.dsp.window.bring_to_top())

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + ALT + G", hl.dsp.window.move({ out_of_group = true }))

hl.bind(mainMod .. " + ALT + LEFT", hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + ALT + RIGHT", hl.dsp.window.move({ into_group = "r" }))
hl.bind(mainMod .. " + ALT + UP", hl.dsp.window.move({ into_group = "u" }))
hl.bind(mainMod .. " + ALT + DOWN", hl.dsp.window.move({ into_group = "d" }))

hl.bind(mainMod .. " + ALT + TAB", hl.dsp.group.next())
hl.bind(mainMod .. " + ALT + SHIFT + TAB", hl.dsp.group.prev())

hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.group.next())

hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.group.next())
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.group.prev())

for index = 1, 5 do
	hl.bind(
		mainMod .. " + ALT + code:" .. tostring(index + 9),
		hl.dsp.group.active({ index = index })
	)
end

hl.bind(mainMod .. " + SLASH", hl.dsp.exec_cmd("pavucontrol"))

hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("toggle-omarchy-shell"))
hl.bind(mainMod .. " + ESCAPE ", hl.dsp.exec_cmd("swaylock"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("rofimoji"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("wallpaper-selector"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("kitty gazelle"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
