return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = false,
            -- theme = "default"
          },
        },
        extensions = {
          fzf = {},
        },
      })
      require("telescope").load_extension("fzf")

      vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
      vim.keymap.set("n", "<leader>fd", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string)
      vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume)
      vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps)
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)

      vim.keymap.set("n", "<leader>en", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end)

      require("config.telescope.multigrep").setup()
    end,
  },
}
