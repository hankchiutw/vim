local M = {}

local gs = require("gitsigns")

local function set_keymap()
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

local function set_style()
  vim.cmd([[
    autocmd colorscheme * highlight GitSignsAdd ctermbg=0 guibg=#000000 guifg=#78bd7a ctermfg=2
    autocmd colorscheme * highlight GitSignsDelete ctermbg=0 guibg=#000000 guifg=#c51919 ctermfg=1
    autocmd colorscheme * highlight GitSignsChange ctermbg=0 guibg=#000000 guifg=#edeb5f ctermfg=14
    autocmd colorscheme * highlight GitSignsChangeDelete ctermbg=0 guibg=#000000 guifg=#875fd7 ctermfg=5 cterm=strikethrough gui=strikethrough
    autocmd colorscheme * highlight GitSignsCurrentLineBlame guifg=#666666
  ]])
end

function M.setup()
  set_keymap()
  set_style()

  require("gitsigns").setup({
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
  })
end

return M
