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
Plug 'MattesGroeger/vim-bookmarks'
Plug 'Shougo/tabpagebuffer.vim'
Plug 'dag/vim-fish'
Plug 'benmills/vimux'
Plug 'suan/vim-instant-markdown'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
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
set ttimeoutlen=0
set nostartofline

" handy copy to clipboard without "*y
set clipboard=unnamed
" auto indent pasting
nnoremap p p=`]
" restore yanked register
xnoremap p pgvy
" use black hole register to avoid overwrite clipboard
nnoremap x "_x
nnoremap d "_d
nnoremap dd dd
nnoremap c "_c
" search and count matches
nnoremap <expr> * ':%s/'.expand('<cword>').'//gn<CR><C-O>'
" prompt substitude with current word
nnoremap <expr> gs '*<C-O>:%s/'.expand('<cword>').'//g<Left><Left>'
" prompt substitude(current line) with current word
nnoremap <expr> gr '*<C-O>:s/'.expand('<cword>').'//g<Left><Left>'

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

" search the selected text
vnoremap // y/<C-R>"<CR>
" prompt substitude with the selected text
vnoremap /s y/<C-R>"<CR>:%s/<C-R>"//g<Left><Left>

au BufRead,BufNewFile *.ejs set filetype=html

autocmd BufNewFile,BufRead * setlocal formatoptions+=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" Use `:profile pause` when done
" The log file will be created after vim quit.
command! ProfileStart :profile start /tmp/vim-profile.log<bar>profile func *<bar>profile file*<CR>

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

"=============================
" vim-instant-markdown
"=============================
" to trigger preview `:InstantMarkdownPreview`
let g:instant_markdown_autostart = 0

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

" set show_tabs=1 to use tabpages
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number 
let g:airline#extensions#tabline#tabs_label = '»'

source ~/.vim/airline-tabline-filtered.vim

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
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'typescript': ['tslint'],
  \ 'javascript': ['eslint', 'flow'],
  \ 'json': ['prettier']
  \ }
let g:ale_fixers = {
  \ 'typescript': ['tslint'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'json': ['prettier']
  \ }
let g:ale_fix_on_save = 0
let g:ale_set_highlights = 0
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1

nnoremap <leader>x :ALEFix<CR>
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
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_show_diagnostics_ui = 0
" to nav up/down in ycm list
let g:ycm_key_list_select_completion = ['<Tab>', '<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-Tab>', '<C-k>', '<Up>']
" to apply(expand) snippet
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsSnippetDirectories=["UltiSnips","mysnippets"]
" let g:UltiSnipsJumpForwardTrigger = "<C-n>"
" let g:UltiSnipsJumpBackwardTrigger = "<C-p>"

"=============================
" tab-page related mapping
"=============================
nmap <C-g><C-g> :call NewTab()<CR>
nmap <C-g><C-l> :tabn<CR>
nmap <C-g><C-h> :tabp<CR>
imap <C-g><C-g> <C-\><C-n>:call NewTab()<CR>
imap <C-g><C-l> <C-\><C-n>:tabn<CR>
imap <C-g><C-h> <C-\><C-n>:tabp<CR>
" open new tab-page with an empty buffer
function! NewTab()
  tabnew
  if exists('g:loaded_vimfiler')
    exec "normal \<Plug>(ToggleVimFiler)"
  endif
endfunction

"=============================
" vimfiler, NERDTree alternative
"=============================
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
      \ execute "normal \<Plug>(ToggleVimFiler)" |
      \ endif
nnoremap <silent> <Plug>(ToggleVimFiler) :VimFilerExplorer -winwidth=50<CR>
nmap <leader>e <Plug>(ToggleVimFiler)

autocmd FileType vimfiler :call SetupVimFiler()
function! SetupVimFiler()
  setlocal nobuflisted
  nmap <nowait> <buffer> <silent> i <Plug>(vimfiler_toggle_visible_ignore_files)
  nmap <nowait> <buffer> <silent> <C-l> <C-w>w
  nmap <nowait> <buffer> <silent> <C-h> <C-w>w
  nmap <nowait> <buffer> <silent> ? <Plug>(vimfiler_help)
  nmap <nowait> <buffer> <silent> R <Plug>(vimfiler_redraw_screen)
  nmap <nowait> <buffer> <silent> T <Plug>(vimfiler_popup_shell)
  nmap <nowait> <buffer> <silent> gf <Plug>(vimfiler_print_filename)
  " tree navigation
  nmap <nowait> <buffer> <silent> l <Plug>(vimfiler_smart_l)
  nmap <nowait> <buffer> <silent> h <Plug>(vimfiler_smart_h)
  nmap <nowait> <buffer> <silent> J <Plug>(vimfiler_jump_last_child)
  nmap <nowait> <buffer> <silent> K <Plug>(vimfiler_jump_first_child)
  nmap <nowait> <buffer> <silent> o <Plug>(vimfiler_edit_file) <C-w><C-p>
  nmap <nowait> <buffer> <silent> <CR> <Plug>(vimfiler_cd_or_edit)
  " node operation
  nmap <nowait> <buffer> <silent> r <Plug>(vimfiler_rename_file)
  nmap <nowait> <buffer> <silent> d <Plug>(vimfiler_delete_file)
  nmap <nowait> <buffer> <silent> y <Plug>(vimfiler_clipboard_copy_file)
  nmap <nowait> <buffer> <silent> m <Plug>(vimfiler_clipboard_move_file)
  nmap <nowait> <buffer> <silent> p <Plug>(vimfiler_clipboard_paste)
  nmap <nowait> <buffer> <silent> <Space> <Plug>(vimfiler_toggle_mark_current_line)
  nmap <nowait> <buffer> <silent> U <Plug>(vimfiler_clear_mark_all_lines)
  nmap <nowait> <buffer> <silent> gm <Plug>(vimfiler_make_directory)
  nmap <nowait> <buffer> <silent> gn <Plug>(vimfiler_new_file)
  " move to directory
  nmap <nowait> <buffer> <silent> C <Plug>(vimfiler_cd_or_edit)<Plug>(vimfiler_cd_vim_current_dir)
  nmap <nowait> <buffer> <silent> ~ <Plug>(vimfiler_switch_to_home_directory)
  nmap <nowait> <buffer> <silent> & <Plug>(vimfiler_switch_to_project_directory)
  nmap <nowait> <buffer> <silent> <C-j> <Plug>(vimfiler_switch_to_history_directory)
  nmap <nowait> <buffer> <silent> <BS> <Plug>(vimfiler_switch_to_parent_directory)
  nmap <nowait> <buffer> <silent> gc <Plug>(vimfiler_cd_vim_current_dir)
endfunction

"=============================
" vimux
"=============================
noremap <leader>a :VimuxPromptCommand<CR>
noremap <leader>r :call VimuxSendKeys('c-c')<CR>:VimuxRunLastCommand<CR>
noremap <leader>vc :call VimuxSendKeys('c-c')<CR>
noremap <leader>vq :VimuxCloseRunner<CR>
noremap <leader>vz :call VimuxZoomRunner()<CR>

"=============================
" fzf.vim
"=============================
noremap <leader>f :Files<CR>
noremap <leader>g :call <sid>fzf_ag()<CR>

" customized Ag search to use our own sink function
function! s:fzf_ag()
  call fzf#run({
        \ 'source': printf('ag --nogroup --column --color "%s"', '^(?=.)'),
        \ 'sink*': function('s:fzf_open'),
        \ 'options': '--ansi --delimiter : --color hl:68,hl+:110',
        \ 'down': '50%'
        \ })
endfunction

" always open the file in topleft window
" (to avoid opening in vimfiler window)
function! s:fzf_open(lines)
  if len(a:lines) < 1 | return | endif
  let parts = split(a:lines[0], ':')
  let line_dict = {
        \ 'filename': parts[0],
        \ 'lnum': get(parts, 1),
        \ 'col': get(parts, 2),
        \ 'text': join(parts[3:], ':')
        \ }
  exec 'wincmd t'
  exec 'e '.line_dict.filename
  exec line_dict.lnum
  exec 'normal! '.line_dict.col.'|'
endfunction
let g:fzf_action = {
      \ 'enter': function('s:fzf_open') }

"=============================
" my draft plugins
"=============================
source ~/.vim/tabbuffers.vim
source ~/.vim/smart-quit.vim
source ~/.vim/switch-buffer.vim
