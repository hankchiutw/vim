local M = {}

local function gen_sources()
  local biome = require("formatter.defaults.biome")
  local eslint_d = require("formatter.defaults.eslint_d")
  local prettierd = require("formatter.defaults.prettierd")

  local js_formatter = {
    biome,
    eslint_d,
  }

  return {
    javascript = js_formatter,
    typescript = js_formatter,
    ["typescript.tsx"] = js_formatter,
    astro = js_formatter,
    scss = prettierd,
    css = prettierd,
    html = prettierd,
    htmlangular = prettierd,
    json = biome,
    jinja = prettierd,
    python = {
      require("formatter.filetypes.python").black,
      require("formatter.filetypes.python").isort,
    },
    lua = require("formatter.filetypes.lua").stylua,
  }
end

local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>x", ":Format<cr>", flag)
  vim.keymap.set("v", "<leader>x", ":Format<cr>", flag)
end

local function set_autocmd()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  augroup("__formatter__", { clear = true })
  autocmd("BufWritePost", {
    group = "__formatter__",
    command = ":FormatWrite",
  })
end

function M.setup()
  require("formatter").setup({
    logging = false,
    filetype = gen_sources(),
  })

  set_keymap()
  set_autocmd()
end

return {
  "mhartington/formatter.nvim",
  config = M.setup,
}
