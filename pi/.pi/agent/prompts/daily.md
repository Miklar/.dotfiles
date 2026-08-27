---
description: Draft a concise Teams daily standup update from the private Pi work log
argument-hint: "[tone/focus]"
---

Use the `daily-standup` skill to draft a paste-ready Microsoft Teams daily update from `~/.pi/agent/work-log/`.

Default format:

Good morning! Quick update:

Yesterday / done:
- ...

Today:
- ...

Blockers:
- None

Keep it concise, first person, and honest. Do not invent work that is not in the log. Tone/focus: ${ARGUMENTS:-normal team daily}
