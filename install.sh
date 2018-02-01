#!/bin/sh

## install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

# nvm ls-remote --lts
# nvm install v6.xx

npm install -g instant-markdown-d
pip install git+https://github.com/jeffkaufman/icdiff.git

## For Linux
apt-get install -y exuberant-ctags cmake python-dev python3-dev screen gawk colordiff tmux

## For Mac
# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# turn off homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

brew update
brew install python3 automake gawk colordiff tmux

# GNU screen for mac with vertical split
# git@github.com:hankchiutw/gnu-screen-with-vertical-split.git

## Copy files
cp ./.eslintrc.js ~/
cp ./.stylelintrc ~/
cp ./.vimrc ~/
cp ./.tern-config ~/
cp ./.gitconfig ~/
cp ./.screenrc ~/
cp ./.colordiffrc ~/
cp ./.tmux.conf ~/

## some submodule affairs
git submodule update --init --recursive
cp ./showlinenum/showlinenum.awk /usr/local/bin/

./.vim/bundle/YouCompleteMe/install.sh --tern-completer
