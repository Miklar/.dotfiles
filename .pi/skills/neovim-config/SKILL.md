---
name: neovim-config
description: Maintains this repo's Neovim Lua configuration. USE FOR: adding or configuring Neovim plugins, changing keymaps, LSP setup, diagnostics, treesitter, snippets, or lazy.nvim specs under nvim/.config/nvim. DO NOT USE FOR: editing unrelated dotfiles unless the task also touches Neovim.
---

# Neovim Config

Use this skill when modifying `nvim/.config/nvim` in this dotfiles repo.

## When to Use

- Adding a new lazy.nvim plugin spec.
- Changing keymaps in `init.lua` or plugin configs.
- Editing LSP, diagnostics, completion, treesitter, DAP, snippets, or Git tooling.
- Troubleshooting a Neovim config error.

## When Not to Use

- Do not use for non-Neovim dotfiles.
- Do not use for application Lua code outside `nvim/.config/nvim`.
- Do not update `lazy-lock.json` unless the user explicitly asks to sync plugin versions.

## Workflow

### Step 1: Locate the existing pattern

- Plugin specs live in `nvim/.config/nvim/lua/config/plugins/`.
- General editor options and broad keymaps live in `nvim/.config/nvim/init.lua`.
- Filetype-specific settings live in `nvim/.config/nvim/after/ftplugin/`.

### Step 2: Prefer lazy.nvim-native declarations

For plugin specs:

- Use `cmd`, `event`, `ft`, or `keys` to lazy-load when practical.
- Put plugin-specific keymaps in the plugin spec's `keys` table when they should trigger lazy-loading.
- Keep `config` or `opts` small and focused.

### Step 3: Preserve keymap conventions

- Use `<leader>g...` for Git-related actions.
- Use `<leader>f...` for fzf/search actions.
- Use `<leader>t...` for test actions.
- Use descriptive `desc` values so keymap discovery works.

### Step 4: Validate syntax

After editing Lua files, run:

```bash
luac -p path/to/file.lua
```

If multiple Lua files changed, validate each changed file.

## Validation

- [ ] Plugin specs return valid Lua tables.
- [ ] Keymaps include useful `desc` fields.
- [ ] Lazy-loading trigger exists for optional plugins.
- [ ] `luac -p` passes for edited Lua files.

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Adding eager plugins unnecessarily | Add `cmd`, `event`, `ft`, or `keys`. |
| Keymaps only created after plugin load but not listed in `keys` | Put trigger mappings in `keys` so lazy.nvim can load the plugin. |
| Accidentally updating `lazy-lock.json` | Leave it alone unless plugin pinning is part of the task. |
| Using unescaped `%` or file paths in commands | Prefer Lua functions with `vim.fn.fnameescape`. |
