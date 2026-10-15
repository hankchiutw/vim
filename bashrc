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

export PATH="$HOME/.local/bin:$PATH"
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
fi

alias ll='ls -lG'

export HOMEBREW_NO_AUTO_UPDATE=1
set -o vi
export EDITOR=nvim
# alias less='/usr/local/bin/vimpager'

export FZF_DEFAULT_OPTS="--bind 'ctrl-f:page-down,ctrl-b:page-up,tab:toggle-preview' --history=${HOME}/.fzf_history --exact --color hl:217,hl+:87,fg+:11 --preview 'cat -n {}' --preview-window up:60%"
# instead of using default `find` command which doesn't respect .gitignore
export FZF_DEFAULT_COMMAND="ag -l"
export FZF_ALT_C_OPTS="--preview-window hidden --no-exact"
export FZF_CTRL_T_OPTS="--height 100%"

# to let __git_ps1 work
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
