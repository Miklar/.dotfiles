return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>um",
        "<cmd>RenderMarkdown toggle<CR>",
        ft = "markdown",
        desc = "Toggle Markdown Rendering",
      },
    },
    opts = {
      render_modes = { "n", "c", "t" },
      completions = { lsp = { enabled = true } },
      latex = { enabled = false },
      heading = {
        position = "inline",
        backgrounds = {},
      },
    },
  },
}
