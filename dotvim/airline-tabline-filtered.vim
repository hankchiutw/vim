
" enhance tabline to show tabpage buffers instead of all buffers
set showtabline=2
set tabline=%!AirlineTablineFiltered()
autocmd VimEnter * :call airline#extensions#tabline#load_theme(g:airline#themes#{g:airline_theme}#palette)
function! AirlineTablineFiltered()
  let b = airline#extensions#tabline#new_builder()
  let b.tab_bufs = tabbuffers#get()

  let show_buf_label_first = 0
  if get(g:, 'airline#extensions#tabline#buf_label_first', 0)
    let show_buf_label_first = 1
  endif
  if show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers')
  endif

  let b.overflow_group = 'airline_tabhid'
  let b.buffers = sort(filter(map(keys(gettabvar(tabpagenr(), 'tabpagebuffer')), 'str2nr(v:val)'), 'getbufvar(v:val, "&buflisted")'), 'n')

  function! b.get_group(i) dict
    let bufnum = get(self.buffers, a:i, -1)
    if bufnum == -1
      return ''
    endif
    let group = airline#extensions#tabline#group_of_bufnr(self.tab_bufs, bufnum)
    return group
  endfunction

  function! b.get_title(i) dict
    let spc = g:airline_symbols.space
    let bufnum = get(self.buffers, a:i, -1)
    let group = self.get_group(a:i)
    let pgroup = self.get_group(a:i - 1)
    " always add a space when powerline_fonts are used
    " or for the very first item
    if get(g:, 'airline_powerline_fonts', 0) || a:i == 0
      let space = spc
    else
      let space= (pgroup == group ? spc : '')
    endif

    return space.'%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)'.spc
  endfunction

  let current_buffer = max([index(b.buffers, bufnr('%')), 0])
  let last_buffer = len(b.buffers) - 1
  call b.insert_titles(current_buffer, 0, last_buffer)

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')

  call airline#extensions#tabline#add_tab_label(b)
  let tabline = b.build()

  return tabline
endfunction
