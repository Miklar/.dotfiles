# Portability Plan: Mac → Mac + Linux + Windows

## Current state

- Stow-based, Unix-only
- Hard-coded `/opt/homebrew/` paths in zsh
- macOS-only tools: `aerospace`, `.macos`, `homebrew.sh`
- `tmux` clipboard broken cross-platform (mixes `xclip` and `pbcopy`)
- Zero Windows support

---

## Package classification

| Cross-platform | macOS-only | Linux-only | Windows-only |
|---|---|---|---|
| nvim, git, zsh, tmux, starship, alacritty, ghostty, yazi, fd, ripgrep, bin, claude, dbask | aerospace, .macos | — | TBD |

---

## Phase 1 — Fix hardcoded paths in zsh

Replace `/opt/homebrew/` assumptions with OS/arch detection:

```zsh
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"      # Apple Silicon
  # eval "$(/usr/local/bin/brew shellenv)"       # Intel fallback
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
```

Files to audit: `zsh/.zshrc`, `zsh/.zprofile`

---

## Phase 2 — Gate macOS packages in install script

Rewrite `install` with OS detection:

```bash
OS=$(uname -s)    # Darwin | Linux
ARCH=$(uname -m)  # arm64 | x86_64

COMMON_PACKAGES="nvim git zsh tmux starship yazi fd ripgrep bin claude dbask ignore"
MACOS_PACKAGES="aerospace"

stow $COMMON_PACKAGES

if [[ "$OS" == "Darwin" ]]; then
  stow $MACOS_PACKAGES
  bash .macos
fi
```

---

## Phase 3 — Linux support

- Add `linux.sh` (or `apt.sh` / `pacman.sh`) alongside `homebrew.sh` for base tool installation
- Fix tmux clipboard — detect OS at runtime:

```bash
# tmux.conf
if-shell "uname | grep -q Darwin" \
  "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'" \
  "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -selection clipboard'"
```

- Test in a Debian/Ubuntu VM or container before committing

---

## Phase 4 — Windows (WSL-first approach)

Treat Windows as Linux via WSL2. Minimal extra work — existing Linux path covers zsh, nvim, tmux, etc.

Add a `windows/` stow package for Windows-native config:
- `windows/AppData/Local/Packages/.../settings.json` — Windows Terminal
- `windows/Documents/PowerShell/Microsoft.PowerShell_profile.ps1` — PS profile

Add `setup-wsl.ps1` bootstrapper:
```powershell
# Install WSL2, clone dotfiles, run install
wsl --install -d Ubuntu
# ... invoke install script inside WSL
```

### Alternative: native Windows (more effort)

Only worth it if WSL2 is not acceptable (e.g., corporate policy, no virtualization).
Requires: PowerShell profile, `winget.ps1`, symlink script replacing stow, shell switch to PowerShell/Nushell.

**Recommendation: WSL-first.** Toolchain (nvim/zsh/tmux) is Unix-native. WSL2 covers ~95% with minimal extra surface.

---

## Optional: migrate to chezmoi

chezmoi has native OS templating, handles Windows symlinks, works on all platforms without stow:

```
{{ if eq .chezmoi.os "linux" }}
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
{{ end }}
```

Migration cost ~2–3 hours. Worth considering if native Windows support becomes a hard requirement.

---

## Execution order

1. Fix zsh hardcoded paths (Phase 1)
2. Gate macOS packages in `install` (Phase 2)
3. Test on Linux VM/container (Phase 3)
4. Add WSL bootstrap + Windows Terminal config (Phase 4)
