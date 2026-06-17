return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = { { "-", "<CMD>Oil<CR>", desc = "Open parent directory" } },
    config = function()
      require("oil").setup({
        keymaps = {
          -- ["<C-h>"] = false,
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
}
