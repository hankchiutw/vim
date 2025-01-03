let plug_vim_path = has('nvim') ? stdpath('config').'/autoload/plug.vim' : '~/.vim/autoload/plug.vim'
if empty(glob(plug_vim_path))
  silent exec "!curl -fLo " . plug_vim_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'jreybert/vimagit'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'dart-lang/dart-vim-plugin'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'ianks/vim-tsx'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'scrooloose/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'hankchiutw/flutter-reload.vim'
Plug 'tpope/vim-fugitive'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'
Plug 'honza/vim-snippets'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'dag/vim-fish'
Plug 'instant-markdown/vim-instant-markdown'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'wavded/vim-stylus'
Plug 'majutsushi/tagbar'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'hankchiutw/vim-tabbuffers'
Plug 'OmniSharp/omnisharp-vim'
Plug 'hankchiutw/vim-jinja2'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'm-demare/hlargs.nvim'
Plug 'andymass/vim-matchup'
Plug 'windwp/nvim-ts-autotag'
Plug 'hiphish/rainbow-delimiters.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'mfussenegger/nvim-lint'
Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
Plug 'ms-jpq/coq.thirdparty', { 'branch': '3p' }
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'zivyangll/git-blame.vim'
Plug 'windwp/nvim-autopairs'
Plug 'github/copilot.vim'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
call plug#end()

lua require('custom').setup()

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
nnoremap <c-g>m :InstantMarkdownPreview<CR>

"=============================
" nerdcommenter
"=============================
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

"=============================
" vim-fugitive
"=============================
nnoremap <c-g>b :G blame<CR>
nnoremap <c-g>f :G file %<CR><c-w>_

"=============================
" git-blame
"=============================
nnoremap <silent> <leader>s :GitBlame<CR>

"=============================
" vim-closetag, also affects autopair
"=============================
let g:closetag_filenames = "*.html,*.js,*.jsx,*.ts,*.tsx"

"=============================
" vim-vue
"=============================
let g:vue_pre_processors = []
