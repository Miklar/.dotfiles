return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git Diff View" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Close Diff View" },
      {
        "<leader>gh",
        function()
          vim.cmd("DiffviewFileHistory -- " .. vim.fn.fnameescape(vim.fn.expand("%")))
        end,
        desc = "Git File History",
      },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Git Repo History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
        },
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
      },
    },
  },
}
