return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function ()
    local fzf = require('fzf-lua')
    fzf.setup({
      "hide",
      })

      local fzflua = require 'fzf-lua'
      vim.keymap.set("n", "<leader>fh", fzflua.helptags)
      vim.keymap.set('n', '<leader>fd', function() require('fzf-lua').files() end, { desc = 'FZF: find files' })

      vim.keymap.set("n", "<leader>fq", fzflua.quickfix)
      vim.keymap.set("n", "<leader>fw", fzflua.grep_cword)
      vim.keymap.set("n", "<leader>fg", fzflua.live_grep)
      vim.keymap.set("n", "<leader>fr", fzflua.resume)
      vim.keymap.set("n", "<leader>fk", fzflua.keymaps)
      vim.keymap.set("n", "<leader>fb", fzflua.buffers)
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>fD', fzflua.diagnostics_document, { desc = '[S]earch [D]iagnostics' })

       -- use `fzf-lua` for replace vim.ui.select 
        fzflua.register_ui_select()
    end
  }
