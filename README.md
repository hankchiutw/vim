# Vim as an IDE

#### Project tree
* [nerdtree](https://github.com/scrooloose/nerdtree)
* [vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
  * show nerdtree for all tabs

#### Auto completion
* [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

#### Language server, linting
* [ale](https://github.com/w0rp/ale)
  * kind of async version of [syntastic](https://github.com/vim-syntastic/syntastic)
* [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
* [vim-lsp-typescript](https://github.com/ryanolsonx/vim-lsp-typescript)
* [typescript-language-server](https://github.com/theia-ide/typescript-language-server)

#### Code search
* [ctrlp.vim](https://github.com/kien/ctrlp.vim)
* [ctrsf.vim](https://github.com/dyng/ctrlsf.vim)

#### Code editing
* [vim-prettier](https://github.com/prettier/vim-prettier)
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter)

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
* [dart-vim-plugin](https://github.com/dart-lang/dart-vim-plugin)
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

## Development
**Add submodule as a vim plugin**
```sh
git submodule add [repo] .vim/bundle/[path]
```
