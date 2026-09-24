hl.window_rule({
	match = {
		class = "^steam$",
	},
	float = true,
	idle_inhibit = "fullscreen",
	opaque = true,
})

hl.window_rule({
	match = {
		class = "^steam$",
		title = "^Steam$",
	},
	center = true,
	opaque = true,
	size = { 1100, 700 },
})

hl.window_rule({
	match = {
		class = "^steam.*$",
	},
	opaque = true,
})

hl.window_rule({
	match = {
		class = "^steam$",
		title = "^Friends List$",
	},
	size = { 460, 800 },
})
