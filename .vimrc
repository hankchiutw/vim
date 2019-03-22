if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'prettier/vim-prettier'
Plug 'dart-lang/dart-vim-plugin'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'leafgarland/typescript-vim'
Plug 'zivyangll/git-blame.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'hankchiutw/flutter-reload.vim'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ryanolsonx/vim-lsp-typescript'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/vim-jsx-improve'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'gcmt/wildfire.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()

set nocompatible
set hidden
set number
set encoding=utf-8
set autoread
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set foldmethod=indent
set foldlevelstart=20

" handy copy to clipboard without "*y
set clipboard=unnamed
" auto indent pasting
nnoremap p p=`]
" restore yanked register
xnoremap p pgvy

" for webpack file watching
set backupcopy=yes

" tab
set tabstop=2
set shiftwidth=2
set expandtab

autocmd colorscheme * highlight CursorLine cterm=none ctermbg=235
autocmd colorscheme * highlight CursorColumn ctermbg=235
autocmd colorscheme * highlight IndentGuidesOdd ctermbg=235
autocmd colorscheme * highlight IndentGuidesEven ctermbg=235
colorscheme torte

au BufNewFile,BufRead *.jsm set filetype=javascript

" remove trailing space on save
autocmd BufWritePre *.js :%s/\s\+$//e

" searching selected by //
vnoremap // y/<C-R>"<CR>

autocmd BufEnter :lcd %:p:h

au BufRead,BufNewFile *.ejs set filetype=html

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" Use `:profile pause` when done
" The log file will be created after vim quit.
command! ProfileStart :profile start /tmp/vim-profile.log<bar>profile func *<bar>profile file*<CR>

"=============================
" SmartQuit
"=============================
" handy quit and write
nnoremap Q ZQ
nnoremap <silent> q :call SmartQuit()<CR>

" return to normal mode, like <Esc>
inoremap <C-w><C-i> <C-\><C-n>
inoremap <C-w>i <C-\><C-n>
vnoremap <C-w><C-i> <C-\><C-n>
vnoremap <C-w>i <C-\><C-n>

inoremap <C-w><C-e> <C-\><C-n>:w<CR>
inoremap <C-w>d <C-\><C-n>:w<bar>call SmartQuit()<CR>
inoremap <C-w><C-d> <C-\><C-n>:w<bar>call SmartQuit()<CR>

nnoremap <C-w><C-e> :w<CR>
nnoremap <C-w>d :w<bar>call SmartQuit()<CR>
nnoremap <C-w><C-d> :w<bar>call SmartQuit()<CR>

nnoremap <silent> W :w<bar>call SmartQuit()<CR>
function! SmartQuit()
  let is_file = empty(&buftype)

  if is_file
    lclose
  endif

  " quit current window if one of following true:
  " 1. non-file buffer
  " 2. the only one window
  " 3. not the first window
  " Note: assume topleft is the main buffer area
  if !is_file || winnr('$') == 1 || winnr() > 1
    q!
    return
  endif

  let listed_bufs = getbufinfo({'buflisted':1})
  if len(listed_bufs) > 1
    " more than one buffer, switch to next or before
    if bufnr('%') == listed_bufs[0].bufnr
      bn
    else
      bp
    endif
    bd! #
  elseif empty(getbufinfo('%')[0].name)
    " only one empty buffer, quit all
    qa!
  else
    " only one non-empty buffer, switch to empty buffer
    enew | bd! #
  endif
endfunction

"=============================
" Buffer related mapping
"=============================
" enhance buffer navigation
noremap <silent> <C-l> :call SwitchBuffer('bn')<CR>
noremap <silent> <C-h> :call SwitchBuffer('bp')<CR>
" unlist quickfix buffer so that we will not navigate to it
autocmd FileType qf setlocal nobuflisted

" Do <C-w>l or <C-w>h if only one buffer
function! SwitchBuffer(callback)
  if empty(&buflisted)
    return
  endif

  let listed_bufs = getbufinfo({'buflisted':1})
  if len(listed_bufs) > 1
    execute a:callback
    return
  endif

  let current_winnr = winnr()
  if a:callback == 'bn'
    " switch to next window
    " or to topleft window if currently at the last window
    execute "normal! \<C-w>".(current_winnr == len(getwininfo()) ? "t" : "l")
    return
  endif

  if a:callback == 'bp'
    " switch to previous window
    " or to bottomright window if currently at the first window
    execute "normal! \<C-w>".(current_winnr == 1 ? "b" : "h")
    return
  endif

  execute a:callback
endfunction

"=============================
" Terminal window related mapping
"=============================
autocmd TerminalOpen *
      \ if &buftype == 'terminal' |
      \ setlocal nobuflisted |
      \ setlocal noequalalways |
      \ endif
" autocmd TerminalOpen * exec setbufvar(expand('<abuf>'), '&buflisted', 0)
nnoremap <leader>t :tab term<CR>
" a consistent way to loop all tabs
" Note: `gt` not work in |Terminal-Job| mode
nmap <C-g><C-l> :call SwitchTerm('tabn')<CR>
nmap <C-g><C-h> :call SwitchTerm('tabp')<CR>
nmap <C-g><C-j> :call ToggleTerm()<CR>
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

"=============================
" Plugin settings
"=============================

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

" vimpager
let g:vimpager = {}
let g:less     = {}
let g:vimpager.X11 = 0

" Taglist alias and auto open
map <leader>g :TlistToggle<CR>
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

" dart-vim-plugin
let g:loaded_syntastic_dart_dartanalyzer_checker = 0
autocmd BufWritePre *.dart DartFmt

"=============================
" vim-airline
"=============================
let g:airline_extensions = ['branch', 'tabline']
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

" set show_tabs=1 to use tabpages
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number 
let g:airline#extensions#tabline#tabs_label = '»'

let g:tmuxline_preset = {
      \ 'b': ['%Y-%m-%d %R:%S %a'],
      \ 'win': ['#I #W'],
      \ 'cwin': ['#I #W'],
      \ 'y': '#S'}

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" ctrlp
let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|dist|distRelease|bower_components|minify$',
  \ 'file': '\v\.(exe|so|dll|zip|min.js|min.css)$',
  \ }
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" let g:ctrlp_user_command = 'find %s -type f'
" let g:ctrlp_user_command = 'rg %s --files -g ""'

" ctrlsf
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
" for Vim 8.0+
let g:ctrlsf_search_mode = 'async'

nmap     <C-G>g <Plug>CtrlSFPrompt
" search word under the cursor immediately
nmap     <C-G>v <Plug>CtrlSFCwordExec 
" prompt searching word under the cursor
nmap     <C-G>b <Plug>CtrlSFCwordPath 
" search current selected word immediately
vmap     <C-G>v <Plug>CtrlSFVwordExec
" prompt searching current selected word
vmap     <C-G>b <Plug>CtrlSFVwordPath
nmap     <C-G>p <Plug>CtrlSFPwordPath
nnoremap <C-G>o :CtrlSFOpen<CR>
nnoremap <C-G>t :CtrlSFToggle<CR>
inoremap <C-G>t <Esc>:CtrlSFToggle<CR>

"=============================
" ALE syntax checker, replace syntastic
"=============================
let g:ale_completion_enabled = 1
let g:ale_lint_delay = 1000
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%s (%code%) [%linter%] [%severity%]'
let g:ale_open_list = 1
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 0
let g:ale_set_highlights = 0
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1

nnoremap <leader>f :ALEFix<CR>
nmap <silent> .. <Plug>(ale_previous_wrap)
nmap <silent> ,, <Plug>(ale_next_wrap)

" vim-lsp
nnoremap <C-j> :LspDefinition<CR>
nnoremap <C-k> :LspReferences<CR>

" vim-gitgutter
let g:gitgutter_highlight_lines = 0

" git-blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" wildfire
" This selects the next closest text object.
map <SPACE> <Plug>(wildfire-fuel)
" This selects the previous closest text object.
vmap - <Plug>(wildfire-water)
let g:wildfire_objects = {
      \ "*" : ["i'", 'i"', "i)", "i]", "i}", "i>", "at", "it"]
      \ }

" auto-pair and closetag
let g:closetag_filenames = "*.html,*.js,*.jsx"
let g:AutoPairsShortcutFastWrap = "<C-w><C-l>"

" ycm and ultisnips
let g:ycm_confirm_extra_conf = 0 
let g:UltiSnipsExpandTrigger="<C-j>"

" vimfiler, NERDTree alternative
let g:vimfiler_no_default_key_mappings = 1
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
call vimfiler#custom#profile(
      \ 'default',
      \ 'context',
      \ {
      \	'explorer': 1,
      \	'safe': 0,
      \	'status': 1,
      \	'direction': 'rightbelow',
      \	'toggle': 1,
      \	'parent': 1,
      \	'split': 1,
      \	'winwidth': 50,
      \ }
      \ )
" open vimfiler at startup if no specified file
autocmd VimEnter *
      \ if len(getbufinfo()) == 1 && empty(getbufinfo('%')[0].name) |
      \ call ToggleVimFiler() |
      \ endif
map <silent> <leader>e :call ToggleVimFiler()<CR>
function! ToggleVimFiler()
  execute "VimFilerExplorer -winwidth=50"
endfunction

autocmd FileType vimfiler :call SetupVimFiler()
function! SetupVimFiler()
  setlocal nobuflisted
  nmap <buffer> <silent> i <Plug>(vimfiler_toggle_visible_ignore_files)
  nmap <buffer> <silent> <C-l> <C-w>w
  nmap <buffer> <silent> <C-h> <C-w>w
  nmap <buffer> <silent> l <Plug>(vimfiler_smart_l)
  nmap <buffer> <silent> h <Plug>(vimfiler_smart_h)
  nmap <buffer> <silent> J <Plug>(vimfiler_jump_last_child)
  nmap <buffer> <silent> K <Plug>(vimfiler_jump_first_child)
  nmap <buffer> <silent> ? <Plug>(vimfiler_help)
  nmap <buffer> <silent> r <Plug>(vimfiler_rename_file)
  nmap <buffer> <silent> t <Plug>(vimfiler_cd_or_edit)
  nmap <buffer> <silent> <CR> <Plug>(vimfiler_cd_or_edit)
  nmap <buffer> <silent> C <Plug>(vimfiler_cd_or_edit)
  nmap <buffer> <silent> d <Plug>(vimfiler_delete_file)
  nmap <buffer> <silent> y <Plug>(vimfiler_clipboard_copy_file)
  nmap <buffer> <silent> m <Plug>(vimfiler_clipboard_move_file)
  nmap <buffer> <silent> p <Plug>(vimfiler_clipboard_paste)
  nmap <buffer> <silent> <Space> <Plug>(vimfiler_toggle_mark_current_line)
  nmap <buffer> <silent> U <Plug>(vimfiler_clear_mark_all_lines)
  nmap <buffer> <silent> gc <Plug>(vimfiler_cd_vim_current_dir)
  nmap <buffer> <silent> gm <Plug>(vimfiler_make_directory)
  nmap <buffer> <silent> gn <Plug>(vimfiler_new_file)
  nmap <buffer> <silent> <C-g> <Plug>(vimfiler_print_filename)
endfunction
