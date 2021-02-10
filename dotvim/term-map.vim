"=============================
" Terminal window related mapping
"=============================

" switch to |Terminal-Normal| mode
tnoremap <Esc> <C-\><C-n>


" XXX: unstable below

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
