local signs_map = {
  [vim.diagnostic.severity.ERROR] = "🚫",
  [vim.diagnostic.severity.WARN] = "💀",
  [vim.diagnostic.severity.HINT] = "🔆",
  [vim.diagnostic.severity.INFO] = "💡",
}

local function prefix_by_diagnostic(diagnostic)
  return signs_map[diagnostic.severity] .. " " or "●"
end

local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "..", vim.diagnostic.goto_prev, flag)
  vim.keymap.set("n", ",,", vim.diagnostic.goto_next, flag)
end

local function set_diagnostic_style()
  local severity = vim.diagnostic.severity
  local signs = {
    { name = "DiagnosticSignError", text = signs_map[severity.ERROR] },
    { name = "DiagnosticSignWarn", text = signs_map[severity.WARN] },
    { name = "DiagnosticSignHint", text = signs_map[severity.HINT] },
    { name = "DiagnosticSignInfo", text = signs_map[severity.INFO] },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = prefix_by_diagnostic,
    },
    float = {
      prefix = prefix_by_diagnostic,
      border = "rounded", -- Set a rounded border for the floating window
      header = "", -- Remove default header text
      source = "always", -- Show diagnostic source
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
