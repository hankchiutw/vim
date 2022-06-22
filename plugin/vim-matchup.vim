" delete inner
nmap dI di%
" delete outer
nmap dA da%
" edit inner
nmap cI ci%
" edit outer
nmap cA ca%
" yank inner
nmap yI yi%
" yank outer
nmap yA ya%

let g:matchup_matchparen_deferred = 1

augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchParen guibg=copy gui=standout
augroup END
