" for nerdtree and others
execute pathogen#infect()

syntax on
set number
set autoread
set cursorline
set cursorcolumn
autocmd colorscheme * highlight CursorLine cterm=none ctermbg=235
autocmd colorscheme * highlight CursorColumn ctermbg=235

colorscheme torte

filetype plugin on
au BufNewFile,BufRead *.jsm set filetype=javascript

" highlight searching
set hlsearch

" follow when typing
set incsearch

" searching selected by //
vnoremap // y/<C-R>"<CR>

" handy copy to clipboard without "*y
" need to have `+clipboard`, check by using `:echo has('clipboard')`
set clipboard=unnamed

" for webpack file watching
set backupcopy=yes

" NERDTree alias and auto open
map <leader>e :NERDTreeToggle<CR>
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
" effectively no split
let g:NERDTreeWinSize=10000
autocmd BufEnter :lcd %:p:h
"autocmd vimenter :NERDTree
au BufRead,BufNewFile *.ejs set filetype=html
" to fix broken arrows
"let g:NERDTreeDirArrows=0
set encoding=utf-8

" always open file in a new(or existing) tab
function NERDTreeMyOpenTab(node)
  call a:node.activate({'reuse': 1, 'where': 't'})
endfunction
autocmd VimEnter * :call NERDTreeAddKeyMap({ 'key': 't', 'callback': 'NERDTreeMyOpenTab', 'scope': 'FileNode', 'override': 1 })


" Taglist alias and auto open
map <leader>t :TlistToggle<CR>
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1

" winmanager alias and auto open
map <leader>w :WMToggle<CR>
let g:winManagerWindowLayout = "FileExplorer|TagList|,BufExplorer"
"let g:winManagerWindowLayout = "NERDTree|TagList|,BufExplorer"
let g:winManagerWidth = 30

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r
" set foldmethod=indent
" set foldlevelstart=20

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

" tab
set tabstop=2
set shiftwidth=2
set expandtab

set nocompatible
filetype plugin on
runtime macros/matchit.vim
" filetype detect

" less to css
" nnoremap <Leader>m :w <BAR> !lessc % > %:t:r.css<CR><space>

" Autofix entire buffer with eslint_d:
nnoremap <leader>f mF:%!eslint_d --stdin --fix-to-stdout<CR>`F

" vim-prettier
let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql,*.md PrettierAsync

let g:prettier#quickfix_enabled = 0
nnoremap <leader>F :PrettierAsync<CR>mF:%!eslint_d --stdin --fix-to-stdout<CR>`F

" vimpager
let g:vimpager = {}
let g:less     = {}
let g:vimpager.X11 = 0

" dart-vim-plugin
let g:loaded_syntastic_dart_dartanalyzer_checker = 0
autocmd BufWritePre *.dart DartFmt

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '・'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number 
let g:airline#extensions#tabline#tabs_label = '»'
let g:airline#extensions#tabline#show_close_button = 0
let g:tmuxline_preset = {
      \ 'b': '#S',
      \ 'win': ['#I #W'],
      \ 'cwin': ['#I #W'],
      \ 'y': ['%Y-%b-%d %R:%S %a']}

" auto indent pasting
nnoremap p p=`]

" restore yanked register
xnoremap p pgvy

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

" let g:syntastic_javascript_checkers = ['eslint', 'jshint', 'jscs', 'closurecompiler']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
let g:syntastic_javascript_closurecompiler_path = '/tmp/compiler.jar'

let g:syntastic_html_checkers = ['jshint']

let g:syntastic_css_checkers = ['csslint']

let g:syntastic_less_checkers = ['less']

let g:syntastic_scss_checkers = ['stylelint']

let g:syntastic_sh_checkers = ['sh', 'shellcheck']

" vim-gitgutter
let g:gitgutter_highlight_lines = 0

" To install YCM, execute :PluginInstall
" Dismiss after installation completed
" Vundle vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

function LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

function LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction

nmap ,, :call LocationPrevious()<CR>
nmap .. :call LocationNext()<CR>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"
let g:ycm_confirm_extra_conf = 0 

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'jreybert/vimagit'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'leafgarland/typescript-vim'
Plugin 'zivyangll/git-blame.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'

" End configuration, makes the plugins available
call vundle#end()
filetype plugin indent on
