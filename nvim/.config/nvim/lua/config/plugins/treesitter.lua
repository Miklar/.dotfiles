return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "c_sharp", "go", "lua", "terraform", "vim", "vimdoc", "vue", "query", "yaml", "toml", "tmux", "markdown", "markdown_inline", "sql", "json" },

        -- Automatically install missing parsers when entering buffer
        auto_install = false,

        -- List of parsers to ignore installing (or "all")
        ignore_install = {},

        highlight = {
          enable = true,

          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          additional_vim_regex_highlighting = false,
        },
      }
    end,
  }
}
