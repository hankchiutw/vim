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

local function setup()
  require("lint").linters_by_ft = {
    javascript = { "biomejs", "eslint_d" },
    typescript = { "biomejs", "eslint_d" },
    python = { "ruff" },
  }

  set_autocmd()
end

return {
  "mfussenegger/nvim-lint",
  config = setup,
}
