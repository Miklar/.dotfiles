return {
  'arnarg/todotxt.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  config = function()
    require('todotxt-nvim').setup {
      todo_file = '/Users/miklar/todo/todo.txt',
    }

    vim.keymap.set('n', '<leader>td', '<cmd>ToDoTxtTasksToggle<cr>')
    vim.keymap.set('n', '<leader>ta', '<cmd>ToDoTxtCapture<cr>')
  end,
}
