"=============================
" vim-surround
"=============================
let g:surround_no_mappings = 1
" surround by replacing
nmap <C-g>s <Plug>Csurround
" delete surround
nmap <C-g>d <Plug>Dsurround
" surround the word
nmap <C-g>w <Plug>Ysurroundiw
" surround by inserting function
nmap <C-g>f <Plug>YsurroundWf
" surround selected
xmap S <Plug>VSurround
" surround selected with wrap
xmap gS <Plug>VgSurround<C-\><C-n>
