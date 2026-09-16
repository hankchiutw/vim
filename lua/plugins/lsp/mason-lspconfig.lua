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
      "html",
      "cssls",
      "jsonls",
      "copilot",
    },
    automatic_enable = { exclude = { "ts_ls", "vue_ls" } },
  },
}
