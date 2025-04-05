local function set_keymap()
  local gs = require("gitsigns")
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", ",.", gs.next_hunk, flag)
  vim.keymap.set("n", ".,", gs.prev_hunk, flag)
  vim.keymap.set("n", ",a", gs.preview_hunk, flag)
  vim.keymap.set("n", ",s", gs.stage_hunk, flag)
  vim.keymap.set("n", ",S", gs.undo_stage_hunk, flag)
  vim.keymap.set("n", ",u", gs.reset_hunk, flag)
  vim.keymap.set("n", ",b", gs.stage_buffer, flag)
  vim.keymap.set("n", ",B", gs.reset_buffer_index, flag)
end

local function init()
  set_keymap()
end

return {
  "lewis6991/gitsigns.nvim",
  init = init,
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "∿" },
    },
    current_line_blame_opts = {
      delay = 0,
    },
    current_line_blame_formatter = "<abbrev_sha> <author> <author_time> <summary>",
  },
}
