return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      local ensure = {
        "c", "c_sharp", "go", "lua", "terraform", "vim", "vimdoc", "vue",
        "query", "yaml", "toml", "markdown", "markdown_inline",
        "sql", "json",
      }
      require("nvim-treesitter").install(ensure)

      local max_filesize = 100 * 1024 -- 100 KB
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end

          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return end

          pcall(vim.treesitter.start, buf, lang)
        end,
      })
    end,
  },
}
