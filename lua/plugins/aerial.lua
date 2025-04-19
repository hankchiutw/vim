return {
  "stevearc/aerial.nvim",
  init = function()
    vim.keymap.set("n", "<leader>t", "<cmd>AerialToggle!<CR>")
  end,
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
