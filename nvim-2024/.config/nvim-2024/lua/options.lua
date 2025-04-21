-- Enable line numbers
vim.opt.nu = true
-- Enable relative line numbers
vim.opt.relativenumber = true

-- Set tabstop to 4 spaces
vim.opt.tabstop = 4
-- Set soft tabstop to 4 spaces
vim.opt.softtabstop = 4
-- Set shift width to 4 spaces
vim.opt.shiftwidth = 4
-- Use spaces instead of tabs for indentation
vim.opt.expandtab = true
-- Enable smart indenting
vim.opt.smartindent = true

-- Disable line wrapping
vim.opt.wrap = false

-- Disable creation of swap files
vim.opt.swapfile = false
-- Disable creation of backup files
vim.opt.backup = false
-- Set undo directory to ~/.vim/undodir
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
-- Enable persistent undo
vim.opt.undofile = true

-- Disable highlighting during search
vim.opt.hlsearch = false
-- Enable incremental search
vim.opt.incsearch = true

-- Enable true color support in the terminal
vim.opt.termguicolors = true

-- Set scrolloff to 8 lines
vim.opt.scrolloff = 8

-- Show the sign column
vim.opt.signcolumn = 'yes'

-- Include '@-@' in 'isfname' option
vim.opt.isfname:append '@-@'

-- Set updatetime to 50 milliseconds
vim.opt.updatetime = 50

-- To get Obsidian to work
vim.opt.conceallevel = 1

vim.opt.cursorline = true

vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'

vim.o.ignorecase = true
vim.o.smartcase = true
