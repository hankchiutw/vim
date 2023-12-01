local M = {}

local plugins = {
  "treesitter",
  "lsp",
  "coq",
  "telescope",
  "gitsigns",
  "diffview",
  "lualine",
  "bufferline",
  "nvim-autopairs",
  "rainbow-delimiters",
  "hlargs",
  "formatter",
  "nvim-lint",
}

function M.setup()
  for _, name in ipairs(plugins) do
    require("custom." .. name).setup()
  end
end

return M
