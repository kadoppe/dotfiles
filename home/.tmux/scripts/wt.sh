#!/usr/bin/env bash

# Switch to git worktree with fzf

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Not a git repository"
  exit 1
fi

WT_LINE=$(git worktree list | fzf-tmux -p 90%)
if [[ -z "$WT_LINE" ]]; then
  exit 0
fi

WT_PATH=$(echo "$WT_LINE" | awk '{print $1}')
WT_NAME=$(basename "$(dirname "$WT_PATH")")/$(basename "$WT_PATH")
WT_NAME=${WT_NAME//./_}

if ! tmux has-session -t "$WT_NAME" 2>/dev/null; then
  tmux new-session -c "$WT_PATH" -s "$WT_NAME" -d
  tmux setenv -t "$WT_NAME" TMUX_SESSION_PATH "$WT_PATH"
fi

if [[ -z "$TMUX" ]]; then
  tmux attach -t "$WT_NAME"
else
  tmux switch-client -t "$WT_NAME"
fi
