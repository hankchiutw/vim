local M = {}
local lualine = require("lualine")
local theme = require("custom.lualine.theme")

local filename_section = {
	{
		"filename",
		path = 1,
	},
}
local location_section = {
	{
		"progress",
		padding = 0,
	},
	"location",
}

function M.setup()
	lualine.setup({
		options = {
			refresh = {
				statusline = 100,
			},
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			theme = theme,
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(v)
						local map = {
							INSERT = "🅸",
							NORMAL = "🅽",
							VISUAL = "🆅",
							["V-LINE"] = "🆅",
						}

						return map[v] or v
					end,
				},
			},
			lualine_b = {},
			lualine_c = filename_section,
			lualine_x = {
				"filesize",
				"filetype",
				"branch",
			},
			lualine_y = {
				"diff",
				{
					"diagnostics",
					symbols = { error = "🚫 ", warn = "💀 ", info = "💡 ", hint = "🔆 " },
					diagnostics_color = {
						error = { fg = "#d63230" },
						warn = { fg = "#e0e0e0" },
						info = { fg = "#e0e0e0" },
						hint = { fg = "#ffc600" },
					},
				},
				"encoding",
				"fileformat",
			},
			lualine_z = location_section,
		},
		inactive_sections = {
			lualine_c = filename_section,
			lualine_x = location_section,
		},
	})
end

return M
