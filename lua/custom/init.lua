local M = {}

local plugins = {
  "treesitter",
  "lsp",
  "null-ls",
  "coq",
  "telescope",
  "gitsigns",
  "diffview",
  "lualine",
  "bufferline",
  "nvim-autopairs",
  "rainbow-delimiters",
}

function M.setup()
  for _, name in ipairs(plugins) do
    require("custom." .. name).setup()
  end
end

return M
