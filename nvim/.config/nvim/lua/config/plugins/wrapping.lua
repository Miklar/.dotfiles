return {
  {
    "andrewferrier/wrapping.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>wr",
        "<Plug>(wrapping-toggle-wrap-mode)",
        desc = "Toggle Wrap Mode",
      },
    },
    opts = {
      softener = { markdown = true },
    },
  },
}
