local M = {}
local bufferline = require("bufferline")

function M.setup()
	local flag = { silent = true, noremap = true }
	vim.keymap.set("n", "<c-l>", "<cmd>BufferLineCycleNext<cr>", flag)
	vim.keymap.set("n", "<c-h>", "<cmd>BufferLineCyclePrev<cr>", flag)
	vim.keymap.set("n", "+", "<cmd>BufferLineMoveNext<cr>", flag)
	vim.keymap.set("n", "-", "<cmd>BufferLineMovePrev<cr>", flag)

	vim.keymap.set({ "n", "v" }, "q", "<Plug>(TabbuffersQuit)", flag)
	vim.keymap.set("n", "~", "<Plug>(TabbuffersMruBack)", flag)
	vim.keymap.set("n", "!", "<Plug>(TabbuffersMruForward)", flag)

	bufferline.setup({
		options = {
			show_buffer_close_icons = false,
			show_close_icon = false,
			separator_style = "thin", -- | "padded_slant" | "thick" | "thin" | { "any", "any" },
		},
	})
end

return M
