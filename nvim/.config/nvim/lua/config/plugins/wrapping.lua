return {
  {
    "andrewferrier/wrapping.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>uw",
        "<Plug>(wrapping-toggle-wrap-mode)",
        desc = "Toggle Wrap Mode",
      },
    },
    opts = {},
  },
}
