noremap <leader>f :Telescope find_files<CR>
noremap <leader>g :Telescope live_grep<CR>
noremap <leader>w :Telescope buffers<CR>
noremap <leader>m :Telescope marks<CR>

autocmd User TelescopePreviewerLoaded setlocal number wrap

autocmd colorscheme * highlight TelescopeSelection ctermfg=yellow guifg=yellow gui=bold
autocmd colorscheme * highlight TelescopeMatching ctermfg=cyan guifg=cyan
autocmd colorscheme * highlight TelescopePreviewLine ctermbg=235 guibg=#464646
autocmd colorscheme * highlight TelescopePromptCounter ctermfg=darkcyan guifg=darkcyan
autocmd colorscheme * highlight TelescopeBorder ctermfg=grey guifg=grey

lua << EOF
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
      theme = 'cursor',
      preview = {
        hide_on_startup = true,
      },
      sort_mru = true,
      -- TODO: customize entry_maker
    },
  },
}
require('telescope').load_extension('fzf')
EOF
