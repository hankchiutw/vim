"=============================
" SmartQuit
"=============================
" handy quit and write
nnoremap Q ZQ
nnoremap <silent> q :call SmartQuit()<CR>
vnoremap Q ZQ
vnoremap <silent> q :call SmartQuit()<CR>

" return to normal mode, like <Esc>
inoremap <C-f> <C-\><C-n>
vnoremap <C-i> <C-\><C-n>

inoremap <C-w><C-e> <C-\><C-n>:w<CR>
inoremap <C-w>d <C-\><C-n>:w<bar>call SmartQuit()<CR>
inoremap <C-w><C-d> <C-\><C-n>:w<bar>call SmartQuit()<CR>

nnoremap <C-w><C-e> :w<CR>
nnoremap <C-w>d :w<bar>call SmartQuit()<CR>
nnoremap <C-w><C-d> :w<bar>call SmartQuit()<CR>

nnoremap <silent> W :w<bar>call SmartQuit()<CR>

function! SmartQuit()
  let is_file = empty(&buftype)

  " quit current window if non-file buffer
  if !is_file
    q!
    return
  endif

  lclose

  let tab_listed_bufs = tabbuffers#get()
  if len(tab_listed_bufs) > 1
    let is_first = bufnr('%') == tab_listed_bufs[0]
    call tabbuffers#switch(is_first ? 1 : -1)
    bd! #
  elseif winnr('$') == 1
    " only one window and one buffer
    q!
  elseif empty(getbufinfo('%')[0].name)
    " only one empty buffer
    if tabpagenr('$') > 1
      " more than one tabpage
      tabc
    else
      qa!
    endif
  else
    " only one non-empty buffer, switch to empty buffer
    enew | bd! #
  endif
endfunction
