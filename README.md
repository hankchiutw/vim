# Vim bundled

Included libraries:
* nerdtree
* syntastic
* tern_vim
* instant-markdown-d
* YouCompleteMe
* [vimagit](https://github.com/jreybert/vimagit)
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
* [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events)

Not vim related but useful libraries:
* screen
* [showlinenum](https://github.com/jay/showlinenum)

## Install

```sh
# required libraries
npm install -g instant-markdown-d eslint_d eslint-plugin-react babel-eslint
apt-get install -y exuberant-ctags cmake python-dev python3-dev

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
