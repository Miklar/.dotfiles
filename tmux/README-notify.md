# tmux notify

Notifies across tmux sessions when a Claude Code task finishes.
Works on macOS and Linux. POSIX sh — no bash required.

## Files

| Dotfiles path | Stows to | Purpose |
|---------------|----------|---------|
| `bin/.local/bin/tmux-notify` | `~/.local/bin/tmux-notify` | Main notifier — tmux display-message + OS alert |
| `tmux/.notify.conf` | `~/.notify.conf` | Defaults: target session, OS notifications, sound, duration |
| `tmux/tmux-notify.conf` | (sourced manually) | tmux snippet: status indicator + `Prefix+N` silence toggle |

## Setup

### 1. Stow (if using stow)

```sh
stow bin   # links ~/.local/bin/tmux-notify
stow tmux  # links ~/.notify.conf
```

Or symlink manually:

```sh
ln -sf ~/.dotfiles/bin/.local/bin/tmux-notify ~/.local/bin/tmux-notify
ln -sf ~/.dotfiles/tmux/.notify.conf ~/.notify.conf
```

### 2. Source the tmux snippet

Add to `~/.tmux.conf` (after the existing `status-right` line so it overrides it):

```tmux
source-file ~/.dotfiles/tmux/tmux-notify.conf
```

Reload: `tmux source ~/.tmux.conf`

### 3. Wire up to Claude Code Stop hook

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/miklar/.local/bin/tmux-notify \"Claude Code done\""
          }
        ]
      }
    ]
  }
}
```

## Usage

```sh
tmux-notify                          # "Claude Code task complete"
tmux-notify "Build finished"         # custom message
CLAUDE_NOTIFY_OS=0 tmux-notify "quiet"  # tmux only, no OS alert
```

## Toggle OS notifications

| Method | Effect |
|--------|--------|
| `CLAUDE_NOTIFY_OS=0 tmux-notify` | off for this call only |
| `NOTIFY_OS=0` in `notify.conf` | off permanently |
| `Prefix+N` in tmux | silence ALL notifications (tmux + OS) until toggled back |
| `Prefix+N` again | re-enable |

`Prefix+N` creates/removes `/tmp/tmux-notify-silent`. The script exits early if that file exists.

## Status bar indicator

`🔔` appears in `status-right` after each notification. Clears after `NOTIFY_INDICATOR_DURATION` seconds (default 10). Adjust in `notify.conf`.

## Config reference

```sh
NOTIFY_SESSION=""           # "" = current, "all" = broadcast, "name" = specific
NOTIFY_WINDOW=""            # window within NOTIFY_SESSION (empty = current)
NOTIFY_OS=1                 # 1=on 0=off
NOTIFY_SOUND="default"      # macOS sound ("" = silent)
NOTIFY_URGENCY="normal"     # Linux: low / normal / critical
NOTIFY_INDICATOR_DURATION=10
```
