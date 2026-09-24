hl.window_rule({
	match = {
		class = "^Bitwarden$",
	},
	no_screen_share = true,
	float = true,
	center = true,
	size = { 1000, 800 },
	tag = "+floating-window",
})

hl.window_rule({
	match = {
		class = "^chrome-nngceckbapebfimnlniiiahkandclblb-Default$",
	},
	no_screen_share = true,
	tag = "+floating-window",
})
