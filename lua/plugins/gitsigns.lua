local function set_keymap()
  local gs = require("gitsigns")
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", ",.", function()
    gs.nav_hunk("next", {
      target = 'all'
    })
  end, flag)
  vim.keymap.set("n", ".,", function()
    gs.nav_hunk("prev", {
      target = 'all'
    })
  end, flag)
  vim.keymap.set("n", ",a", gs.preview_hunk, flag)
  vim.keymap.set("n", ",s", gs.stage_hunk, flag)
  vim.keymap.set("n", ",u", gs.reset_hunk, flag)
  vim.keymap.set("n", ",U", gs.reset_buffer, flag)
  vim.keymap.set("n", ",b", gs.stage_buffer, flag)
  vim.keymap.set("n", ",B", gs.reset_buffer_index, flag)
  vim.keymap.set("n", ",t", function()
    gs.toggle_deleted()
    gs.toggle_linehl()
  end, flag)
  vim.keymap.set("n", "<leader>s", gs.toggle_current_line_blame, flag)
end

local function init()
  set_keymap()
  vim.cmd([[
    highlight GitSignsCurrentLineBlame guifg=#7f7f7f
  ]])
end

return {
  "lewis6991/gitsigns.nvim",
  init = init,
  opts = {
    signs = {
      add = { text = "╋" },
      change = { text = "┃" },
      delete = { text = "⎽" },
      topdelete = { text = "⎺" },
      changedelete = { text = "⌿" },
      untracked = { text = "┇" },
    },
    signs_staged = {
      add = { text = "╋" },
      change = { text = "┃" },
      delete = { text = "⎽" },
      topdelete = { text = "⎺" },
      changedelete = { text = "⌿" },
      untracked = { text = "┇" },
    },
    current_line_blame_opts = {
      delay = 0,
    },
    current_line_blame_formatter = "<abbrev_sha> <author> <author_time> <summary>",
  },
}
