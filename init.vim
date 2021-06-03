let plug_vim_path = has('nvim') ? '~/.local/share/nvim/site/autoload/plug.vim' : '~/.vim/autoload/plug.vim'
if empty(glob(plug_vim_path))
  silent exec "curl -fLo " . plug_vim_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'prettier/vim-prettier'
Plug 'dart-lang/dart-vim-plugin'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'zivyangll/git-blame.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'hankchiutw/flutter-reload.vim'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/unite.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'
Plug 'gcmt/wildfire.vim'
Plug 'honza/vim-snippets'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'dag/vim-fish'
Plug 'benmills/vimux'
Plug 'suan/vim-instant-markdown'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'wavded/vim-stylus'
Plug 'ap/vim-css-color'
Plug 'majutsushi/tagbar'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'hankchiutw/vim-tabbuffers'
Plug 'OmniSharp/omnisharp-vim'
call plug#end()

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

" auto indent pasting
nnoremap p p=`]
" restore yanked register
xnoremap p pgvy
" use black hole register to avoid overwrite clipboard
nnoremap x "_x
nnoremap d "_d
nnoremap dd dd
nnoremap c "_c
" search and count matches
nnoremap <expr> * ':%s/'.fnameescape(expand('<cword>')).'//gn<CR>``'
" prompt substitute with current word
nnoremap <expr> gs '*``:%s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'
" prompt substitude(current line) with current word
nnoremap <expr> gr '*``:s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'

" short key to jump cursor up/down half of current line to screen top/bottom
noremap <expr> R (line('w0')+line('.'))/2.'G'
noremap <expr> F (line('w$')+line('.'))/2.'G'

" jump to the first non-empty char
nnoremap 1 ^

" copy current file name to system clipboard
nnoremap <c-g>c :let @+ = expand('%:t') \| echo 'copied string '.@+<CR>

" for webpack file watching
set backupcopy=yes

" tab
set tabstop=2
set shiftwidth=2
set expandtab

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

autocmd colorscheme * highlight VertSplit guifg=#000000 guibg=#505050
autocmd colorscheme * highlight EndOfBuffer guifg=#505050
colorscheme torte

au BufNewFile,BufRead *.jsm,*.cjs set filetype=javascript

" remove trailing space on save
autocmd BufWritePre *.js :%s/\s\+$//e

" search the selected text
vnoremap // y/<C-R>"<CR>
" prompt substitude with the selected text
vnoremap /s y/<C-R>"<CR>:%s/<C-R>"//g<Left><Left>

au BufRead,BufNewFile *.ejs set filetype=html

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" Use `:profile pause` when done
" The log file will be created after vim quit.
command! ProfileStart :profile start /tmp/vim-profile.log<bar>profile func *<bar>profile file*<CR>

"=============================
" Plugin settings
"=============================

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

" vimpager
let g:vimpager = {}
let g:less     = {}
let g:vimpager.X11 = 0

" Taglist alias and auto open
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

" dart-vim-plugin
let g:loaded_syntastic_dart_dartanalyzer_checker = 0
autocmd BufWritePre *.dart DartFmt

" vim-bookmark
let g:bookmark_highlight_lines = 0

"=============================
" vim-instant-markdown
"=============================
" to trigger preview `:InstantMarkdownPreview`
let g:instant_markdown_autostart = 0
nnoremap <C-m> :InstantMarkdownPreview<CR>

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

"=============================
" git-blame
"=============================
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"=============================
" vim-fugitive 
"=============================
nnoremap <c-g>b :Gblame<CR>
nnoremap <c-g>f :G file %<CR><c-w>_

" wildfire
" This selects the next closest text object.
map <SPACE> <Plug>(wildfire-fuel)
" This selects the previous closest text object.
vmap - <Plug>(wildfire-water)
let g:wildfire_objects = {
      \ "*" : ["i'", 'i"', "i)", "i]", "i}", "i>", "at", "it"]
      \ }

" auto-pair and closetag
let g:closetag_filenames = "*.html,*.js,*.jsx,*.ts,*.tsx"

"=============================
" tab-page related mapping
"=============================
nmap <C-g><C-g> :tabnew<CR>
nmap <C-g><C-l> :tabn<CR>
nmap <C-g><C-h> :tabp<CR>
imap <C-g><C-g> <C-\><C-n>:tabnew<CR>
imap <C-g><C-l> <C-\><C-n>:tabn<CR>
imap <C-g><C-h> <C-\><C-n>:tabp<CR>

"=============================
" unite.vim
"=============================
nnoremap <leader>w :Unite buffer<CR>

"=============================
" vimux
"=============================
noremap <leader>a :VimuxPromptCommand<CR>
noremap <leader>r :call VimuxSendKeys('c-c')<CR>:VimuxRunLastCommand<CR>

"=============================
" vim-vue
"=============================
let g:vue_pre_processors = []

"=============================
" my draft plugins
"=============================
source ~/.vim/ale-quickfix.vim
source ~/.vim/term-map.vim

" show the last commit details of current line in Terminal-mode
nnoremap <expr><Leader>b ':te git sh '.BlameLine().'i'
function! BlameLine() abort
  let range = line('.').','.line('.')
  let command = 'git blame -s -L '.range.' '.expand('%').' | cut -d " " -f 1'
  let line_commit = system(command)
  return line_commit
endfunction
