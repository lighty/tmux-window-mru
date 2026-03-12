# tmux-window-mru

Switch tmux windows in **Most Recently Used** order using fzf.

Unlike tmux's built-in `#{window_activity}` (which tracks terminal output), this plugin tracks when **you** last focused on each window, giving you a true MRU window switcher.

## Requirements

- tmux >= 3.0
- [fzf](https://github.com/junegunn/fzf)

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'lighty/tmux-window-mru'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/lighty/tmux-window-mru ~/.tmux/plugins/tmux-window-mru
```

Add to `~/.tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/tmux-window-mru/mru.tmux
```

## Usage

Press `prefix + f` to open the MRU window switcher.

## Configuration

### Key binding

```tmux
# Change the key binding (default: f)
set -g @mru_key "w"
```

### Works with tmux-fzf

If [tmux-fzf](https://github.com/sainnhe/tmux-fzf) is installed, this plugin will use its fzf binary and options automatically.

## How it works

1. A tmux hook records a timestamp on each window whenever you switch to it
2. When you invoke the switcher, windows are sorted by that timestamp (most recent first)
3. You pick a window with fzf and switch to it

## License

MIT
