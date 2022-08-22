local colors = {
	inactive_fg = "#555555",
	inactive_bg = "#101010",
	active_fg = "#06d6a0",
	darkred = "#6f111e",
	red = "#ff686b",
	darkpink = "#71405b",
	pink = "#f0a6ff",
	darkred2 = "#443047",
	red2 = "#f49cbb",
}

local inactive = {
	guifg = colors.inactive_fg,
	guibg = colors.inactive_bg,
}
local selected = {
	guifg = colors.active_fg,
}

return {
	background = inactive,
	warning = inactive,
	error = inactive,
	hint = inactive,
	info = inactive,
	separator = inactive,
	numbers = inactive,
	tab = inactive,

	buffer_selected = selected,
	warning_selected = selected,
	error_selected = selected,
	hint_selected = selected,
	info_selected = selected,
	indicator_selected = selected,
	numbers_selected = selected,
	tab_selected = selected,

	duplicate = {
		guifg = colors.darkpink,
	},
	duplicate_selected = {
		guifg = colors.pink,
	},

	error_diagnostic = {
		guifg = colors.darkred,
		guibg = colors.inactive_bg,
	},
	error_diagnostic_selected = {
		guifg = colors.red,
	},
	error_diagnostic_visible = {
		guifg = colors.red,
	},

	modified = {
		guifg = colors.darkred2,
	},
	modified_visible = {
		guifg = colors.darkred2,
	},
	modified_selected = {
		guifg = colors.red2,
	},
}
