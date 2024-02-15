#!/usr/bin/env zsh

# Create a temporary directory for storing window previews
temp_dir=$(mktemp -d -t tmux_window_preview.XXXXXX)

# Get the current window ID
current_window=$(tmux display-message -p '#{window_id}')

# Get all tmux windows excluding the current one and store the output directly to reduce subprocess usage
windows=$(tmux list-windows -F '#{window_id} #{window_name} #{pane_current_path}' | grep -v "^$current_window")

# Directly check if "$windows" is empty to avoid counting lines
if [[ -z "$windows" ]]; then
    echo "No other tmux windows available."
    rm -rf "$temp_dir"
    exit 0
fi

# Streamline capturing pane content by avoiding unnecessary calls to external commands
while IFS= read -r line; do
    window_id=${line%% *}
    window_file="${temp_dir}/${window_id}.txt"
    tmux list-panes -t "$window_id" -F '#{pane_id}' | while IFS= read -r pane_id; do
        tmux capture-pane -e -t "$pane_id" -p -S -10 >> "$window_file"
    done
done <<< "$windows"

# Use fzf for fuzzy selection with preview command positioned to the left
chosen_window=$(echo "$windows" | fzf --cycle --preview-window=right:50%:wrap --preview="cat ${temp_dir}/\$(echo {} | awk '{print \$1}').txt" --header="Window ID | Window Name | Path" --delimiter=' ' --with-nth=2..)

# Remove the temporary directory
rm -rf "$temp_dir"

# If a window is chosen, switch to it
if [[ -n "$chosen_window" ]]; then
    target=$(echo "$chosen_window" | awk '{print $1}')
    tmux select-window -t "$target"
fi
