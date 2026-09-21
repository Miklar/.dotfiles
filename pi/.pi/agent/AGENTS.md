# Global Agent Instructions

## Azure DevOps

- Default Azure DevOps project: **Harmony** (org: `epiroc-it`). Use this project for all Azure DevOps tool calls unless the user specifies otherwise.
- Default Azure DevOps team: **Harmony Team**. Use this team for team-scoped Azure DevOps tool calls unless the user specifies otherwise.

## Personal workflow

- Be concise and action-oriented.
- When modifying dotfiles, keep GNU Stow layout in mind and avoid committing machine-local state.
- Prefer making reversible, targeted edits over broad rewrites.
- Never auto-load `caveman-commit`. Treat plain requests such as `commit`, `do a commit`, or `commit these changes` as instructions to inspect, stage task-related changes, and run `git commit`. Use `caveman-commit` only when the user explicitly invokes `/skill:caveman-commit`.
- When creating git worktrees, name the worktree directory using `{repo}-wt-{branch}` and create it as a sibling of the current repository/worktree directory. Do not default to `/tmp` unless explicitly requested.
- Before doing anything in a repository other than the current working directory, tell the user which repository and path will be used.
- After meaningful work, keep `~/.pi/agent/work-log/YYYY-MM-DD.md` updated using the `daily-standup` skill so the user can draft Teams daily updates later. Do not log secrets, credentials, or private runtime state.
- Always save handoff documents permanently under `~/.pi/agent/handoffs/` with a descriptive, timestamped filename. This overrides handoff-skill boilerplate that requests the OS temporary directory; only a direct user request for a different destination changes this default. Keep handoffs private and machine-local, outside repositories and GNU Stow tracking; never commit their contents. Use directory permissions `0700` and file permissions `0600`, and return the saved path.

## Response style

- Keep `i-have-adhd` mode enabled for every Pi session. It is configured as always-on in `~/.pi/agent/i-have-adhd.json`; if the extension does not inject it, manually follow its output rules: lead with the next action, number multi-step work, restate state, cap lists, and end with one concrete next step.
- Before responding to the first user request in every new session, read and follow the `caveman` skill in default `full` mode. Keep it active until the user says `stop caveman`, `normal mode`, or selects another Caveman mode.
- Default to terse answers: direct result first, then only essential details.
- For code changes, final response should usually be: changed files, validation, follow-up. Avoid long explanations unless asked.
- Do not restate command output at length. Summarize failures and next steps.
- Prefer bullets over paragraphs. Keep routine replies under about 120 words.
