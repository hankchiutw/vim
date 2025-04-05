local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "..", vim.diagnostic.goto_prev, flag)
  vim.keymap.set("n", ",,", vim.diagnostic.goto_next, flag)
end

local function set_diagnostic_style()
  local signs = {
    { name = "DiagnosticSignError", text = "🚫" },
    { name = "DiagnosticSignWarn", text = "💀" },
    { name = "DiagnosticSignHint", text = "🔆" },
    { name = "DiagnosticSignInfo", text = "💡" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
    },
    float = {
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
