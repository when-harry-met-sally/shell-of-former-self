#!/usr/bin/env zsh

# Source the constants file
source ./constants.zsh

# Function to check if a tmux session exists
session_exists() {
    local session_name="$1"
    tmux has-session -t "${session_name}" 2>/dev/null
}

# Function to get the name of the first window in a session
get_first_window_name() {
    local session_name="$1"
    tmux list-windows -t "${session_name}" -F '#{window_name}' | head -n 1
}

# Function to get the name of the currently running program in the first pane of a window
get_pane_program_name() {
    local session_name="$1"
    local window_name="$2"
    tmux list-panes -t "${session_name}:${window_name}" -F '#{pane_current_command}' | head -n 1
}

# Main logic
if [[ -n "$TMUX" ]]; then  # Check if inside a tmux session
    if session_exists "$SESSION_NAME"; then
        # Get the name of the first window in the "$SESSION_NAME" session
        first_window_name=$(get_first_window_name "$SESSION_NAME")
        
        # Switch to the first window of the "$SESSION_NAME" session
        tmux switch-client -t "$SESSION_NAME"
        tmux select-window -t "${first_window_name}"

        # Get the name of the currently running program in the first pane of the first window
        program_name=$(get_pane_program_name "$SESSION_NAME" "${first_window_name}")
        
        # Rename the window to the program name
        tmux rename-window "${program_name}"

        # Create a new "PRELOAD" window in the "$SESSION_NAME" session but don't switch to it
        tmux new-window -d -t "$SESSION_NAME" -n 'PRELOAD'
    else
        echo "Session '$SESSION_NAME' does not exist."
    fi
else
    echo "No tmux session is active."
fi
