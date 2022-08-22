local M = {}

local plugins = {
	"nvim-treesitter",
	"lsp",
	"null-ls",
	"coq",
	"telescope",
	"gitsigns",
	"diffview",
	"lualine",
	"bufferline",
}

function M.setup()
	for _, name in ipairs(plugins) do
		require("custom." .. name).setup()
	end
end

return M
