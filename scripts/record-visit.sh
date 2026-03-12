#!/usr/bin/env bash
# Record the current timestamp on the active window
tmux set-option -w @mru_timestamp "$(date +%s)"
