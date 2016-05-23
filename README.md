# Vim bundled

Included libraries:
* nerdtree
* syntastic
* tern_vim
* instant-markdown-d
* YouCompleteMe

## Install

```sh
# required libraries
npm install -g instant-markdown-d
apt-get install -y exuberant-ctags cmake python-dev python3-dev

# including submodules
# git clone --recursive git@github.com:hanchiutw/vim.git => this will clone ALL submodules!
git clone git@github.com:hanchiutw/vim.git
cd vim
git submodule init
git submodule update
```

## Install YouCompleteMe
[Full installation guide](https://github.com/Valloric/YouCompleteMe#full-installation-guide) from [valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

Another [guide from MDN](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/YouCompleteMe)

Start vim, execute :PluginInstall

```sh
# Compile YCM and install with javascript semantic completion
~/.vim/bundle/YouCompleteMe/install.sh --tern-completer
```
