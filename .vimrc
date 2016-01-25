syntax on
set number
set gfn=Monospace\ 8

set guifont=Monaco\ 10
colorscheme torte

" NERTree alias and auto open
map <leader>e :NERDTreeToggle<CR>
autocmd BufEnter :lcd %:p:h
"autocmd vimenter :NERDTree
au BufRead,BufNewFile *.ejs set filetype=html

" Taglist alias and auto open
map <leader>t :TlistToggle<CR>
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1

" winmanager alias and auto open
map <leader>w :WMToggle<CR>
let g:winManagerWindowLayout = "FileExplorer|TagList|,BufExplorer"
"let g:winManagerWindowLayout = "NERDTree|TagList|,BufExplorer"
let g:winManagerWidth = 30

execute pathogen#infect()

set formatoptions+=o
" set foldmethod=indent
" set foldlevelstart=20

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

" tab
set tabstop=4
set shiftwidth=4
set expandtab

set nocompatible
filetype plugin on
runtime macros/matchit.vim
filetype detect

" less to css
" nnoremap <Leader>m :w <BAR> !lessc % > %:t:r.css<CR><space>

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

let g:syntastic_sh_checkers = ['sh', 'shellcheck']
