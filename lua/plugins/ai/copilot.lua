return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  -- init = function()
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "BlinkCmpMenuOpen",
  --     callback = function()
  --       vim.b.copilot_suggestion_hidden = true
  --     end,
  --   })

  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "BlinkCmpMenuClose",
  --     callback = function()
  --       vim.b.copilot_suggestion_hidden = false
  --     end,
  --   })
  -- end,
  opts = {
    panel = {
      enabled = true,
      auto_refresh = true,
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
      },
    },
    filetypes = {
      markdown = true,
      javascript = true,
      typescript = true,
      lua = true,
      astro = true,
    },
  },
}
