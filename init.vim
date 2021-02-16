let plug_vim_path = has('nvim') ? '~/.local/share/nvim/site/autoload/plug.vim' : '~/.vim/autoload/plug.vim'
if empty(glob(plug_vim_path))
  silent exec "curl -fLo " . plug_vim_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'prettier/vim-prettier'
Plug 'dart-lang/dart-vim-plugin'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'zivyangll/git-blame.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'hankchiutw/flutter-reload.vim'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'gcmt/wildfire.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'dag/vim-fish'
Plug 'benmills/vimux'
Plug 'suan/vim-instant-markdown'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'ap/vim-css-color'
Plug 'majutsushi/tagbar'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
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
set termguicolors

" to be compatible in fish environment
set sh=bash

" handy copy to clipboard without "*y
set clipboard=unnamed

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Make help window full height
set helpheight=9999

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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
nnoremap <expr> * ':%s/'.fnameescape(expand('<cword>')).'//gn<CR>``'
" prompt substitute with current word
nnoremap <expr> gs '*``:%s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'
" prompt substitude(current line) with current word
nnoremap <expr> gr '*``:s/'.fnameescape(expand('<cword>')).'//g<Left><Left>'

" short key to jump cursor up/down half of current line to screen top/bottom
noremap <expr> R (line('w0')+line('.'))/2.'G'
noremap <expr> F (line('w$')+line('.'))/2.'G'

" jump to the first non-empty char
nnoremap 1 ^

" copy current file name to system clipboard
nnoremap <c-g>c :let @+ = expand('%:t') \| echo 'copied string '.@+<CR>

" for webpack file watching
set backupcopy=yes

" tab
set tabstop=2
set shiftwidth=2
set expandtab

" ref: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
autocmd colorscheme * highlight CursorLine cterm=none ctermbg=235 guibg=#262626
autocmd colorscheme * highlight CursorColumn ctermbg=235 guibg=#262626
autocmd colorscheme * highlight CursorLineNR ctermbg=3 guibg=DarkCyan
autocmd colorscheme * highlight IndentGuidesOdd ctermbg=235 guibg=#262626
autocmd colorscheme * highlight IndentGuidesEven ctermbg=235 guibg=#262626

autocmd colorscheme * highlight Pmenu ctermbg=89 ctermfg=7 guibg=#87005f guifg=#e8e8e8
autocmd colorscheme * highlight PmenuSbar ctermbg=132 guibg=#af5f87
autocmd colorscheme * highlight PmenuThumb ctermbg=176 guibg=#df87df
autocmd colorscheme * highlight PmenuSel ctermbg=169 ctermfg=15 guibg=#df5faf guifg=#ffffff
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

" vim-bookmark
let g:bookmark_highlight_lines = 0

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
nnoremap <C-m> :InstantMarkdownPreview<CR>

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
let g:airline_theme='base16_summerfruit'

" set show_tabs=1 to use tabpages
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number 
let g:airline#extensions#tabline#tabs_label = '»'

let g:airline#extensions#coc#enabled = 0

" XXX: how to detect vim-airline loaded or not?
source ~/.vim/airline-tabline-filtered.vim

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

"=============================
" ctrlsf
"=============================
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
" prompt searching word under the cursor with -ignoredir
nmap     <C-G>i <Plug>CtrlSFCwordPath -ignoredir 
" search current selected word immediately
vmap     <C-G>v <Plug>CtrlSFVwordExec
" prompt searching current selected word
vmap     <C-G>b <Plug>CtrlSFVwordPath
nmap     <C-G>p <Plug>CtrlSFPwordPath
nnoremap <C-G>o :CtrlSFOpen<CR>
nnoremap <leader>t :CtrlSFToggle<CR>
inoremap <leader>t <Esc>:CtrlSFToggle<CR>

"=============================
" tagbar
"=============================
nnoremap <leader>l :TagbarToggle<CR>

let g:tagbar_left = 1
let g:tagbar_type_typescript = {                                                  
      \ 'ctagsbin' : 'tstags',                                                        
      \ 'ctagsargs' : '-f-',                                                           
      \ 'kinds': [                                                                     
      \ 'e:enums:0:1',                                                               
      \ 'f:function:0:1',                                                            
      \ 't:typealias:0:1',                                                           
      \ 'M:Module:0:1',                                                              
      \ 'I:import:0:1',                                                              
      \ 'i:interface:0:1',                                                           
      \ 'C:class:0:1',                                                               
      \ 'm:method:0:1',                                                              
      \ 'p:property:0:1',                                                            
      \ 'v:variable:0:1',                                                            
      \ 'c:const:0:1',                                                              
      \ ],                                                                            
      \ 'sort' : 0                                                                    
      \ }

