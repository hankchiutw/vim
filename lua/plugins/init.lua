vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-j>", "<Down>")

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
