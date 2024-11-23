#!/usr/bin/env bash

# Function to check if a tmux session exists
session_exists() {
    tmux has-session -t "$SESSION_NAME" 2>/dev/null
}

# Function to move a window from a specific session to the current session and attach to it
move_window_to_current_session() {
    local session_name="$1"
    local directory="$2"
    
    # Create a new window in the "$SESSION_NAME" session but don't switch to it
    tmux move-window -s $session_name:0 -t :

    if [[ -n "$directory" && -d "$directory" ]]; then
        # Change the directory of the current session before creating the new tab
        tmux send-keys -t : "cd '$directory' && clear" C-m
    fi

    tmux new-window -d -t "$session_name" -c "$HOME"
}

# Main logic
if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    if session_exists "$SESSION_NAME"; then
        # Get the optional directory argument (if provided)
        directory="$1"

        move_window_to_current_session "$SESSION_NAME" "$directory"
    else
        echo "Session '$SESSION_NAME' does not exist."
        # Optionally, create the session if it doesn't exist
        # tmux new-session -d -s "$SESSION_NAME"
    fi
else
    echo "No tmux session is active."
fi
