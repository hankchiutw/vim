local signs_map = {
  [vim.diagnostic.severity.ERROR] = "🚫",
  [vim.diagnostic.severity.WARN] = "💀",
  [vim.diagnostic.severity.HINT] = "🔆",
  [vim.diagnostic.severity.INFO] = "💡",
}

local function prefix_by_diagnostic(diagnostic)
  return signs_map[diagnostic.severity] .. " " or "●"
end

local function toggle_quickfix()
  local has_quickfix = false
  for _, v in ipairs(vim.fn.getwininfo()) do
    if v.quickfix == 1 then
      has_quickfix = true
      break
    end
  end

  if has_quickfix then
    vim.cmd("cclose")
  else
    vim.diagnostic.setqflist()
  end
end

local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "..", vim.diagnostic.goto_prev, flag)
  vim.keymap.set("n", ",,", vim.diagnostic.goto_next, flag)
  vim.keymap.set("n", "<c-j>", vim.lsp.buf.definition, flag)
  vim.keymap.set("n", "<leader>q", toggle_quickfix, flag)
  vim.keymap.set("n", "<esc>", "<cmd>cclose<cr>", flag)
end

local function set_diagnostic_style()
  local severity = vim.diagnostic.severity

  vim.diagnostic.config({
    signs = {
      text = {
        [severity.ERROR] = signs_map[severity.ERROR],
        [severity.WARN] = signs_map[severity.WARN],
        [severity.HINT] = signs_map[severity.HINT],
        [severity.INFO] = signs_map[severity.INFO],
      },
      numhl = {
        [severity.ERROR] = "DiagnosticSignError",
        [severity.WARN] = "DiagnosticSignWarn",
        [severity.HINT] = "DiagnosticSignHint",
        [severity.INFO] = "DiagnosticSignInfo",
      },
      texthl = {
        [severity.ERROR] = "DiagnosticSignError",
        [severity.WARN] = "DiagnosticSignWarn",
        [severity.HINT] = "DiagnosticSignHint",
        [severity.INFO] = "DiagnosticSignInfo",
      },
    },
    virtual_text = {
      prefix = prefix_by_diagnostic,
    },
    float = {
      prefix = prefix_by_diagnostic,
      border = "rounded", -- Set a rounded border for the floating window
      header = "", -- Remove default header text
      source = true, -- Show diagnostic source
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  init = function()
    set_keymap()
    set_diagnostic_style()
  end,
}
