local M = {}

local config = require("config.vault.config")
local fzf = require("fzf-lua")

local function grep_picker(title, pattern, folder)
  fzf.files({
    prompt = title .. "> ",
    cwd = vim.fn.expand(config.vault_path),
    cmd = string.format("rg -l '%s' %s", pattern, folder or "."),
    previewer = "builtin",
  })
end

function M.projects()
  fzf.files({
    prompt = "Projects> ",
    cwd = vim.fn.expand(config.vault_path) .. "/Projects",
    previewer = "builtin",
  })
end

function M.incubator()
  grep_picker("Incubator", "Category::", "Incubator")
end

function M.daily()
  grep_picker("Daily", "Updated::", "Daily")
end

return M
