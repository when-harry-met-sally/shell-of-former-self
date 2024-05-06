#!/usr/bin/env zsh

CUR=$(dirname "$0")
source $CUR/constants.zsh

create_preload_session() {
  if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    # Temporarily disable job control messages
    setopt localoptions no_notify no_monitor no_job_control

    # Check if a session named $SESSION_NAME exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      # If there is no session with $SESSION_NAME, create it with a window
      tmux new-session -d -s "$SESSION_NAME"
      tmux new-window -d -t "$SESSION_NAME"
    fi

    # Restore previous shell options (by unsetting local options)
    unsetopt no_notify no_monitor no_job_control
  fi
}

create_preload_session
