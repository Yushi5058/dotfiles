-- Set space as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.mapleader = " "

-- Line numbers as default
-- Relative line numbers for jumping
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set highlight on search
vim.opt.hlsearch = true

-- Configure how new splits should be opened
vim.opt.splitright = true

-- Disable mouse
-- No need and to be used to vim bindings
vim.opt.mouse = ""

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 250
vim.o.timeoutlen = 300
