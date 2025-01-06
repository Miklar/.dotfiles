return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return 'OLD ' .. str:sub(1, 1)
            end,
          },
        },
      },
    }
  end,
}
