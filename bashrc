# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source ~/code/ble.sh/out/ble.sh --noattach

# Non-printable sequences should be enclosed in \[ and \]
# see: https://unix.stackexchange.com/questions/105958/terminal-prompt-not-wrapping-correctly
export PS1='\[\e[33m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\$ '
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export HOMEBREW_NO_AUTO_UPDATE=1
export TERM=xterm-256color
set -o vi
export EDITOR=vim
# alias less='/usr/local/bin/vimpager'
export FZF_DEFAULT_OPTS='--bind ctrl-f:page-down,ctrl-b:page-up'

# Add this line at the end of .bashrc:
((_ble_bash)) && ble-attach
