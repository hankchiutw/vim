local default_formatter = { "biome-check", "prettierd" }

local function set_keymap()
  vim.keymap.set({ "n", "v" }, "<leader>x", require("conform").format, { desc = "Format file with Conform" })
end

return {
  "stevearc/conform.nvim",
  init = function()
    set_keymap()
  end,
  opts = {
    formatters_by_ft = {
      javascript = default_formatter,
      typescript = default_formatter,
      ["typescript.tsx"] = default_formatter,
      typescriptreact = default_formatter,
      astro = default_formatter,
      scss = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      htmlangular = { "prettierd" },
      json = { "biome-check" },
      jinja = { "prettierd" },
      python = { "black", "isort" },
      lua = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    default_format_opts = {
      stop_after_first = true,
    },
  },
}
