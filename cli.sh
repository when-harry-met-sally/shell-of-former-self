#!/usr/bin/env bash
# Load constants and any other pre-requisites
source "$(dirname "$0")/constants.sh"

# Print usage information
function show_help() {
    echo "Usage: cli.sh [command]"
    echo "Available commands:"
    echo "  fuzzy       - Run fuzzy script"
    echo "  preview     - Run fuzzy-preview script"
    echo "  new-tab     - Open a new tmux tab"
    echo "  preload     - Preload shell"
    echo "  kill-tmux   - Run tmux-killa script"
}

# Handle commands
case "$1" in
    fuzzy)
        "$(dirname "$0")/fuzzy.sh"
        ;;
    preview)
        "$(dirname "$0")/fuzzy-preview.sh"
        ;;
    preload)
        "$(dirname "$0")/preload.sh"
        ;;
    new-tab)
        "$(dirname "$0")/new-tab.sh"
        ;;
    kill-tmux)
        "$(dirname "$0")/tmux-killa.sh"
        ;;
    *)
        show_help
        ;;
esac
