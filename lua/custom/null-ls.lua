local null_ls = require("null-ls")
local M = {}

local function gen_sources()
  return {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.formatting.eslint_d,
  }
end

local lsp_formatting = function(bufnr)
  -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
    timeout_ms = 2000,
  })
end

local function gen_on_attach()
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  return function(client, bufnr)
    local support_format = client.supports_method("textDocument/formatting")
    local support_client = client.name ~= "tsserver"
    if support_format and support_client then
      -- Auto format when saving
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end
end

local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>x", lsp_formatting, flag)
  vim.keymap.set("v", "<leader>x", lsp_formatting, flag)
end

function M.setup()
  null_ls.setup({
    sources = gen_sources(),
    on_attach = gen_on_attach(),
    debug = true,
  })

  set_keymap()
end

return M
