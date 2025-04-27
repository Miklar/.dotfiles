return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    enabled = true,
    version = "*",

    opts = {
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      completion = {
        list = {
          selection = {
            -- preselect = true,
            -- auto_insert = true
          }
        },
        documentation = {
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        menu = {
          border = "rounded",
          draw = { gap = 2 },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
      },
    },
  },
}
