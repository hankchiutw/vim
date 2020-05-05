autocmd BufWinEnter * call s:track_current_file()
autocmd FileType vimfiler setlocal nocursorcolumn

" Keep tracking current file in vimfiler tree
function! s:track_current_file() abort
  if !empty(&buftype)
    return
  endif

  " find the vimfiler window
  let winnr = winnr('$')
  while winnr > 0
    if getwinvar(winnr, '&filetype') ==# 'vimfiler'
      let bufnr = bufnr('%')
      let file_path = expand('#' . bufnr . ':p')
      " switch to vimfiler window and move cursor
      exec winnr . 'wincmd w'
      call vimfiler#mappings#search_cursor(file_path)
      wincmd p
      return
    endif
    let winnr -= 1
  endwhile
endfunction
