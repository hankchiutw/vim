
" XXX: consider caching the result
function! tabbuffers#get()
  let tabbufs = map(keys(gettabvar(tabpagenr(), 'tabpagebuffer')), 'str2nr(v:val)')
  let tab_listed_bufs = sort(filter(tabbufs, 'getbufvar(v:val, "&buflisted")'), 'n')
  return tab_listed_bufs
endfunction

function! tabbuffers#switch(bn_or_bp)
  let tab_listed_bufs = tabbuffers#get()
  let current_index = index(tab_listed_bufs, bufnr('%'))
  let next_index = current_index + (a:bn_or_bp == 'bn' ? 1 : -1)
  if next_index >= len(tab_listed_bufs)
    let next_index = 0
  endif
  if next_index < 0
    let next_index = len(tab_listed_bufs) - 1
  endif
  let next_bufnr = tab_listed_bufs[next_index]
  exec 'b'.next_bufnr
endfunction
