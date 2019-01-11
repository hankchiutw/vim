" for nerdtree and others
execute pathogen#infect()

syntax on
set number
set autoread
set cursorline
set cursorcolumn
autocmd colorscheme * highlight CursorLine cterm=none ctermbg=235
autocmd colorscheme * highlight CursorColumn ctermbg=235

colorscheme torte

filetype plugin on
au BufNewFile,BufRead *.jsm set filetype=javascript

" remove trailing space on save
autocmd BufWritePre *.js :%s/\s\+$//e

" highlight searching
set hlsearch

" follow when typing
set incsearch

" searching selected by //
vnoremap // y/<C-R>"<CR>

" handy copy to clipboard without "*y
" need to have `+clipboard`, check by using `:echo has('clipboard')`
set clipboard=unnamed

" for webpack file watching
set backupcopy=yes

" handy quit and write
nnoremap Q ZQ
nnoremap W ZZ

" NERDTree alias and auto open
map <leader>e :NERDTreeToggle<CR>
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
" effectively no split
let g:NERDTreeWinSize=10000
autocmd BufEnter :lcd %:p:h
"autocmd vimenter :NERDTree
au BufRead,BufNewFile *.ejs set filetype=html
" to fix broken arrows
"let g:NERDTreeDirArrows=0
set encoding=utf-8

" always open file in a new(or existing) tab
function NERDTreeMyOpenTab(node)
  call a:node.activate({'reuse': 1, 'where': 't'})
endfunction
autocmd VimEnter * :call NERDTreeAddKeyMap({ 'key': 't', 'callback': 'NERDTreeMyOpenTab', 'scope': 'FileNode', 'override': 1 })

let g:NERDTreeChDirMode=2

" Taglist alias and auto open
map <leader>t :TlistToggle<CR>
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1

" winmanager alias and auto open
map <leader>w :WMToggle<CR>
let g:winManagerWindowLayout = "FileExplorer|TagList|,BufExplorer"
"let g:winManagerWindowLayout = "NERDTree|TagList|,BufExplorer"
let g:winManagerWidth = 30

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r
" set foldmethod=indent
" set foldlevelstart=20

" tern for autocompletetion
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

" tab
set tabstop=2
set shiftwidth=2
set expandtab

set nocompatible
filetype plugin on
runtime macros/matchit.vim
" filetype detect

" vimpager
let g:vimpager = {}
let g:less     = {}
let g:vimpager.X11 = 0

" dart-vim-plugin
let g:loaded_syntastic_dart_dartanalyzer_checker = 0
autocmd BufWritePre *.dart DartFmt

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '・'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number 
let g:airline#extensions#tabline#tabs_label = '»'
let g:airline#extensions#tabline#show_close_button = 0
let g:tmuxline_preset = {
      \ 'b': ['%Y-%m-%d %R:%S %a'],
      \ 'win': ['#I #W'],
      \ 'cwin': ['#I #W'],
      \ 'y': '#S'}

" auto indent pasting
nnoremap p p=`]

" restore yanked register
xnoremap p pgvy

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

" ALE syntax checker, replace syntastic
let g:ale_completion_enabled = 1
let g:ale_lint_delay = 1000
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%s (%code%) [%linter%] [%severity%]'
let g:ale_open_list = 1
let g:ale_javascript_eslint_executable='/Users/hank/.nvm/versions/node/v8.9.4/bin/eslint_d'
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 0

nnoremap <leader>f :ALEFix<CR>
nmap <silent> .. <Plug>(ale_previous_wrap)
nmap <silent> ,, <Plug>(ale_next_wrap)

" close loclist when associated buffer is closed
autocmd QuitPre * if empty(&bt) | lclose | endif

" autoclose quickfix window
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" vim-lsp
nnoremap <C-M> :LspDefinition<CR>
nnoremap <C-K> :LspReferences<CR>

" vim-gitgutter
let g:gitgutter_highlight_lines = 0

" To install YCM, execute :PluginInstall
" Dismiss after installation completed
" Vundle vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"
let g:ycm_confirm_extra_conf = 0 

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'jreybert/vimagit'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'leafgarland/typescript-vim'
Plugin 'zivyangll/git-blame.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'dyng/ctrlsf.vim'
Plugin 'hankchiutw/flutter-reload.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'w0rp/ale'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'ryanolsonx/vim-lsp-typescript'

" End configuration, makes the plugins available
call vundle#end()
filetype plugin indent on
