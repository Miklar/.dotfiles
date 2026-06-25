local M = {}

local config = require("vault.config")

function M.today()
  local filename = string.format("%s/Daily/%s.md", vim.fn.expand(config.vault_path), os.date("%Y-%m-%d"))

  if vim.fn.filereadable(filename) == 0 then
    local file = io.open(filename, "w")

    if file then
      file:write("# " .. os.date("%Y-%m-%d") .. "\n\n")
      file:write("Type:: Daily\n\n")
      file:close()
    end
  end

  vim.cmd.edit(filename)
end

return M
