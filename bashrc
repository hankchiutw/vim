# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source "$HOME/blesh/ble.sh" --noattach

# Non-printable sequences should be enclosed in \[ and \]
# see: https://unix.stackexchange.com/questions/105958/terminal-prompt-not-wrapping-correctly
color_off="\[\e[m\]"
ps_branch='\[\e[32m\]$(__git_ps1 "  %s\n ╰─")'$color_off
ps_user="\[\e[33m\] $(echo ${USER} | cut -c -4)@$(hostname | cut -c -3)"$color_off
ps_pwd="\[\e[34m\] \w"$color_off" ➝ "
export PS1=${ps_branch}${ps_user}${ps_pwd}${color_off}
export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# Make bash check its window size after a process completes
shopt -s checkwinsize

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export HOMEBREW_NO_AUTO_UPDATE=1
export TERM=xterm-256color
set -o vi
export EDITOR=vim
# alias less='/usr/local/bin/vimpager'
export FZF_DEFAULT_OPTS="--bind ctrl-f:page-down,ctrl-b:page-up --history=${HOME}/.fzf_history --exact"

# Add this line at the end of .bashrc:
((_ble_bash)) && ble-attach
