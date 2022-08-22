local M = {}
local bufferline = require("bufferline")
local theme = require("custom.bufferline.theme")

function M.setup()
	local flag = { silent = true, noremap = true }
	vim.keymap.set("n", "<c-l>", "<cmd>BufferLineCycleNext<cr>", flag)
	vim.keymap.set("n", "<c-h>", "<cmd>BufferLineCyclePrev<cr>", flag)
	vim.keymap.set("n", "+", "<cmd>BufferLineMoveNext<cr>", flag)
	vim.keymap.set("n", "-", "<cmd>BufferLineMovePrev<cr>", flag)

	vim.keymap.set({ "n", "v" }, "q", "<Plug>(TabbuffersQuit)", flag)
	vim.keymap.set("n", "~", "<Plug>(TabbuffersMruBack)", flag)
	vim.keymap.set("n", "!", "<Plug>(TabbuffersMruForward)", flag)

	vim.opt.termguicolors = true
	bufferline.setup({
		options = {
			show_buffer_close_icons = false,
			show_close_icon = false,
			numbers = "both",
			separator_style = { "⎹", "⎹" },
			modified_icon = "▌",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				-- indicate errors only
				return level:match("error") and "(" .. count .. ")" or ""
			end,
		},
		highlights = theme,
	})
end

return M
