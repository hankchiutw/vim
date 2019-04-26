export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export HOMEBREW_NO_AUTO_UPDATE=1
export TERM=xterm-256color
set -o vi
export EDITOR=vim
# alias less='/usr/local/bin/vimpager'
export FZF_DEFAULT_OPTS='--bind ctrl-f:page-down,ctrl-b:page-up'
