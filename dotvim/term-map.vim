
"=============================
" Terminal window related mapping
"=============================
" XXX: unstable, disable for now
let g:use_term_map = 0
autocmd TerminalOpen *
      \ if &buftype == 'terminal' |
      \ setlocal nobuflisted |
      \ setlocal noequalalways |
      \ endif
" autocmd TerminalOpen * exec setbufvar(expand('<abuf>'), '&buflisted', 0)
nnoremap <leader>t :tab term<CR>
" a consistent way to loop all tabs
" Note: `gt` not work in |Terminal-Job| mode
if g:use_term_map
  nmap <C-g><C-l> :call SwitchTerm('tabn')<CR>
  nmap <C-g><C-h> :call SwitchTerm('tabp')<CR>
  nmap <C-g><C-j> :call ToggleTerm()<CR>
endif

tmap <C-g><C-l> <C-w>:call SwitchTerm('tabn')<CR>
tmap <C-g><C-h> <C-w>:call SwitchTerm('tabp')<CR>
tmap <C-g><C-j> <C-w>:q<CR>

" switch to |Terminal-Normal| mode
tmap <C-w><C-i> <C-w>N<CR>
tmap <C-w>i <C-w>N<CR>
tmap <C-w><C-e> <C-w>N<CR>
tmap <C-w>e <C-w>N<CR>

" Switch to the next terminal window.
" If no terminal window exists, create one.
function! SwitchTerm(callback)
  " let term_wins = filter(getwininfo(), 'v:val.terminal == 1')
  let term_bufs = filter(getbufinfo({'buflisted':0}), 'getbufvar(v:val.bufnr, "&buftype") == "terminal"')
  if empty(term_bufs)
    tab term
    return
  endif

  " has terminal buffer, but no tabpage
  " open a tabpage and attach the terminal buffer
  if tabpagenr('$') == 1
    execute "tab sb" . term_bufs[0].bufnr
    return
  endif

  " has terminal buffer and tabpage
  execute a:callback
endfunction

" Toggle terminal window at bottom
" XXX: set var for main buffer window
function! ToggleTerm()
  let term_bufs = filter(getbufinfo({'buflisted':0}), 'getbufvar(v:val.bufnr, "&buftype") == "terminal"')
  " no terminal buffer, create one and show at bottom
  if empty(term_bufs)
    bot exec term_start('bash', {
          \'term_rows': 10,
          \})
    return
  endif

  " has terminal at bottom
  let bot_win = getwininfo(win_getid(winnr('$')))[0]
  if bot_win.terminal == 1
    execute win_gotoid(bot_win.winid)
    return
  endif

  " open terminal buffer at bottom
  execute "bot sb" . term_bufs[0].bufnr . "\<bar>resize 10"
endfunction
