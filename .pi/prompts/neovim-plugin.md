---
description: Add or adjust a Neovim plugin in this repo's lazy.nvim config
argument-hint: "<plugin-or-goal>"
---

Add or adjust Neovim configuration for: $ARGUMENTS

Use this repo's existing layout:

- plugin specs: `nvim/.config/nvim/lua/config/plugins/`
- general keymaps/options: `nvim/.config/nvim/init.lua`
- filetype overrides: `nvim/.config/nvim/after/ftplugin/`

Prefer lazy-loading with `cmd`, `event`, `ft`, or `keys`, include useful keymap descriptions, and validate edited Lua with `luac -p`.
