vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-j>", "<Down>")

-- Map Alt+o in normal mode to jump to older cursor position (like <C-o>)
vim.keymap.set("n", "<A-o>", "<C-o>", { noremap = true })
-- Map Alt+i in normal mode to jump to newer cursor position (like <C-i>)
vim.keymap.set("n", "<A-i>", "<C-i>", { noremap = true })

return {
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    init = function()
      vim.keymap.set("n", "<c-g>b", ":G blame<CR>", { desc = "Git blame" })
      vim.keymap.set("n", "<c-g>f", ":G file %<CR><c-w>_", { desc = "Git file history" })
      vim.keymap.set("n", "<c-g>r", ":G co %<CR>", { desc = "Git reset HEAD" })
    end,
  },
}
