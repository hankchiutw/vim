local formatter = require("formatter")
local M = {}

local function gen_sources()
  return {
    javascript = require("formatter.filetypes.javascript").prettierd,
    typescript = require("formatter.filetypes.javascript").prettierd,
    html = require("formatter.filetypes.html").prettierd,
    jinja = require("formatter.filetypes.html").prettierd,
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
  formatter.setup({
    filetype = gen_sources(),
  })

  set_keymap()
  set_autocmd()
end

return M
