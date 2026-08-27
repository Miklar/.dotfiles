# Repo conventions

- This repo only uses `main`. Commit directly to `main` — do not create feature branches for routine changes.
- Pi project-local resources live under `.pi/` and apply only when working in this repo.
- Global Pi resources are stored as the `pi` stow package under `pi/.pi/agent/` and symlink to `~/.pi/agent/`.
- Never commit Pi credentials, sessions, trust state, package caches, or other machine-local runtime state.
