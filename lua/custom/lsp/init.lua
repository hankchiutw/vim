local mason = require("mason")
local lspconfig = require("lspconfig")
local coq = require("coq")
local highlight = require("custom.lsp.highlight")
local M = {}

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

local function setup_servers()
  -- this should be placed before lspconfig.<x>.setup
  mason.setup()
  local on_attach = function()
    local flag = { silent = true, noremap = true }
    vim.keymap.set("n", "<c-j>", vim.lsp.buf.definition, flag)
    vim.keymap.set("n", "<leader>a", toggle_quickfix, flag)
    vim.keymap.set("n", "<esc>", "<cmd>cclose<cr>", flag)
  end

  -- Enable some language servers with the additional completion capabilities offered by coq_nvim
  local servers = { "lua_ls", "pyright", "ts_ls", "jsonls" }
  local server_opts = {
    lua_ls = {
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
  }
  for _, server_name in ipairs(servers) do
    local opts = server_opts[server_name] or { on_attach = on_attach }
    lspconfig[server_name].setup(coq.lsp_ensure_capabilities(opts))
  end
end

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
  })

  highlight.setup()
end

function M.setup()
  set_keymap()
  set_diagnostic_style()
  setup_servers()
end

return M
