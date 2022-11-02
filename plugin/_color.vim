" ref: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
autocmd colorscheme * highlight CursorLine cterm=none ctermbg=235 guibg=#262626
autocmd colorscheme * highlight CursorColumn ctermbg=235 guibg=#262626
autocmd colorscheme * highlight CursorLineNR ctermbg=3 guibg=DarkCyan
autocmd colorscheme * highlight IndentGuidesOdd ctermbg=235 guibg=#262626
autocmd colorscheme * highlight IndentGuidesEven ctermbg=235 guibg=#262626

autocmd colorscheme * highlight Pmenu ctermbg=89 ctermfg=7 guibg=#87005f guifg=#e8e8e8
autocmd colorscheme * highlight PmenuSbar ctermbg=132 guibg=#af5f87
autocmd colorscheme * highlight PmenuThumb ctermbg=176 guibg=#df87df
autocmd colorscheme * highlight PmenuSel ctermbg=169 ctermfg=15 guibg=#df5faf guifg=#ffffff

autocmd colorscheme * highlight VertSplit guibg=#000000 guifg=#505050
autocmd colorscheme * highlight EndOfBuffer guifg=#505050
autocmd colorscheme * highlight SignColumn ctermbg=black guibg=black
" color for preview window
autocmd colorscheme * highlight DiffAdded guifg=#afffaf ctermfg=157
autocmd colorscheme * highlight DiffRemoved guifg=#f09999 ctermfg=224

" for diff mode
autocmd colorscheme * highlight DiffAdd ctermfg=none guifg=none guibg=#202f26
autocmd colorscheme * highlight DiffDelete ctermfg=none guifg=#777777 guibg=#3a212c
autocmd colorscheme * highlight DiffChange ctermfg=none guifg=none guibg=black
autocmd colorscheme * highlight DiffText ctermfg=none guifg=none guibg=#3e4764

colorscheme torte
