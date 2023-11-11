#!/usr/bin/env zsh

# Function to capture pane contents
capture_pane_content() {
    pane_id=$1
    window_file=$2
    tmux capture-pane -t "$pane_id" -p -S -10 >> "$window_file"
}

#!/usr/bin/env zsh

# Create a temporary directory for storing window previews
temp_dir=$(mktemp -d -t tmux_window_preview.XXXXXX)

# Get the current window ID
current_window=$(tmux display-message -p '#{window_id}')

# Process each window and its panes
tmux list-windows -F '#{window_id} #{window_name}' | grep -v "^$current_window" | while read -r window_id window_name; do
    window_file="${temp_dir}/${window_id}.txt"
    tmux list-panes -t "$window_id" -F '#{pane_id}' | xargs -I {} -P4 bash -c 'tmux capture-pane -e -t "{}" -p -S -10 >> "'"$window_file"'"'
done

# Get all tmux windows including window ID, window name, and current path of the first pane
windows=$(tmux list-windows -F '#{window_id} #{window_name} #{pane_current_path}' | grep -v "^$current_window")

# If no windows are found, exit the script
if [[ -z "$windows" ]]; then
    rm -rf "$temp_dir"
    exit 0
fi

# Use fzf for fuzzy selection with a custom display format
chosen_window=$(echo "$windows" | fzf --cycle --preview "awk '{print \$1}' <<< {} | xargs -I % cat ${temp_dir}/%.txt" --header="Window ID | Window Name | Path" --delimiter=' ' --with-nth=1,2,3)

# Remove the temporary directory
rm -rf "$temp_dir"

# If a window is chosen, switch to it
if [[ -n "$chosen_window" ]]; then
    target=$(echo "$chosen_window" | awk '{print $1}')
    tmux select-window -t "$target"
else
    exit 0
fi
