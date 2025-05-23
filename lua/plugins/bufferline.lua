local function init()
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
  after = "catppuccin",
  init = init,
  config = function()
    local palette = require("catppuccin.palettes").get_palette()

    require("bufferline").setup({
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        numbers = "both",
        separator_style = { "⎹", " " },
        modified_icon = "▌",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          -- indicate errors only
          return level:match("error") and "(" .. count .. ")" or ""
        end,
        name_formatter = function(buf)
          local git_status = vim.b[buf.bufnr].gitsigns_status
          if git_status and #git_status > 0 then
            return "🞼 " .. buf.name
          end
          return buf.name
        end,
      },
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        custom = {
          mocha = (function()
            local t = {
              background = { fg = palette.surface2 },
              modified = { fg = palette.surface0 },
              modified_visible = { fg = palette.blue },
            }

            local selected_buffer_style = { bg = "#443c31" }
            local visible_buffer_style = { bg = palette.surface0 }
            local selected_keys = {
              "modified",
              "buffer",
              "numbers",
              "indicator",
              "hint",
              "info",
              "warning",
              "error",
              "hint_diagnostic",
              "info_diagnostic",
              "warning_diagnostic",
              "error_diagnostic",
            }
            for _, key in ipairs(selected_keys) do
              t[key .. "_selected"] = selected_buffer_style
              t[key .. "_visible"] = visible_buffer_style
            end
            return t
          end)(),
        },
      }),
    })
  end,
}
