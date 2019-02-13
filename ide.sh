#!/bin/sh
TARGET=${1:-.}
cd $TARGET

date=`date +%Y-%m-%d#%H-%M-%S`
WINDOW_NAME=`basename \`pwd\``

tmux new-session -d -s 'ide@'$date -n "$WINDOW_NAME"
tmux splitw -h
tmux splitw -v
tmux select-pane -t 0
tmux resize-pane -R 30
tmux send-keys 'vim' Enter

tmux new-window -n 'Console'
tmux select-window -t 0

tmux attach-session
