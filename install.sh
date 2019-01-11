#!/bin/sh

## install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

# nvm ls-remote --lts
# nvm install v6.xx

npm install -g instant-markdown-d typescript typescript-language-server
pip install git+https://github.com/jeffkaufman/icdiff.git

# manually install vimpager
git clone git://github.com/rkitover/vimpager
cd vimpager
sudo make install

## For Linux
apt-get install -y exuberant-ctags cmake python-dev python3-dev screen gawk colordiff tmux

## For Mac
# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# turn off homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

brew update
brew install python3 automake gawk colordiff tmux the_silver_searcher

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

## prepare for Vim plugins
# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# install vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## install Vundle plugins
vim +PluginInstall +qall

## powerline fonts for vim-airline
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
# set your terminal app's font to powline font 
# I use `Roboto Mono for Powerline` or `Literation Mono Powerline` in MacOS's Terminal.app

## some submodule affairs
git submodule update --init --recursive
cp ./showlinenum/showlinenum.awk /usr/local/bin/

./.vim/bundle/YouCompleteMe/install.sh --tern-completer
