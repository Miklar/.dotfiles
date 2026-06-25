local M = {}

local fzf = require("fzf-lua")
local config = require("config.vault.config")
local vault_path = config.vault_path

local function append(file, text)
  local f = io.open(file, "a")

  if not f then
    return
  end

  f:write(text .. "\n")
  f:close()
end

local function today_file()
  return string.format("%s/Daily/%s.md", vault_path, os.date("%Y-%m-%d"))
end

local function ensure_daily()
  local path = today_file()

  local f = io.open(path, "r")

  if f then
    f:close()
    return path
  end

  f = io.open(path, "w")

  if not f then
    return path
  end

  f:write("# " .. os.date("%Y-%m-%d") .. "\n\n")
  f:write("Type:: Daily\n\n")
  f:close()

  return path
end

function M.capture()
  vim.ui.input({
    prompt = "Capture: ",
  }, function(input)
    if not input or input == "" then
      return
    end

    fzf.fzf_exec({
      "Inbox",
      "Today",
      "Project Idea",
    }, {
      prompt = "Capture> ",
      actions = {
        ["default"] = function(selected)
          local choice = selected[1]

          if choice == "Inbox" then
            append(vault_path .. "/Inbox/Capture.md", "- " .. input)
          end

          if choice == "Today" then
            append(ensure_daily(), "- " .. input)
          end

          if choice == "Project Idea" then
            append(vault_path .. "/Incubator/Project Ideas.md", "- " .. input)
          end
        end,
      },
    })
  end)
end

function M.today()
  local file = ensure_daily()
  vim.cmd("edit " .. file)
end

return M
