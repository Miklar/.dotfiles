# Agents

## Structure

Plugins live in `lua/config/plugins/`, one file per plugin, each returning a lazy.nvim spec. Adding a file there is enough — no registration needed.

## Conventions

- 4-space indentation, no tabs.
- Keymaps go in the plugin's `keys` table, not in `init.lua`, unless they are global/non-plugin bindings.
- `<leader>` is space. Group new plugin keymaps under a logical prefix and add a `desc`.
- Do not add comments explaining what code does — only use comments for non-obvious workarounds.

## Testing changes

There is no test suite. To verify a change, source the file with `<leader><leader>x` or restart Neovim. Check `:Lazy` for plugin load errors and `:checkhealth` for LSP/tool issues.

## What to avoid

- Do not modify `lazy-lock.json` manually.
- Do not add plugins without a clear purpose — keep the config lean.
- Do not add keymaps that conflict with existing ones in `init.lua` or snacks.nvim.
