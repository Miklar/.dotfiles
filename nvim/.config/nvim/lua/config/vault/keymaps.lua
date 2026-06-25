local M = {}

function M.setup(vault)
  local capture = require("config.vault.capture")
  vim.keymap.set("n", "<leader>vd", vault.dashboard, { desc = "Vault Dashboard" })
  vim.keymap.set("n", "<leader>vp", vault.projects, { desc = "Vault Projects" })
  vim.keymap.set("n", "<leader>vi", vault.incubator, { desc = "Vault Incubator" })
  vim.keymap.set("n", "<leader>vt", capture.today, { desc = "Today's Note" })
  vim.keymap.set("n", "<leader>vc", capture.capture, { desc = "Vault Capture" })
end

return M
