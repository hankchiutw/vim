"=============================
" vim-airline
"=============================
let g:airline_extensions = ['branch']
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '  '
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_close_button = 0
" use buffer type tabs instead of tabpages
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buf_label_first = 1
let g:airline#extensions#tabline#buffers_label = '»'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s・'
let g:airline_theme='base16_summerfruit'

" set show_tabs=1 to use tabpages
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#tabs_label = '»'

let g:airline#extensions#branch#displayed_head_limit = 20
let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'i'      : '🅸',
    \ 'ic'     : '🅸',
    \ 'ix'     : '🅸',
    \ 'n'      : '🅽',
    \ 'ni'     : '🅽',
    \ 'no'     : '🅽',
    \ 'R'      : '🆁',
    \ 'Rv'     : '🆁',
    \ 's'      : '🆂',
    \ 'S'      : '🆂',
    \ ''     : '🆂',
    \ 'v'      : '🆅',
    \ 'V'      : '🆅',
    \ ''     : '🆅',
    \ }
