return {
  require("plugins.treesitter.nvim-treesitter"),
  require("plugins.treesitter.nvim-treesitter-context"),
  require("plugins.treesitter.nvim-treesitter-textobjects"),
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  require("plugins.treesitter.rainbow-delimiters"),
  require("plugins.treesitter.hlargs"),
}
