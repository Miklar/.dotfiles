Follow these steps exactly:

1. Run `git status` and `git diff HEAD` in parallel.
2. If working tree is clean, tell the user and stop.
3. If current branch is `main`:
   a. Suggest a branch name derived from the staged changes.
   b. Ask user to confirm the branch name before creating it.
   c. On confirmation, run `git checkout -b <branch>`.
4. Draft a commit message using Conventional Commits format:
   - Structure: `<type>(<scope>): <short summary>`
   - Types: feat, fix, refactor, style, test, docs, chore, perf, ci
   - Scope: the primary module, directory, or feature area changed
   - Summary: imperative mood, ≤72 chars, no trailing period
   - Add a body only if the why is non-obvious
5. Show the message to the user and ask for confirmation. Accept edits.
6. On confirmation: `git add -A` then commit using a HEREDOC to preserve formatting.
