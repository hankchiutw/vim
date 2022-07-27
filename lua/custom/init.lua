local M = {}

function M.setup()
	require("custom.lsp").setup()
	require("custom.null-ls").setup()
	require("custom.coq").setup()
	require("custom.telescope").setup()
end

return M
