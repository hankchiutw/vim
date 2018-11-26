# Vim bundled

Included libraries:
* nerdtree
* syntastic
* tern_vim
* [instant-markdown-d](https://github.com/suan/vim-instant-markdown)
* YouCompleteMe
* [vimagit](https://github.com/jreybert/vimagit)
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
* [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events)
* [git-blame.vim](https://github.com/zivyangll/git-blame.vim)
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired)
* [vim-repeat](https://github.com/tpope/vim-repeat)
* [vim-prettier](https://github.com/prettier/vim-prettier)
* [dart-vim-plugin](https://github.com/dart-lang/dart-vim-plugin)
* [vimpager](https://github.com/rkitover/vimpager)

Not vim related but useful libraries:
* screen
* [showlinenum](https://github.com/jay/showlinenum)

## Install

```sh
# required libraries
npm install -g instant-markdown-d eslint_d eslint-plugin-react babel-eslint prettier
apt-get install -y exuberant-ctags cmake python-dev python3-dev
# manaully install vimpager
# https://github.com/rkitover/vimpager#install

# including submodules
# git clone --recursive git@github.com:hanchiutw/vim.git => this will clone ALL submodules!
git clone git@github.com:hanchiutw/vim.git
cd vim
git submodule update --init --recursive
```

or execute `install.sh`(may need some modification)

## Install YouCompleteMe
[Full installation guide](https://github.com/Valloric/YouCompleteMe#full-installation-guide) from [valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

Another [guide from MDN](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/YouCompleteMe)

# Compile YCM first (below will install with javascript semantic completion)
```sh
~/.vim/bundle/YouCompleteMe/install.sh --tern-completer
```

Start vim, execute :PluginInstall

## Lint with syntastic
Copy `.eslintrc.js` to home folder.

Copy `.stylelintrc` to project root folder.

## Development
**Add submodule as a vim plugin**
```sh
git submodule add [repo] .vim/bundle/[path]
```
