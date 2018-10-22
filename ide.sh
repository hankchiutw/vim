#!/bin/sh
TARGET=${1:-.}
cd $TARGET

tmux new-session -d
tmux splitw -h
tmux splitw -v
tmux select-pane -t 0
tmux resize-pane -R 10
tmux send-keys 'vi -c NERDTree' Enter

tmux new-window
tmux select-window -t 0

tmux attach-session
