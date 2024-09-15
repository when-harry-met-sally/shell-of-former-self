#!/usr/bin/env bash

CUR=$(dirname "$0")
source $CUR/constants.zsh 

# Function to check if a tmux session exists
session_exists() {
    tmux has-session -t "$SESSION_NAME" 2>/dev/null
}

# Function to move a window from a specific session to the current session and attach to it
move_window_to_current_session() {
    local session_name="$1"
    # Create a new window in the "$SESSION_NAME" session but don't switch to it
    tmux move-window -s $session_name:0 -t :

    tmux new-window -d -t "$session_name"
}

# Main logic
if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    if session_exists "$SESSION_NAME"; then
        move_window_to_current_session "$SESSION_NAME"
    else
        echo "Session '$SESSION_NAME' does not exist."
        # Optionally, create the session if it doesn't exist
        # tmux new-session -d -s "$SESSION_NAME"
    fi
else
    echo "No tmux session is active."
fi
