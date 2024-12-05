"=============================
" Defx, vimfiler alternative
"=============================
nnoremap <silent> <leader>e :call <SID>defx_expand()<CR>

augroup defx_config
  autocmd!
  " open filer at startup if no specified file
  autocmd VimEnter *
        \ if len(getbufinfo()) == 1 && empty(getbufinfo('%')[0].name) |
        \ Defx |
        \ endif
  autocmd FileType defx call s:defx_set_mapping()
  autocmd TabNewEntered * :Defx
augroup END

call defx#custom#option('_', {
      \ 'winwidth': 50,
      \ 'split': 'vertical',
      \ 'direction': 'rightbelow',
      \ })

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': '',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

" Expand Defx to the current path
function! s:defx_expand() abort
  if empty(&buflisted)
    return
  endif

  let bufnr = bufnr('%')
  if empty(bufname(bufnr))
    " empty new buffer
    return
  endif

  let current_file_path = expand('%:p')
  let current_path = escape(expand('%:p:h'), ' :')
  let cmd_search = 'Defx -search-recursive=' ..current_file_path
  let cmd_search_globally = 'Defx ' .. current_path .. ' -search-recursive=' .. current_file_path

  exec cmd_search
  if current_file_path != defx#get_candidate().action__path
    exec cmd_search_globally
  endif
endfunction

" Open the file in diff mode
function! s:open_diff() abort
  call win_execute(win_getid(1), "vert diffsplit ". defx#get_candidate().action__path)
  wincmd t
endfunction

" Open the file in a column
function! s:open_split() abort
  call win_execute(win_getid(1), "vert split ". defx#get_candidate().action__path)
  wincmd t
endfunction

" Define mappings in the Defx buffer
function! s:defx_set_mapping() abort
  nnoremap <nowait> <buffer> <silent> <C-l> <C-w>w
  nnoremap <nowait> <buffer> <silent> <C-h> <C-w>w
  " tree navigation
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> l
        \ defx#is_directory() ?
        \ defx#do_action('open_tree') :
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> h
        \ defx#is_opened_tree() ?
        \ defx#do_action('close_tree') :
        \ defx#get_candidate().level == 0 ?
        \ defx#do_action('cd', ['..']) :
        \ defx#do_action('multi', [
        \ ['search', fnamemodify(defx#get_candidate().action__path, ':h')],
        \ 'close_tree'
        \ ])
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('search', fnamemodify(defx#get_candidate().action__path, ':h'))
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd', [getcwd()])
  " file manipulation
  nnoremap <nowait><silent><buffer><expr> y
        \ defx#do_action('copy')
  nnoremap <nowait><silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <nowait><silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> gm
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> gn
        \ defx#do_action('new_file')
  nnoremap <nowait><silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <nowait><silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <nowait><silent><buffer><expr> x
        \ defx#do_action('yank_path')
  " selection
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  " utils
  nnoremap <nowait><silent><buffer><expr> i
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> T
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> gp
        \ defx#do_action('print')
  " Open the file in diff mode
  nnoremap <nowait><silent><buffer> D :call <SID>open_diff()<CR>
  nnoremap <nowait><silent><buffer> v :call <SID>open_split()<CR>
  " tmp
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <nowait><silent><buffer> c
        \ :exec 'tcd '.(
        \ defx#is_directory() ?
        \ defx#get_candidate().action__path :
        \ fnamemodify(defx#get_candidate().action__path, ':h')
        \ )<CR>
endfunction
