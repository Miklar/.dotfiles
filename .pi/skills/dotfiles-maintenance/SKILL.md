---
name: dotfiles-maintenance
description: >-
  Maintains this dotfiles repo's GNU Stow layout, Pi configuration, shell tools,
  and portability conventions. USE FOR: changing dotfiles, adding a new stow
  package, editing install scripts, managing repo-local/global Pi resources, or
  checking for secrets and machine-local state. DO NOT USE FOR: ordinary
  application code outside this dotfiles repository.
---

# Dotfiles Maintenance

Use this skill to keep the dotfiles repo portable, safe to sync, and compatible with its Stow-based layout.

## When to Use

- Adding or changing configuration under a top-level stow package such as `nvim/`, `tmux/`, `zsh/`, `git/`, or `pi/`.
- Editing `install.sh`, `stow_install.sh`, or `stow_uninstall.sh`.
- Adding repo-local Pi resources under `.pi/`.
- Adding global Pi resources intended to be stowed from `pi/.pi/agent/`.
- Reviewing changes for secrets, caches, absolute machine-local paths, or non-portable assumptions.

## When Not to Use

- Do not use for feature work in non-dotfiles application repositories.
- Do not use as a replacement for language-specific skills when modifying real source code projects.
- Do not commit generated caches, sessions, credentials, lockfiles that are intentionally ignored, or tool runtime state.

## Workflow

### Step 1: Classify the change

Decide whether the requested change is:

1. A project-local agent resource in `.pi/`.
2. A global/stowed user config in `pi/.pi/agent/`.
3. A stowed application config such as `nvim/.config/nvim/` or `tmux/.tmux.conf`.
4. An installer/bootstrap change.

### Step 2: Preserve Stow layout

- Top-level package directories should mirror paths under `$HOME`.
- Example: `pi/.pi/agent/settings.json` stows to `~/.pi/agent/settings.json`.
- Avoid placing explanatory repo-only files inside stow packages unless they are ignored by Stow.

### Step 3: Protect local/private state

Before adding files, check that secrets and generated state are ignored. Pi-specific private paths include:

- `auth.json`
- `sessions/`
- `trust.json`
- `models-store.json`
- `npm/`
- `git/`
- `*.log`

Do not read or copy credentials unless the user explicitly asks and the file is required for the task.

### Step 4: Validate the edit

Run targeted validation where available:

- Lua config: `luac -p <file>`.
- Shell scripts: `bash -n <file>` or `zsh -n <file>` matching the shebang.
- JSON settings: `python3 -m json.tool <file>`.

### Step 5: Report migration steps

If adding a new stow package that may conflict with existing files in `$HOME`, do not claim it is installed. Tell the user which files may need to be moved, backed up, or adopted before running Stow.

## Validation

- [ ] Changed files fit the repo's Stow layout.
- [ ] Private runtime state is ignored.
- [ ] Syntax validation ran for edited Lua, shell, or JSON files when possible.
- [ ] Final response names any manual Stow/migration step.

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Adding `README.md` inside a stow package | Put docs outside the package or add Stow ignore rules. |
| Committing `~/.pi/agent/auth.json` or sessions | Keep them ignored; never copy them into the repo. |
| Adding a stow package to install scripts without warning about existing files | Mention the likely conflict and provide a migration command. |
| Confusing repo `.pi/` with stowed `pi/.pi/agent/` | `.pi/` affects this repo only; `pi/.pi/agent/` becomes global after Stow. |
