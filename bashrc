# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source "$HOME/blesh/ble.sh" --noattach

# Non-printable sequences should be enclosed in \[ and \]
# see: https://unix.stackexchange.com/questions/105958/terminal-prompt-not-wrapping-correctly
color_off="\[\e[m\]"
ps_branch='\[\e[32m\]$(__git_ps1 "  %s\n ╰─")'$color_off
ps_user="\[\e[33m\] $(echo ${USER} | cut -c -4)@$(hostname | cut -c -3)"$color_off
ps_pwd="\[\e[34m\] \w"$color_off" ➝ "
export PS1=${ps_branch}${ps_user}${ps_pwd}${color_off}

# update terminal title
export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# configure __git_ps1
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_STATESEPARATOR=" ✨ "

# Make bash check its window size after a process completes
shopt -s checkwinsize

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

alias ll='ls -lG'

export HOMEBREW_NO_AUTO_UPDATE=1
export TERM=xterm-256color
set -o vi
export EDITOR=vim
# alias less='/usr/local/bin/vimpager'

export FZF_DEFAULT_OPTS="--bind ctrl-f:page-down,ctrl-b:page-up --history=${HOME}/.fzf_history --exact --preview 'cat -n {}' --preview-window up"
# instead of using default `find` command which doesn't respect .gitignore
export FZF_DEFAULT_COMMAND="ag -l"

# to let __git_ps1 work
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Add this line at the end of .bashrc:
((_ble_bash)) && ble-attach
