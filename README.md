# Vim as an IDE

Equip your Vim as an IDE.
![screenshot](screenshot.png)

## Quick start
Copy [.vimrc](.vimrc) to home directory and install plugins with command:
```shell
vim +PluginInstall +qall
```
Solve the dependencies if you are not lucky. :(

## tmux integration
[ide.sh](ide.sh) is a `tmux` integration script.
```shell
cd [YOUR PROJECT'S ROOT]
/path/to/ide.sh
```

## Plugins

#### Project tree
* [nerdtree](https://github.com/scrooloose/nerdtree)
* [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)
* [vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
  * show nerdtree for all tabs
* [nerdtree-ranger.vim](https://github.com/hankchiutw/nerdtree-ranger.vim)
  * add ranger-like key binding

#### Auto completion
* [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

#### Language server, linting, syntax highlight
* [ale](https://github.com/w0rp/ale)
  * kind of async version of [syntastic](https://github.com/vim-syntastic/syntastic)
* [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
* [vim-lsp-typescript](https://github.com/ryanolsonx/vim-lsp-typescript)
* [typescript-language-server](https://github.com/theia-ide/typescript-language-server)
* [dart-vim-plugin](https://github.com/dart-lang/dart-vim-plugin)

#### Code search
* [ctrlp.vim](https://github.com/kien/ctrlp.vim)
* [ctrsf.vim](https://github.com/dyng/ctrlsf.vim)

#### Code editing
* [vim-prettier](https://github.com/prettier/vim-prettier)
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
* [delimitMate](https://github.com/Raimondi/delimitMate)
  * use <C-g>g to jump out of pair
* [auto-pairs](https://github.com/jiangmiao/auto-pairs)
  * auto delete pairs
* [vim-closetag](https://github.com/alvan/vim-closetag)
* [vim-jsx-improve](https://github.com/neoclide/vim-jsx-improve)
  * without indent issue of `vim-jsx`

#### Git enhancement
* [vimagit](https://github.com/jreybert/vimagit)
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
* [git-blame.vim](https://github.com/zivyangll/git-blame.vim)
  * show commit title in status bar
* [vim-fugitive](https://github.com/tpope/vim-fugitive)
* [showlinenum](https://github.com/jay/showlinenum)
  * show line number in git-diff

#### Powerline UI
* [vim-airline](https://github.com/vim-airline/vim-airline)
* [powline fonts](https://github.com/powerline/fonts)

#### tmux
* [tmuxline](https://github.com/edkolev/tmuxline.vim)
* [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events)

#### Utils
* [flutter-reload.vim](https://github.com/hankchiutw/flutter-reload.vim)
* [instant-markdown-d](https://github.com/suan/vim-instant-markdown)
* [vimpager](https://github.com/rkitover/vimpager)
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired)
* [vim-repeat](https://github.com/tpope/vim-repeat)

## Install

See [install.sh](install.sh)

##### YouCompleteMe
- [Full installation guide](https://github.com/Valloric/YouCompleteMe#full-installation-guide)
- [guide from MDN](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/YouCompleteMe)

##### Compile YCM first (below will install with javascript semantic completion)
```sh
~/.vim/bundle/YouCompleteMe/install.sh --tern-completer
```

## Lint
Copy `.eslintrc.js` to home folder.

Copy `.stylelintrc` to project root folder.
