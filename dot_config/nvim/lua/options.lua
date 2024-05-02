-- Set space as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

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

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- netrw options
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
