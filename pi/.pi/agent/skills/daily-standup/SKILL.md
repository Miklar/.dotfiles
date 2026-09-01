---
name: daily-standup
description: Maintains a private rolling work log and drafts concise Microsoft Teams daily standup updates. USE FOR: tracking what the user worked on, capturing completed work/decisions/blockers/next steps, or writing "what should I say in daily?" messages. DO NOT USE FOR: committing work logs, storing secrets, or formal project status reports that need external source-of-truth verification.
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
- Do not query external systems unless the user asks; the local work log is the default source.

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

### Step 4: Keep it private and safe

Sanitize entries:

- Replace secrets with `[redacted]`.
- Prefer issue/PR IDs over long URLs when possible.
- Summarize private conversation content as an outcome, not a transcript.

## Workflow: Draft Teams Daily

When asked for a daily update:

1. Read today's work log.
2. If useful, also read yesterday's log for carry-over context.
3. Optionally inspect local `git status` only to catch unlogged current work.
4. Draft a paste-ready Teams message in first person.
5. Keep it brief: 3 sections max.

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
- When drafting Teams text, output only the draft unless the user asks for explanation.
- Match the user's preferred casual standup tone when provided; concise sentence bullets are better than formal project-report bullets.
- Be honest about uncertainty: say `I don't have a log entry for...` rather than inventing.

## Validation

- [ ] Today's log exists only under `~/.pi/agent/work-log/`.
- [ ] No secrets or sensitive details were logged.
- [ ] Entries distinguish done, in-progress, blockers, and next steps.
- [ ] Teams draft is concise and paste-ready.
