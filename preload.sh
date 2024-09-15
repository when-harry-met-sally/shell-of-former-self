#!/usr/bin/env bash

create_preload_session() {
  if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    # Check if a session named $SESSION_NAME exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      # If there is no session with $SESSION_NAME, create it with a window
      # Redirect all output to /dev/null, including standard and error outputs
      tmux new-session -d -s "$SESSION_NAME" &
      pid=$!  # Get the PID of the last background process
      wait $pid  # Wait for the session creation to complete
      tmux new-window -d -t "$SESSION_NAME" &
    fi
  fi
}

create_preload_session
