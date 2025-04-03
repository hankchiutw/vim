local M = {}
local theme = require("plugins/bufferline/theme")

function M.setup()
  local flag = { silent = true, noremap = true }

  vim.keymap.set("n", "<c-l>", "<cmd>BufferLineCycleNext<cr>", flag)
  vim.keymap.set("n", "<c-h>", "<cmd>BufferLineCyclePrev<cr>", flag)
  vim.keymap.set("n", "+", "<cmd>BufferLineMoveNext<cr>", flag)
  vim.keymap.set("n", "-", "<cmd>BufferLineMovePrev<cr>", flag)

  -- these require vim-tabbuffers
  vim.keymap.set({ "n", "v" }, "q", "<Plug>(TabbuffersQuit)", flag)
  vim.keymap.set("n", "~", "<Plug>(TabbuffersMruBack)", flag)
  vim.keymap.set("n", "!", "<Plug>(TabbuffersMruForward)", flag)

  vim.opt.termguicolors = true
end

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "hankchiutw/vim-tabbuffers",
  },
  init = M.setup,
  opts = {
    options = {
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      numbers = "both",
      separator_style = { "⎹", "⎹" },
      modified_icon = "▌",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        -- indicate errors only
        return level:match("error") and "(" .. count .. ")" or ""
      end,
    },
    highlights = theme,
  },
}
