local action_layout = require("telescope.actions.layout")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = "close", -- disable normal mode
        ["<c-b>"] = "results_scrolling_up",
        ["<c-f>"] = "results_scrolling_down",
        ["<c-j>"] = "move_selection_next",
        ["<c-k>"] = "move_selection_previous",
        ["<c-p>"] = action_layout.toggle_preview,
        ["<c-n>"] = "cycle_history_next",
        ["<c-h>"] = "cycle_history_prev",
      },
    },
    layout_strategy = 'vertical',
    prompt_prefix = '🔍 ',
    selection_caret = '➤ ',
    dynamic_preview_title = true, -- TODO: show dir_name suffix
    -- always open the file in topleft window
    get_selection_window = function()
      vim.cmd('wincmd t')
      return vim.api.nvim_get_current_win()
    end
  },
  pickers = {
    buffers = {
      theme = 'dropdown',
      layout_config = {
        width = {
          padding = 5
        },
      },
      preview = {
        hide_on_startup = true,
      },
      sort_mru = true,
    },
  },
}
require('telescope').load_extension('fzf')
