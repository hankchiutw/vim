
"=============================
" Buffer related mapping
"=============================
" enhance buffer navigation
" require 'Shougo/tabpagebuffer.vim'
noremap <silent> <C-l> :call SwitchBuffer('bn')<CR>
noremap <silent> <C-h> :call SwitchBuffer('bp')<CR>
" unlist quickfix buffer so that we will not navigate to it
autocmd FileType qf setlocal nobuflisted

" Do <C-w>l or <C-w>h if only one buffer
function! SwitchBuffer(callback)
  if empty(&buflisted)
    return
  endif

  " switch tab buffers instead of loop all buffers
  let tabbufs = map(keys(gettabvar(tabpagenr(), 'tabpagebuffer')), 'str2nr(v:val)')
  let tab_listed_bufs = sort(filter(tabbufs, 'getbufvar(v:val, "&buflisted")'), 'n')
  if len(tab_listed_bufs) > 1
    let next_index = index(tab_listed_bufs, bufnr('%')) + len(tab_listed_bufs) + (a:callback == 'bn' ? 1 : -1)
    let next_index = float2nr(fmod(next_index, len(tab_listed_bufs)))
    execute 'b'.tab_listed_bufs[next_index]
    return
  endif

  let current_winnr = winnr()
  if a:callback == 'bn'
    " switch to next window
    " or to topleft window if currently at the last window
    execute "normal! \<C-w>".(current_winnr == len(getwininfo()) ? "t" : "l")
    return
  endif

  if a:callback == 'bp'
    " switch to previous window
    " or to bottomright window if currently at the first window
    execute "normal! \<C-w>".(current_winnr == 1 ? "b" : "h")
    return
  endif

  execute a:callback
endfunction
