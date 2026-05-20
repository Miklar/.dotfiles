Summarize the changes on the current branch compared to main.

1. Run these in parallel:
   - `git log main..HEAD --oneline`
   - `git diff main..HEAD --stat`
2. Write a plain-English summary (3–5 sentences) covering:
   - What was added or changed and why (infer from commit messages and filenames)
   - Any notable files touched
3. Keep it non-technical enough for a product manager to understand.
