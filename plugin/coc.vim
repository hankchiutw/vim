"=============================
" coc.nvim
"=============================
" set completeopt-=preview
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-eslint', 'coc-omnisharp', 'coc-svelte', 'coc-pyright']
nmap <C-j> <Plug>(coc-definition)
nmap <C-k> <Plug>(coc-references)
nmap <silent> .. <Plug>(coc-diagnostic-prev)
nmap <silent> ,, <Plug>(coc-diagnostic-next)
inoremap <silent><expr> <TAB> <SID>coc_completion()
inoremap <silent><expr> <C-j> <SID>coc_completion()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"

" confirm the selection
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

function! s:coc_completion() abort
  return pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
