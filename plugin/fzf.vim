"=============================
" fzf.vim
"=============================
let g:fzf_layout = { 'down': '80%' }
noremap <leader>f :Files<CR>
noremap <leader>g :Ag<CR>

" Make this respect FZF_DEFAULT_OPTS
" By default, Files command uses fzf#vim#with_preview and it doesn't load FZF_DEFAULT_OPTS
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {}, <bang>0)

let s:preview_cmd = '~/'.(has('nvim') ? '.config/nvim' : '.vim').'/plugged/fzf.vim/bin/preview.sh {}'
" search file contents only
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': ['--preview', s:preview_cmd, '--nth', '4..']}, <bang>0)

" always open the file in topleft window
" (to avoid opening in vimfiler window)
let g:fzf_action = {
      \ 'enter': 'wincmd t | e' }
