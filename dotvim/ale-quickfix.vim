"=============================
" ale quickfix enhancement
"=============================
" originated from ale/autoload/list.vim

autocmd TextChanged * :call s:refresh_quickfix(0)
autocmd TextChangedI * :call s:refresh_quickfix(0)
autocmd CursorHold * :call s:refresh_quickfix(0)
autocmd CursorHoldI * :call s:refresh_quickfix(0)
autocmd BufWritePost * :call s:refresh_quickfix(0)
" need some delay to get non-empty quickfix list
autocmd BufEnter * :call s:refresh_quickfix(50)

" Do OpenQuickfix asynchronously
function! s:refresh_quickfix(delay) abort
  call timer_start(a:delay, 'OpenQuickfix')
endfunction

function! OpenQuickfix(timer) abort
  if !g:ale_set_quickfix || !empty(&buftype)
    return
  endif

  if empty(getqflist())
    cclose
    return
  endif

  let l:quickfix_list = s:get_loclist()
  let l:bufnr = bufnr('%')
  let l:title = expand('#' . l:bufnr . ':p')

  if has('nvim')
    call setqflist(s:FixList(l:bufnr, l:quickfix_list), ' ', l:title)
  else
    call setqflist(s:FixList(l:bufnr, l:quickfix_list))
    call setqflist([], 'r', {'title': l:title})
  endif

  let l:winnr = winnr()
  if !s:tab_has_quickfix()
    " open quickfix full width
    silent! execute 'botright copen ' . str2nr(ale#Var(l:bufnr, 'list_window_size'))
  endif

  " If focus changed, restore it (jump to the last window).
  if l:winnr isnot# winnr()
    wincmd p
  endif

endfunction

function! s:FixList(buffer, list) abort
  let l:format = ale#Var(a:buffer, 'loclist_msg_format')
  let l:new_list = []

  for l:item in a:list
    let l:fixed_item = copy(l:item)

    let l:fixed_item.text = ale#GetLocItemMessage(l:item, l:format)

    if l:item.bufnr == -1
      " If the buffer number is invalid, remove it.
      call remove(l:fixed_item, 'bufnr')
    endif

    call add(l:new_list, l:fixed_item)
  endfor

  return l:new_list
endfunction

function! s:get_loclist() abort
  let l:list = []

  for l:info in values(g:ale_buffer_info)
    call extend(l:list, l:info.loclist)
  endfor

  call sort(l:list, function('ale#util#LocItemCompareWithText'))
  call uniq(l:list, function('ale#util#LocItemCompareWithText'))

  return l:list
endfunction

" Check if current tab has the quickfix window
function! s:tab_has_quickfix()
  for l:buf in tabpagebuflist()
    if getbufvar(l:buf, '&buftype') is# 'quickfix'
      return 1
    endif
  endfor

  return 0
endfunction
