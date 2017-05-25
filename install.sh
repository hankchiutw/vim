#!/bin/sh

apt-get install -y exuberant-ctags cmake python-dev python3-dev npm
npm install -g instant-markdown-d

cp ./.eslintrc.js ~/
cp ./.stylelintrc ~/
cp ./.vimrc ~/
cp ./.tern-config ~/
cp ./.gitconfig ~/

git submodule update --init --recursive

# some submodule affairs
./.vim/bundle/YouCompleteMe/install.sh --tern-completer
cp ./showlinenum/showlinenum.awk /usr/local/bin/
