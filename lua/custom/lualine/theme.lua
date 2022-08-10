local colors = {
	black = "#202020",
	white = "#b7b7b7",
	red = "#fb4934",
	green = "#06d6a0",
	-- green = "#247a4d",
	blue = "#00a6fb",
	yellow = "#fe8019",
	purple = "#b5179e",
	gray = "#808080",
	darkgray = "#303030",
	lightgray = "#474747",
	inactivegray = "#7c6f64",
}
return {
	normal = {
		a = { bg = colors.green, fg = colors.black, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.yellow },
	},
	insert = {
		a = { bg = colors.blue, fg = colors.black, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.yellow },
	},
	visual = {
		a = { bg = colors.purple, fg = colors.black, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.yellow },
	},
	replace = {
		a = { bg = colors.red, fg = colors.black, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	command = {
		a = { bg = colors.gray, fg = colors.black, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.inactivegray, fg = colors.black },
	},
	inactive = {
		a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.gray },
		c = { bg = colors.black, fg = colors.gray },
	},
}
