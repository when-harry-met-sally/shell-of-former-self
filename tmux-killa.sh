#!/usr/bin/env bash

# Temporary files for tmux window names
INITIAL_WINDOWS=$(mktemp)
EDITED_WINDOWS=$(mktemp)

# Fetch current window ID to exclude it from the list
current_window=$(tmux display-message -p '#I')

# Fetch the list of windows in the current tmux session, excluding the current window
CURRENT_SESSION=$(tmux display-message -p '#S')
tmux list-windows -F '#{window_id} #{window_name} #{pane_current_path}' | grep -v "^$current_window" >$INITIAL_WINDOWS

# Open the list in Neovim for editing
cp $INITIAL_WINDOWS $EDITED_WINDOWS
nvim $EDITED_WINDOWS

# Checking for changes and finding windows to kill
if diff $INITIAL_WINDOWS $EDITED_WINDOWS >/dev/null; then
    echo "No changes detected."
else
    echo "Changes detected. Analyzing..."
    MISSING_WINDOWS=()
    MISSING_WINDOWS_INFO=()
    while IFS= read -r line; do
        WINDOW_ID=$(echo "$line" | awk '{print $1}')
        if ! grep -Fxq "$line" $EDITED_WINDOWS; then
            MISSING_WINDOWS+=("$WINDOW_ID")
            MISSING_WINDOWS_INFO+=("$line")
        fi
    done <$INITIAL_WINDOWS

    if [ ${#MISSING_WINDOWS[@]} -eq 0 ]; then
        echo "No tmux windows to kill."
    else
        echo "The following tmux windows will be killed:"
        for INFO in "${MISSING_WINDOWS_INFO[@]}"; do
            printf "\t- %s\n" "$INFO"
        done

        # Ask for confirmation before killing windows
        echo "Do you want to proceed with killing these tmux windows?"
        echo -n "Proceed? (y/n) "
        read confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            for WINDOW in "${MISSING_WINDOWS[@]}"; do
                echo "Killing tmux window $WINDOW in session $CURRENT_SESSION..."
                tmux kill-window -t "${CURRENT_SESSION}:${WINDOW}"
            done
            echo "Tmux windows updated."
        else
            echo "Operation cancelled."
        fi
    fi
fi

# Clean up
rm $INITIAL_WINDOWS $EDITED_WINDOWS
echo "Process complete."
