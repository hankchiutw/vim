#!/bin/sh

## install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

# nvm ls-remote --lts
# nvm install v6.xx

npm install -g instant-markdown-d typescript typescript-language-server tslint-language-service
pip install git+https://github.com/jeffkaufman/icdiff.git

# eslint
npm install -g\
  eslint\
  eslint-config-airbnb\
  eslint-plugin-import\
  eslint-plugin-jsx-a11y\
  eslint-plugin-react\
  eslint-plugin-flowtype\
  eslint-plugin-babel\
  babel-eslint

# manually install vimpager
git clone git://github.com/rkitover/vimpager
cd vimpager
sudo make install

## For Linux
apt-get install -y exuberant-ctags cmake python-dev python3-dev screen gawk colordiff tmux silversearcher-ag

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
cp ./.stylelintrc ~/
cp ./.tern-config ~/
cp ./.colordiffrc ~/
cp ./config.fish ~/.config/fish/

## link files
ln -sr ./.eslintrc.js ~/
ln -sr ./.gitconfig ~/
ln -sr ./init.vim ~/.vimrc
ln -sr ./.tmux.conf ~/
ln -sr ./dotvim/* ~/.vim/
ln -sr ./mysnippets ~/.vim/
ln -sr ./init.vim ~/.config/nvim/

# Install vim-plug
## for nvim, use ~/.local/share/nvim/site/autoload/plug.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## install vim plugins
vim +PlugInstall +qall

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
