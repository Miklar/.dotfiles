---
name: caveman-commit
description: Write a terse Conventional Commits message only when explicitly invoked with /skill:caveman-commit. Never stages files, runs git commit, or amends commits.
disable-model-invocation: true
---

# Caveman Commit

Write a Conventional Commits message compressed to intent only. This skill is message-only and must be invoked explicitly.

## Subject

- Format: `<type>(<scope>): <imperative summary>`; scope is optional.
- Use `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, or `revert`.
- Use imperative mood: `add`, `fix`, `remove`.
- Keep it at or below 50 characters when practical, with a hard limit of 72.
- Do not end with a period.
- Match the repository's capitalization convention.

## Body

Skip the body when the subject is self-explanatory. Include one when the change has a non-obvious reason, breaking behavior, migration instructions, security implications, or issue references.

- Wrap at 72 characters.
- Use `-` for bullets.
- Put issue references at the end, such as `Closes #42`.
- Use a `BREAKING CHANGE:` trailer when required.

## Output

Return only the commit message in a code block ready to paste. Do not stage files, run `git commit`, or amend a commit.
