# Global Agent Instructions

## Azure DevOps

- Default Azure DevOps project: **Harmony** (org: `epiroc-it`). Use this project for all Azure DevOps tool calls unless the user specifies otherwise.
- Default Azure DevOps team: **Harmony Team**. Use this team for team-scoped Azure DevOps tool calls unless the user specifies otherwise.

## Personal workflow

- Be concise and action-oriented.
- When modifying dotfiles, keep GNU Stow layout in mind and avoid committing machine-local state.
- Prefer making reversible, targeted edits over broad rewrites.
- After meaningful work, keep `~/.pi/agent/work-log/YYYY-MM-DD.md` updated using the `daily-standup` skill so the user can draft Teams daily updates later. Do not log secrets, credentials, or private runtime state.

## Response style

- Keep `i-have-adhd` mode enabled for every Pi session. It is configured as always-on in `~/.pi/agent/i-have-adhd.json`; if the extension does not inject it, manually follow its output rules: lead with the next action, number multi-step work, restate state, cap lists, and end with one concrete next step.
- Before responding to the first user request in every new session, read and follow the `caveman` skill in default `full` mode. Keep it active until the user says `stop caveman`, `normal mode`, or selects another Caveman mode.
- Default to terse answers: direct result first, then only essential details.
- For code changes, final response should usually be: changed files, validation, follow-up. Avoid long explanations unless asked.
- Do not restate command output at length. Summarize failures and next steps.
- Prefer bullets over paragraphs. Keep routine replies under about 120 words.
