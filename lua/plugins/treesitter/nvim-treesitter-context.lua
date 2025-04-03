local M = {}

function M.setup()
  vim.cmd([[
  autocmd colorscheme * hi TreesitterContext guibg=#612f52
  autocmd colorscheme * hi TreesitterContextLineNumber guifg=#b05596
  ]])
end

return {
  "nvim-treesitter/nvim-treesitter-context",
  config = M.setup,
}
