local lint = require("lint")
local M = {}

local function set_autocmd()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  augroup("__linter__", { clear = true })
  autocmd("BufWritePost", {
    group = "__linter__",
    callback = function()
      require("lint").try_lint()
    end,
  })
end

function M.setup()
  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    python = { "ruff" },
  }

  set_autocmd()

  vim.diagnostic.config({
    virtual_text = {
      source = true,
    },
    float = {
      source = true,
    },
  })
end

return M
