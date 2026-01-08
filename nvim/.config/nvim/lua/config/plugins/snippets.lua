return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp", -- optional but recommended for regex triggers
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    -- ensure the config runs early enough
    event = "InsertEnter",
    config = function()
      local ls = require("luasnip")

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- Make Neovim's 'cs' filetype also use VSCode's 'csharp' snippets
      ls.filetype_extend("cs", { "csharp" })

      require("luasnip.loaders.from_vscode").lazy_load()

      -- This loads friendly-snippets (VSCode format) automatically
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets",
        },
      })
    end,
  },
}
