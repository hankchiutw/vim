set nocompatible
set hidden
set number
set encoding=utf-8
set autoread
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set foldmethod=indent
set foldlevelstart=20
set ttimeoutlen=0
set nostartofline
set termguicolors

" to be compatible in fish environment
set sh=bash

" handy copy to clipboard without "*y
set clipboard=unnamed

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Make help window full height
set helpheight=9999

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" for webpack file watching
set backupcopy=yes

" tab
set tabstop=2
set shiftwidth=2
set expandtab

au BufNewFile,BufRead *.jsm,*.cjs set filetype=javascript

" remove trailing space on save
autocmd BufWritePre *.js :%s/\s\+$//e

au BufRead,BufNewFile *.ejs set filetype=html

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" Use `:profile pause` when done
" The log file will be created after vim quit.
command! ProfileStart :profile start /tmp/vim-profile.log<bar>profile func *<bar>profile file*<CR>
