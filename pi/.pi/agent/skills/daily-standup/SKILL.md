---
name: daily-standup
description: >-
  Maintains a private rolling work log and drafts concise Microsoft Teams daily
  standup updates. USE FOR: tracking what the user worked on, capturing completed
  work/decisions/blockers/next steps, or writing "what should I say in daily?"
  messages. Drafts combine the private work log with local git history from
  ~/dev/work/epiroc/* so AI-assisted and non-AI committed work can both appear,
  while excluding personal dotfiles/global agent setup from Teams daily summaries.
  DO NOT USE FOR: committing work logs, storing secrets, or formal project status
  reports that need external source-of-truth verification.
---

# Daily Standup

Keep a lightweight private work log and turn it into a short Teams-ready daily update.

## Scope

- Log location: `~/.pi/agent/work-log/YYYY-MM-DD.md`.
- The log is private machine-local state, not a repo artifact.
- Never commit work logs to dotfiles or application repositories.
- Do not include secrets, tokens, credentials, customer-sensitive data, private message contents, or full incident details.

## When to Use

- After a meaningful task, code change, investigation, review, meeting preparation, or decision.
- When the user asks what they worked on today.
- When the user asks for a daily/standup/Teams update.
- When wrapping up a session and there is useful progress to preserve.

## When Not to Use

- Do not log trivial chat with no work outcome.
- Do not log secrets or detailed private/confidential content.
- Do not claim work was completed if validation failed or the change was only planned.
- Do not query external systems unless the user asks; local git history is allowed, but do not fetch/pull by default.

## Work Log Format

Create or update today's file with this structure:

```markdown
# Work Log - YYYY-MM-DD

## Done
- HH:MM — <concise completed outcome> (`<project or repo>`)

## In Progress
- <current work that is not done yet>

## Blockers
- <blocker or dependency, or omit if none>

## Decisions / Notes
- <important decision, discovery, command, PR, work item, or follow-up>

## Standup Inputs
- <work items the user explicitly asked to include in a daily/standup summary>

## Standup
<latest paste-ready daily summary for the day it will be used>

## Tomorrow / Next
- <likely next step>
```

Use local time. If a section has no entries, leave the heading empty or omit obvious placeholder text.

## Workflow: Track Work

### Step 1: Decide whether to log

Log only if the interaction produced a useful work artifact or status signal, such as:

- files changed or committed
- bug diagnosed
- tests/builds run
- PR/review/release work completed
- a plan or architectural decision made
- a blocker discovered

### Step 2: Read today's existing log

Read `~/.pi/agent/work-log/YYYY-MM-DD.md` if it exists. If not, create the directory and file.

### Step 3: Update rather than duplicate

- Merge with an existing bullet when the new event continues the same task.
- Move stale `In Progress` items to `Done` when the work is now complete.
- Add validation outcome when relevant, e.g. `validated with dotnet test` or `syntax checked with luac -p`.
- Keep bullets short enough to paste into a standup summary later.
- If the user explicitly asks to put down/include a work item for daily/standup, record it under `## Standup Inputs` and preserve the user's intended meaning/tone.

### Step 4: Keep it private and safe

Sanitize entries:

- Replace secrets with `[redacted]`.
- Prefer issue/PR IDs over long URLs when possible.
- Summarize private conversation content as an outcome, not a transcript.

## Workflow: Draft Teams Daily

When asked for a daily update:

1. Determine the work-log date the summary will be used for (default: today's local date; if the user says tomorrow or another date, use that date).
2. Read that day's work log, plus yesterday's log when useful for carry-over context.
3. Scan local git history under `~/dev/work/epiroc/*` for user-authored work from the relevant window (usually yesterday 00:00 through now for a morning daily). Use all local refs/branches so work on non-current branches is not missed. Do not fetch/pull unless the user explicitly asks.
4. Optionally inspect local `git status` in relevant repos only to catch unlogged current work; summarize as WIP, not done, unless committed or logged as complete.
5. Reconcile work-log entries, explicit standup inputs, and git history. Prefer the work log for intent/context; use git commits for additional facts. Exclude `~/.dotfiles`, `~/.pi/agent`, global agent skills/settings, shell/editor dotfile changes, and other personal dev-environment maintenance from Teams daily summaries unless the user explicitly asks to include them. Include all other user-explicit standup inputs unless unsafe.
6. Draft a paste-ready Teams message in first person, 3 sections max.
7. Write the exact generated summary into `~/.pi/agent/work-log/YYYY-MM-DD.md` under `## Standup`, replacing the previous generated standup for that date rather than duplicating it.

### Local Git History Scan

Use a bounded local-only scan so daily drafts include both AI-assisted and non-AI work:

```bash
for repo in ~/dev/work/epiroc/*; do
  test -d "$repo/.git" || continue
  git -C "$repo" log --since="yesterday 00:00" --author="$(git -C "$repo" config user.email)" \
    --date=short --format='%ad %h %s' --all --
done
```

`--all` means all local refs/branches already present in the clone, including remote-tracking refs that exist locally. It does not fetch network updates.

If the repo has a different author email or commits are missing, retry with `git config user.name` or inspect recent local commits without an author filter, but mark uncertainty. Do not include generated, secret, machine-local, dotfiles, or global agent setup details. Collapse noisy commit lists into outcomes by repo.

Tone of voice:

- Write like a normal team daily, not a status report.
- Prefer natural first-person phrasing such as `Finished up...`, `Started looking into...`, `Got it down from X to Y...`.
- Lead with the actual outcome, then mention the area if needed.
- Keep technical detail high-level unless the log makes a precise detail important.
- Avoid over-polished corporate wording, inflated impact, or invented certainty.

Default format:

```text
Good morning! Quick update:

Yesterday / done:
- ...

Today:
- ...

Blockers:
- None
```

If the user wants something shorter, use:

```text
Yesterday I ..., today I'm ..., no blockers.
```

## Output Rules

- When tracking work as part of another task, mention at most one short sentence: `Updated the work log.`
- When drafting Teams text, output only the draft unless the user asks for explanation; still update the target day's `## Standup` section first.
- Match the user's preferred casual standup tone when provided; concise sentence bullets are better than formal project-report bullets.
- User-explicit standup items are mandatory in the summary unless they would expose secrets or sensitive details; if they must be sanitized, keep the safe gist.
- Be honest about uncertainty: say `I don't have a log entry for...` or `local git history shows...` rather than inventing.
- Do not dump commit lists into the chat; summarize them into human standup bullets.
- Do not include `~/.dotfiles` or global Pi/agent setup changes in Teams daily summaries unless explicitly requested.

## Validation

- [ ] Today's log exists only under `~/.pi/agent/work-log/`.
- [ ] No secrets or sensitive details were logged.
- [ ] Entries distinguish done, in-progress, blockers, and next steps.
- [ ] Teams draft is concise and paste-ready.
- [ ] Local git history under `~/dev/work/epiroc/*` was checked, or skipped with an explicit reason.
- [ ] Dotfiles/global agent setup work was omitted from the Teams daily summary unless explicitly requested.
