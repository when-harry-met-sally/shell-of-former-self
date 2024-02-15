#!/usr/bin/env zsh

# Get the current window ID to exclude it from the list
current_window=$(tmux display-message -p '#{window_id}')

# List all tmux windows excluding the current one, formatted for easy selection
windows=$(tmux list-windows -F '#{window_id} #{window_name} #{pane_current_path}' | grep -v "^$current_window")

# Check if there are any other windows available
if [[ -z "$windows" ]]; then
    echo "No other tmux windows available."
    exit 0
fi

# Use fzf for fuzzy selection without preview logic
chosen_window_id=$(echo "$windows" | fzf --cycle --header="Window ID | Window Name | Path" --delimiter=' ' --with-nth=2.. | awk '{print $1}')

# If a window is chosen, switch to it
if [[ -n "$chosen_window_id" ]]; then
    tmux select-window -t "$chosen_window_id"
fi
