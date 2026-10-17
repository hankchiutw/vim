local function init()
  local tb = require("custom.tabbuffers")
  tb.setup()

  local flag = { silent = true, noremap = true }

  vim.keymap.set("n", "<c-l>", function() tb.switch(1) end, flag)
  vim.keymap.set("n", "<c-h>", function() tb.switch(-1) end, flag)
  vim.keymap.set("n", "+", function() tb.move(1) end, flag)
  vim.keymap.set("n", "-", function() tb.move(-1) end, flag)

  vim.keymap.set({ "n", "v" }, "q", tb.quit, flag)
  vim.keymap.set("n", "~", tb.mru_back, flag)
  vim.keymap.set("n", "!", tb.mru_forward, flag)
  vim.keymap.set("n", "<c-g>n", tb.prompt_tabname, flag)

  vim.opt.termguicolors = true
end

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  after = "catppuccin",
  init = init,
  config = function()
    local palette = require("catppuccin.palettes").get_palette()
    local tb = require("custom.tabbuffers")

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
        custom_filter = function(bufnr)
          return tb.is_buf_in_tab(bufnr)
        end,
        sort_by = function(a, b)
          return tb.compare_bufs(a.id, b.id)
        end,
        custom_areas = {
          right = function()
            return {
              { text = " " .. tb.get_tab_label() .. " ", fg = palette.lavender },
              { text = " " .. tb.get_cwd_status() .. " ", fg = palette.subtext0 },
            }
          end,
        },
      },
      highlights = require("catppuccin.special.bufferline").get_theme({
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
