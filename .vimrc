syntax on
set number
set gfn=Monospace\ 8
set tabstop=4 shiftwidth=4

set guifont=Monaco\ 10
colorscheme torte

" NERTree alias and auto open
map <leader>e :NERDTreeToggle<CR>
autocmd BufEnter :lcd %:p:h
"autocmd vimenter :NERDTree

execute pathogen#infect()

set formatoptions+=o
set foldmethod=indent
set foldlevelstart=20
