" always open the file in topleft window
" (to avoid opening in defx window)
let open_topleft = {}
function! open_topleft.func(candidate)
  wincmd t
  exe "e ".a:candidate.action__path
endfunction
call unite#custom#action('buffer', 'open', open_topleft)
unlet open_topleft

nnoremap <leader>w :Unite buffer<CR>
