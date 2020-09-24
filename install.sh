#!/bin/sh

## Install bash line editor ble.sh
#### https://github.com/akinomyoga/ble.sh
git clone --recursive https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make

## latest neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim

## latest vim
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install vim

## install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

# nvm ls-remote --lts
# nvm install v12.xx

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

# tstags for tagbar
npm install -g git+https://github.com/Perlence/tstags.git

# manually install vimpager
git clone git://github.com/rkitover/vimpager
cd vimpager
sudo make install

## For Linux
apt-get install -y exuberant-ctags cmake python-dev python3-dev screen gawk colordiff tmux silversearcher-ag python-pip

## For Mac
# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# turn off homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

brew update
brew install python3 automake gawk colordiff tmux the_silver_searcher tig
# ctags
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

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
ln -sr ./.tigrc ~/
ln -sr ./init.vim ~/.vimrc
ln -sr ./.tmux.conf ~/
ln -sr ./dotvim/* ~/.vim/
ln -sr ./mysnippets ~/.vim/
ln -sr ./init.vim ~/.config/nvim/
ln -sr ./coc-settings.json ~/.config/nvim/
ln -sr ./alacritty.yml ~/.config/alacritty/
mkdir ~/.ctags.d
ln -s ./default.ctags ~/ctags.d/

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## for nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## install vim plugins
vim +PlugInstall +qall

## do :CocInstall coc-json

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
