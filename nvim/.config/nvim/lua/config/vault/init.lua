local M = {}

local fzf = require("fzf-lua")
local capture = require("config.vault.capture")
local config = require("config.vault.config")

local function rg_files(pattern)
  local cmd = string.format("rg -l '%s' %s", pattern, config.vault_path)
  local handle = io.popen(cmd)
  if not handle then
    return {}
  end
  local files = {}
  for line in handle:lines() do
    table.insert(files, line)
  end
  handle:close()
  return files
end

local function picker(title, pattern)
  local files = rg_files(pattern)
  fzf.fzf_exec(files, {
    prompt = title .. "> ",
    actions = {
      ["default"] = function(selected)
        if selected[1] then
          vim.cmd("edit " .. selected[1])
        end
      end,
    },
  })
end

function M.projects()
  picker("Active Projects", "Status:: Active")
end

function M.incubator()
  picker("Incubator", "Type:: Incubator")
end

function M.daily()
  picker("Daily Notes", "Type:: Daily")
end

function M.dashboard()
  fzf.fzf_exec({
    "Projects",
    "Incubator",
    "Today",
    "Capture",
  }, {
    prompt = "Vault> ",
    actions = {
      ["default"] = function(selected)
        local choice = selected[1]
        if choice == "Projects" then
          M.projects()
        elseif choice == "Incubator" then
          M.incubator()
        elseif choice == "Today" then
          M.daily()
        elseif choice == "Capture" then
          capture.capture()
        end
      end,
    },
  })
end

function M.setup()
  require("config.vault.keymaps").setup(M)
end

return M
