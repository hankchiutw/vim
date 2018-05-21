#!/bin/sh
cd ~/code

if [ -n $1 ]
then
  cd $1
fi

tmux new-session -d -s 'Editor'
tmux splitw -h
tmux splitw -v
tmux select-pane -t 0
tmux resize-pane -R 10
tmux send-keys 'vi -c NERDTree' Enter

tmux new-window
tmux select-window -t 0

tmux attach-session
