"=============================
" vim-gitgutter
"=============================
let g:gitgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_close_preview_on_escape = 1

nmap ,. <Plug>(GitGutterNextHunk)
nmap ., <Plug>(GitGutterPrevHunk)

nmap ,a <Plug>(GitGutterPreviewHunk)
nmap ,s <Plug>(GitGutterStageHunk)
nmap ,u <Plug>(GitGutterUndoHunk)

highlight SignColumn guibg=#000000 ctermbg=0
highlight GitGutterAdd    guifg=#78bd7a ctermfg=2
highlight GitGutterChange guifg=#2d8bff ctermfg=6
highlight GitGutterDelete guifg=#c51919 ctermfg=1
highlight GitGutterChangeDelete guifg=#875fd7 ctermfg=5

highlight link GitGutterAddLineNr GitGutterAdd
highlight link GitGutterChangeLineNr GitGutterChange
highlight link GitGutterDeleteLineNr GitGutterDelete
highlight link GitGutterChangeDeleteLineNr GitGutterChangeDelete

" color for preview window
highlight DiffAdded guifg=#afffaf ctermfg=157
highlight DiffRemoved guifg=#ffd7d7 ctermfg=224
