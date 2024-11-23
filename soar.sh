##!/usr/bin/env bash
#
## Function to attach to an existing tmux pane if the directory is already in use
#attach_or_cd() {
#    local target_dir="$1"
#
#    # Check if the directory exists
#    if [[ ! -d "$target_dir" ]]; then
#        echo "Directory '$target_dir' does not exist."
#        return 1
#    fi
#
#    # Get the current pane ID
#    current_pane=$(tmux display-message -p '#{pane_id}')
#
#    # Get all tmux panes with their current working directory, excluding the current pane
#    panes=$(tmux list-panes -a -F '#{pane_id} #{window_id} #{pane_current_path}' | grep -v "^$current_pane ")
#
#    # Loop through the panes to see if the target directory is already in use
#    while IFS= read -r line; do
#        pane_id=$(echo "$line" | awk '{print $1}')
#        window_id=$(echo "$line" | awk '{print $2}')
#        pane_path=$(echo "$line" | awk '{print $3}')
#
#        if [[ "$pane_path" == "$target_dir" ]]; then
#            echo "Directory '$target_dir' is already open in pane $pane_id. Attaching..."
#            tmux select-window -t "$window_id"
#            tmux select-pane -t "$pane_id"
#            return 0
#        fi
#    done <<< "$panes"
#
#    # If no matching pane is found, change to the directory
#    echo "Changing directory to '$target_dir'."
#    cd "$target_dir"
#}
#
## Usage: Pass the target directory as an argument
#attach_or_cd "$1"
