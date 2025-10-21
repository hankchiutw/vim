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

local function common_handler(server_name)
  require("lspconfig")[server_name].setup({
    on_attach = function(client, bufnr)
      local flag = { silent = true, noremap = true }
      vim.keymap.set("n", "<c-j>", vim.lsp.buf.definition, flag)
      vim.keymap.set("n", "<leader>q", toggle_quickfix, flag)
      vim.keymap.set("n", "<esc>", "<cmd>cclose<cr>", flag)
    end,
  })
end

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
      "ts_ls",
      "html",
      "cssls",
      "jsonls",
      "copilot",
    },
    handlers = {
      common_handler,
    },
  },
}
