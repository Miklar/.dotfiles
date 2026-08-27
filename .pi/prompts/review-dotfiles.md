---
description: Review current dotfiles changes for portability, safety, and config correctness
argument-hint: "[focus]"
---

Review the current dotfiles repo changes. Focus on:

- accidental secrets, credentials, sessions, caches, or machine-local state
- GNU Stow layout correctness
- portability across fresh machines
- shell script safety and idempotence
- Neovim Lua syntax and lazy.nvim config shape
- whether ignored/generated files were touched intentionally

Extra focus: ${ARGUMENTS:-none}
