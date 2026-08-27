---
description: Review personal configuration changes for safety and portability
argument-hint: "[focus]"
---

Review the current configuration changes. Focus on:

- accidental secrets or private runtime state
- portability to a fresh machine
- whether the scope is correct: global Pi, project Pi, or ordinary dotfile
- broken Stow layout or likely symlink conflicts
- syntax errors in JSON, Lua, shell, or Markdown frontmatter

Extra focus: ${ARGUMENTS:-none}
