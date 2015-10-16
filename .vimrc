execute pathogen#infect()
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

set formatoptions+=o
" set foldmethod=indent
" set foldlevelstart=20

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'
set completeopt-=preview

set nocompatible
filetype plugin on
runtime macros/matchit.vim
filetype detect

" tab
set tabstop=4
set shiftwidth=4
set expandtab

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

let g:syntastic_javascript_checkers = ['eslint', 'jshint', 'jscs']
let g:syntastic_javascript_eslint_exec = 'eslint_d'

let g:syntastic_html_checkers = ['tidy', 'jshint']

let g:syntastic_css_checkers = ['recess']

let g:syntastic_sh_checkers = ['sh', 'shellcheck']