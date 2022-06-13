"=============================
" ALE syntax checker, replace syntastic
"=============================
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%s (%code%) [%linter%] [%severity%]'
let g:ale_sign_error = '🚫'
let g:ale_sign_warning = '💀'
let g:ale_sign_info = '🔆'
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'typescript': ['tsserver', 'eslint', 'tslint'],
  \ 'javascript': ['tsserver', 'eslint'],
  \ 'cs': ['OmniSharp'],
  \ 'vue': ['eslint'],
  \ 'json': ['prettier'],
  \ 'python': ['flake8', 'pylint']
  \ }
let g:ale_fixers = {
  \ 'typescript': ['prettier', 'eslint', 'tslint'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'cs': ['OmniSharp'],
  \ 'vue': ['eslint'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier'],
  \ 'json': ['prettier'],
  \ 'python': ['autoflake', 'isort', 'black']
  \ }
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 1
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 50
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '♰ '
highlight ALEVirtualTextError ctermfg=9 guifg=#ff0000
highlight ALEVirtualTextWarning ctermfg=11 guifg=#ffff00
highlight ALEErrorSign ctermfg=NONE guifg=NONE
highlight ALEWarningSign ctermfg=NONE guifg=NONE

" auto close location list if no buffers, but seems buggy
" autocmd QuitPre * if empty(&bt) | lclose | endif
let g:ale_keep_list_window_open = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_set_lists_synchronously = 1
" let dotvim/ale-quickfix.vim handle the quickfix window
let g:ale_open_list = 0
" let quickfix window be full width. Note: buggy when switching tabs
" autocmd filetype qf wincmd J

nnoremap <leader>x :ALEFix<CR>
" nmap <silent> .. <Plug>(ale_previous_wrap)
" nmap <silent> ,, <Plug>(ale_next_wrap)

" when having ale_lint_on_enter = 0, watch the BufAdd to lint a buffer once
augroup my_ale
  au!
  autocmd BufAdd * ALELint
augroup END
