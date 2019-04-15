"=============================
" SmartQuit
"=============================
" handy quit and write
nnoremap Q ZQ
nnoremap <silent> q :call SmartQuit()<CR>

" return to normal mode, like <Esc>
inoremap <C-w><C-i> <C-\><C-n>
inoremap <C-w>i <C-\><C-n>
vnoremap <C-w><C-i> <C-\><C-n>
vnoremap <C-w>i <C-\><C-n>

inoremap <C-w><C-e> <C-\><C-n>:w<CR>
inoremap <C-w>d <C-\><C-n>:w<bar>call SmartQuit()<CR>
inoremap <C-w><C-d> <C-\><C-n>:w<bar>call SmartQuit()<CR>

nnoremap <C-w><C-e> :w<CR>
nnoremap <C-w>d :w<bar>call SmartQuit()<CR>
nnoremap <C-w><C-d> :w<bar>call SmartQuit()<CR>

nnoremap <silent> W :w<bar>call SmartQuit()<CR>
function! SmartQuit()
  let is_file = empty(&buftype)

  if is_file
    lclose
  endif

  " quit current window if one of following true:
  " 1. non-file buffer
  " 2. the only one window
  " 3. not the first window
  " Note: assume topleft is the main buffer area
  if !is_file || winnr('$') == 1 || winnr() > 1
    q!
    return
  endif

  let listed_bufs = getbufinfo({'buflisted':1})
  if len(listed_bufs) > 1
    " more than one buffer, switch to next or before
    if bufnr('%') == listed_bufs[0].bufnr
      bn
    else
      bp
    endif
    bd! #
  elseif empty(getbufinfo('%')[0].name)
    " only one empty buffer, quit all
    qa!
  else
    " only one non-empty buffer, switch to empty buffer
    enew | bd! #
  endif
endfunction
