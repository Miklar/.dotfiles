---
description: Finish the current coding-agent task with validation and a concise summary
argument-hint: "[instructions]"
---

Finish the current task end-to-end.

Before responding:

1. Check the current git diff/status.
2. Run the smallest relevant validation commands.
3. Do not overwrite unrelated user changes.
4. Report changed files, validation results, and any manual follow-up.

Additional instructions: ${ARGUMENTS:-none}
