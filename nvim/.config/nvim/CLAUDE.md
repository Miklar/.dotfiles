# Neovim Config

Personal Neovim config managed as a dotfiles stow package (`~/.dotfiles/nvim`), symlinked to `~/.config/nvim`.

## Structure

```
init.lua                          — options, keymaps, autocommands
lua/config/
  lazy.lua                        — lazy.nvim bootstrap
  plugins/                        — one file per plugin, each returns a lazy spec
  telescope/                      — telescope extensions (multigrep)
after/ftplugin/                   — filetype-specific overrides
snippets/                         — VSCode-style snippet JSON files
```

## Conventions

- Plugin files live in `lua/config/plugins/` and return a lazy.nvim spec table.
- Keymaps use `<leader>` (space) and `<localleader>` (backslash).
- LSP formatting runs on save automatically if the server supports it.
- 4-space indentation, no tabs, no line wrap by default.

## Key plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| mason + mason-lspconfig | LSP server installation |
| roslyn.nvim | C# / .NET LSP |
| blink.cmp | Completion |
| fzf-lua | Fuzzy finding (files, grep, LSP symbols) |
| snacks.nvim | Lazygit, scratch buffers, zen mode, git blame |
| harpoon | File bookmarks |
| oil.nvim | File explorer |
| neotest | Test runner |
| easy-dotnet | .NET project tooling |
| octo.nvim | GitHub PRs/issues |

## Adding a new plugin

Create `lua/config/plugins/<name>.lua` returning a lazy spec. Lazy picks it up automatically — no registration needed.
