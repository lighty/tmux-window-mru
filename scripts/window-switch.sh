#!/usr/bin/env bash
# Switch windows sorted by Most Recently Used order using fzf

# Load tmux-fzf environment if available (sets TMUX_FZF_BIN, TMUX_FZF_OPTIONS, etc.)
TMUX_FZF_DIR="$HOME/.tmux/plugins/tmux-fzf"
if [[ -f "$TMUX_FZF_DIR/scripts/.envs" ]]; then
    source "$TMUX_FZF_DIR/scripts/.envs"
fi

FZF_BIN="${TMUX_FZF_BIN:-$(command -v fzf-tmux 2>/dev/null || command -v fzf 2>/dev/null)}"
if [[ -z "$FZF_BIN" ]]; then
    tmux display-message "tmux-window-mru: fzf not found"
    exit 1
fi

current_window=$(tmux display-message -p '#S:#I')

# Collect all windows with their MRU timestamps
windows=""
while IFS= read -r line; do
    session_window=$(echo "$line" | cut -d' ' -f1)
    window_name=$(echo "$line" | cut -d' ' -f2-)

    # Get the MRU timestamp (0 if never visited)
    ts=$(tmux show-option -wqv -t "$session_window" @mru_timestamp 2>/dev/null)
    ts="${ts:-0}"

    windows+="${ts} ${session_window}: ${window_name}"$'\n'
done < <(tmux list-windows -a -F '#S:#I #{window_name}')

# Sort by timestamp descending, strip timestamp, remove current window
sorted=$(echo -n "$windows" | sort -rn | sed 's/^[0-9]* //' | grep -v "^${current_window}:")

if [[ -z "$sorted" ]]; then
    tmux display-message "No other windows"
    exit 0
fi

fzf_opts="${TMUX_FZF_OPTIONS:---height=50% --reverse} --no-sort --header='Switch window (MRU order)'"

target=$(printf "%s\n[cancel]" "$sorted" | eval "$FZF_BIN $fzf_opts $TMUX_FZF_PREVIEW_OPTIONS")

[[ "$target" == "[cancel]" || -z "$target" ]] && exit 0

# Extract session:window_index and switch
session_window=$(echo "$target" | sed 's/: .*//')
session=$(echo "$session_window" | cut -d: -f1)
window_index=$(echo "$session_window" | cut -d: -f2)

tmux switch-client -t "$session"
tmux select-window -t "${session}:${window_index}"
