return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "pyright",
      "ts_ls",
      "html",
      "cssls",
      "jsonls",
      "copilot",
    },
  },
}
