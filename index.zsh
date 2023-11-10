#!/usr/bin/env zsh

CUR=$(dirname "$0")
source $CUR/constants.zsh 

create_preload_session() {
  if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    # Check if a session named $SESSION_NAME exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      # If there is no session with $SESSION_NAME, create it with a window
      tmux new-session -d -s "$SESSION_NAME"

      # Create an additional new window in the same session
      tmux new-window -d -t "$SESSION_NAME"
    fi
  fi
}

create_preload_session
