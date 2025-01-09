#!/usr/bin/env bash
# cli.sh

# Load constants or environment variables (if needed)
source "$(dirname "$0")/constants.sh"

# Print usage information
function show_help() {
    echo "Usage: cli.sh [command] [optional args]"
    echo "Available commands:"
    echo "  fuzzy         - Run fuzzy script"
    echo "  preview       - Run fuzzy-preview script"
    echo "  new-tab [dir] - Move window 0 from \$SESSION_NAME to current session. Optionally cd to [dir]."
    echo "  preload       - Preload shell"
    echo "  kill-tmux     - Run tmux-killa script"
}

# Handle commands
cmd="$1"
shift  # drop the first argument (the command), leaving any extra arguments in $@

case "$cmd" in
    fuzzy)
        "$(dirname "$0")/fuzzy.sh" "$@"
        ;;
    preview)
        "$(dirname "$0")/fuzzy-preview.sh" "$@"
        ;;
    preload)
        # If preload is just a script
        "$(dirname "$0")/preload.sh" "$@"
        ;;
    new-tab)
        # Forward any extra arguments (e.g., directory) to new-tab.sh
        "$(dirname "$0")/new-tab.sh" "$@"
        ;;
    kill-tmux)
        "$(dirname "$0")/tmux-killa.sh" "$@"
        ;;
    *)
        show_help
        ;;
esac
