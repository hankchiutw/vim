" restore yanked register
xnoremap p pgvy
" use black hole register to avoid overwrite clipboard
nnoremap x "_x
nnoremap d "_d
nnoremap dd dd
nnoremap c "_c
nnoremap s "_s

" search and count matches
nnoremap <expr> * ':%s/'.fnameescape(expand('<cword>')).'//gn<CR>``'
" prompt substitute with current word
nnoremap <expr> gs '*``:%s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'
" prompt substitude(current line) with current word
nnoremap <expr> gr '*``:s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'

" short key to jump cursor up/down half of current line to screen top/bottom
noremap <expr> R (line('w0')+line('.'))/2.'G'
noremap <expr> F (line('w$')+line('.'))/2.'G'

" handy keymap for file saving
inoremap <C-w><C-e> <C-\><C-n>:w<CR>
nnoremap <C-w><C-e> :w<CR>

" jump to the first non-empty char
nnoremap 1 ^

" copy current file path(relative) to system clipboard
nnoremap <c-g>c :let @+ = expand('%') \| echo 'copied string '.@+<CR>

" search the selected text
vnoremap // y/\V<C-R>"<CR>
" prompt substitude with the selected text
vnoremap /s y/\V<C-R>"<CR>:%s/\V<C-R>"//g<Left><Left>

" magic search: use \V to escape special characters
nnoremap / /\V
cnoremap %s/ %s/\V

" tab-page related mapping
nmap <C-g><C-g> :tabnew<CR>
nmap <C-g><C-l> :tabn<CR>
nmap <C-g><C-h> :tabp<CR>
imap <C-g><C-g> <C-\><C-n>:tabnew<CR>
imap <C-g><C-l> <C-\><C-n>:tabn<CR>
imap <C-g><C-h> <C-\><C-n>:tabp<CR>

" show the last commit details of current line in Terminal-mode
nnoremap <expr><c-g>s ':te git sh '.<SID>blame_line().'i'
function! s:blame_line() abort
  let range = line('.').','.line('.')
  let command = 'git blame -s -L '.range.' '.expand('%').' | cut -d " " -f 1'
  let line_commit = system(command)
  return line_commit
endfunction
