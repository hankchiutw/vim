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
    end,
  },
}
