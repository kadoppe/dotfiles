#!/bin/bash

SESSION="$1"
WINDOW="$2"
PANE="$3"

# Ghostty をアクティブにする
osascript -e 'tell application "Ghostty" to activate'

# tmux で該当 session/window/pane に切り替え
tmux select-window -t "${SESSION}:${WINDOW}"
tmux select-pane -t "${SESSION}:${WINDOW}.${PANE}"
