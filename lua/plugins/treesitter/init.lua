return {
  require("plugins.treesitter.nvim-treesitter"),
  require("plugins.treesitter.nvim-treesitter-context"),
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  require("plugins.treesitter.rainbow-delimiters"),
}
