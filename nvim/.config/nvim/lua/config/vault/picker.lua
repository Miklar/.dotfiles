local M = {}

local config = require("vault.config")
local fzf = require("fzf-lua")

local function grep_picker(title, pattern)
  fzf.files({
    prompt = title .. "> ",
    cwd = vim.fn.expand(config.vault_path),

    cmd = string.format("rg -l '%s' .", pattern),

    previewer = "builtin",
  })
end

function M.projects()
  grep_picker("Projects", "Status:: Active")
end

function M.incubator()
  grep_picker("Incubator", "Type:: Incubator")
end

function M.daily()
  grep_picker("Daily", "Type:: Daily")
end

return M
