---
name: personal-dev-environment
description: >-
  Maintains the user's personal development environment and global Pi setup. USE
  FOR: changing global Pi settings, stowed user-level agent skills/prompts,
  shell/editor/tooling preferences, or cross-repo dotfile behavior. DO NOT USE
  FOR: project-local application code unless the task is explicitly about
  developer environment configuration.
---

# Personal Dev Environment

Use this skill when a task changes the user's global developer environment rather than one application project.

## When to Use

- Editing global Pi config stored under `pi/.pi/agent/` in the dotfiles repo.
- Adding reusable global skills or prompt templates.
- Changing shell/editor/tooling behavior intended to apply across projects.
- Reviewing whether a setting belongs globally, in a repo-local `.pi/`, or in `AGENTS.md`.

## When Not to Use

- Do not use for normal application feature work.
- Do not use for repo-local conventions when a project-specific skill is more precise.
- Do not store credentials, OAuth tokens, session files, or trust decisions in dotfiles.

## Workflow

### Step 1: Pick the correct scope

Use this decision table:

| Need | Put it here |
|---|---|
| Applies to every Pi session | `pi/.pi/agent/AGENTS.md` or `pi/.pi/agent/settings.json` |
| Reusable workflow across repos | `pi/.pi/agent/skills/<name>/SKILL.md` |
| Reusable slash command | `pi/.pi/agent/prompts/<name>.md` |
| Only applies to the current repository | `.pi/` or repo `AGENTS.md` |
| Secret/auth/session/cache/trust state | Do not commit |

### Step 2: Preserve existing user preferences

When changing global settings, keep existing provider/model/package choices unless the user explicitly asks to change them.

### Step 3: Validate files

- JSON: `python3 -m json.tool <file>`.
- Skills: check lowercase hyphenated `name`, non-empty `description`, and actionable workflow.
- Prompt templates: ensure frontmatter is valid and the filename is the intended slash command.

### Step 4: Explain activation

If the global config has not yet been stowed, tell the user how to link it and warn about existing `~/.pi/agent` files that may conflict.

## Validation

- [ ] Global config contains no secrets or generated state.
- [ ] Settings preserve the user's provider/model/package choices unless intentionally changed.
- [ ] Skill and prompt names are stable and memorable.
- [ ] Final response explains whether the files are active or only scaffolded.

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Putting repo-specific behavior in global `AGENTS.md` | Put it in the repo's `AGENTS.md` or `.pi/` resources. |
| Committing `auth.json`, `trust.json`, `sessions/`, or package caches | Ignore them and leave them local. |
| Assuming Stow overwrites existing files | Back up/adopt existing files before stowing `pi`. |
