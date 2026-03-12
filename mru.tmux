#!/usr/bin/env bash
# tmux-window-mru: Track and switch windows by Most Recently Used order
# https://github.com/lighty/tmux-window-mru

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Record initial timestamp for the current window
tmux set-option -w @mru_timestamp "$(date +%s)"

# Hook: record timestamp whenever the user switches to a window
tmux set-hook -g session-window-changed "run-shell '$CURRENT_DIR/scripts/record-visit.sh'"
tmux set-hook -g client-session-changed "run-shell '$CURRENT_DIR/scripts/record-visit.sh'"

# Key binding (default: prefix + f, configurable via @mru_key)
mru_key=$(tmux show-option -gqv @mru_key)
mru_key="${mru_key:-f}"
tmux bind-key "$mru_key" run-shell -b "$CURRENT_DIR/scripts/window-switch.sh"