"=============================
" ALE syntax checker, replace syntastic
"=============================
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%s (%code%) [%linter%] [%severity%]'
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = '!!'
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'typescript': ['tsserver', 'eslint', 'tslint'],
  \ 'javascript': ['tsserver', 'eslint'],
  \ 'vue': ['eslint'],
  \ 'json': ['prettier']
  \ }
let g:ale_fixers = {
  \ 'typescript': ['prettier', 'eslint', 'tslint'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'vue': ['eslint'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier'],
  \ 'json': ['prettier']
  \ }
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 1
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 50
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '♰ '
highlight ALEVirtualTextError ctermfg=9 guifg=#ff0000
highlight ALEVirtualTextWarning ctermfg=11 guifg=#ffff00

" auto close location list if no buffers, but seems buggy
" autocmd QuitPre * if empty(&bt) | lclose | endif
let g:ale_keep_list_window_open = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_set_lists_synchronously = 1
" let ale_quickfix.vim handle the quickfix window
let g:ale_open_list = 0
" let quickfix window be full width. Note: buggy when switching tabs
" autocmd filetype qf wincmd J

nnoremap <leader>x :ALEFix<CR>
nmap <silent> .. <Plug>(ale_previous_wrap)
nmap <silent> ,, <Plug>(ale_next_wrap)

"=============================
" vim-gitgutter
"=============================
let g:gitgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0

"=============================
" git-blame
"=============================
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"=============================
" vim-fugitive 
"=============================
nnoremap <c-g>b :Gblame<CR>
nnoremap <c-g>f :G file %<CR><c-w>_

" wildfire
" This selects the next closest text object.
map <SPACE> <Plug>(wildfire-fuel)
" This selects the previous closest text object.
vmap - <Plug>(wildfire-water)
let g:wildfire_objects = {
      \ "*" : ["i'", 'i"', "i)", "i]", "i}", "i>", "at", "it"]
      \ }

" auto-pair and closetag
let g:closetag_filenames = "*.html,*.js,*.jsx,*.ts,*.tsx"

" coc, replace ycm
" set completeopt-=preview
let g:coc_global_extensions = ['coc-json', 'coc-tsserver']
nmap <C-j> <Plug>(coc-definition)
nmap <C-k> <Plug>(coc-references)
inoremap <silent><expr> <TAB> <SID>coc_completion()
inoremap <silent><expr> <C-j> <SID>coc_completion()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:coc_completion() abort
  return pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ultisnips
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
" open vimfiler at startup if no specified file
autocmd VimEnter *
      \ if len(getbufinfo()) == 1 && empty(getbufinfo('%')[0].name) |
      \ execute "normal \<Plug>(ToggleVimFiler)" |
      \ endif
nnoremap <silent> <Plug>(ToggleVimFiler) :VimFilerExplorer
      \ -winwidth=50
      \ -direction=rightbelow
      \ -toggle
      \ -split
      \ -no-parent
      \ -status
      \ -no-safe
      \ <CR>
nmap <leader>e <Plug>(ToggleVimFiler)

autocmd FileType vimfiler :call SetupVimFiler()
function! SetupVimFiler()
  setlocal nobuflisted
  nmap <nowait> <buffer> <silent> i <Plug>(vimfiler_toggle_visible_ignore_files)
  nmap <nowait> <buffer> <silent> <C-l> <C-w>w
  nmap <nowait> <buffer> <silent> <C-h> <C-w>w
  nmap <nowait> <buffer> <silent> ? <Plug>(vimfiler_help)
  nmap <nowait> <buffer> <silent> T <Plug>(vimfiler_redraw_screen)
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
" unite.vim
"=============================
nnoremap <leader>w :Unite buffer<CR>

"=============================
" vimux
"=============================
noremap <leader>a :VimuxPromptCommand<CR>
noremap <leader>r :call VimuxSendKeys('c-c')<CR>:VimuxRunLastCommand<CR>

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

"=============================
" vim-vue
"=============================
let g:vue_pre_processors = []

"=============================
" my draft plugins
"=============================
source ~/.vim/tabbuffers.vim
source ~/.vim/smart-quit.vim
source ~/.vim/switch-buffer.vim
source ~/.vim/ale-quickfix.vim
source ~/.vim/vimfiler-jump.vim
source ~/.vim/term-map.vim

" show the last commit details of current line in Terminal-mode
nnoremap <expr><Leader>b ':te git sh '.BlameLine().'i'
function! BlameLine() abort
  let range = line('.').','.line('.')
  let command = 'git blame -s -L '.range.' '.expand('%').' | cut -d " " -f 1'
  let line_commit = system(command)
  return line_commit
endfunction
