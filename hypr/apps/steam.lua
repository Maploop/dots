hl.window_rule({
	match = {
		class = "^steam$",
	},
	float = true,
	idle_inhibit = "fullscreen",
	opacity = "1",
})

hl.window_rule({
	match = {
		class = "^steam$",
		title = "^Steam$",
	},
	center = true,
	opacity = "1",
	size = { 1100, 700 },
})

hl.window_rule({
	match = {
		class = "^steam.*$",
	},
	opacity = "1",
})

hl.window_rule({
	match = {
		class = "^steam$",
		title = "^Friends List$",
	},
	size = { 460, 800 },
})
