# Global Agent Instructions

## Azure DevOps

- Default Azure DevOps project: **Harmony** (org: `epiroc-it`). Use this project for all Azure DevOps tool calls unless the user specifies otherwise.
- Default Azure DevOps team: **Harmony Team**. Use this team for team-scoped Azure DevOps tool calls unless the user specifies otherwise.

## Personal workflow

- Be concise and action-oriented.
- When modifying dotfiles, keep GNU Stow layout in mind and avoid committing machine-local state.
- Prefer making reversible, targeted edits over broad rewrites.
- After meaningful work, keep `~/.pi/agent/work-log/YYYY-MM-DD.md` updated using the `daily-standup` skill so the user can draft Teams daily updates later. Do not log secrets, credentials, or private runtime state.
