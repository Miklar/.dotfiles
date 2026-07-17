local M = {}

local fzf = require("fzf-lua")
local capture = require("config.vault.capture")
local picker = require("config.vault.picker")

function M.projects()
  picker.projects()
end

function M.incubator()
  picker.incubator()
end

function M.daily()
  picker.daily()
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
          picker.projects()
        elseif choice == "Incubator" then
          picker.incubator()
        elseif choice == "Today" then
          picker.daily()
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
