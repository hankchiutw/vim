let plug_vim_path = has('nvim') ? stdpath('config').'/autoload/plug.vim' : '~/.vim/autoload/plug.vim'
if empty(glob(plug_vim_path))
  silent exec "!curl -fLo " . plug_vim_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'dart-lang/dart-vim-plugin'
Plug 'tmux-plugins/vim-tmux-focus-events'
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
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'
Plug 'honza/vim-snippets'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'dag/vim-fish'
Plug 'suan/vim-instant-markdown'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'wavded/vim-stylus'
Plug 'ap/vim-css-color'
Plug 'majutsushi/tagbar'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'hankchiutw/vim-tabbuffers'
Plug 'OmniSharp/omnisharp-vim'
Plug 'hankchiutw/vim-jinja2'
Plug 'github/copilot.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'andymass/vim-matchup'
Plug 'windwp/nvim-ts-autotag'
Plug 'p00f/nvim-ts-rainbow'
call plug#end()

"=============================
" vim-indent-guides
"=============================
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

"=============================
" dart-vim-plugin
"=============================
let g:loaded_syntastic_dart_dartanalyzer_checker = 0
autocmd BufWritePre *.dart DartFmt

"=============================
" vim-bookmark
"=============================
let g:bookmark_highlight_lines = 0

"=============================
" vim-instant-markdown
"=============================
" to trigger preview `:InstantMarkdownPreview`
let g:instant_markdown_autostart = 0
nnoremap <C-m> :InstantMarkdownPreview<CR>

"=============================
" nerdcommenter
"=============================
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

"=============================
" git-blame
"=============================
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"=============================
" vim-fugitive
"=============================
nnoremap <c-g>b :G blame<CR>
nnoremap <c-g>f :G file %<CR><c-w>_

"=============================
" vim-closetag, also affects autopair
"=============================
let g:closetag_filenames = "*.html,*.js,*.jsx,*.ts,*.tsx"

"=============================
" vim-vue
"=============================
let g:vue_pre_processors = []

"=============================
" my draft plugins
"=============================
source ~/.vim/ale-quickfix.vim
