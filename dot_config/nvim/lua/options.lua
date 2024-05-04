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

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true


vim.opt.showcmd = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.incsearch = true

vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.completeopt = "menu, menuone, noselect"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set highlight on search
vim.opt.hlsearch = true

vim.opt.termguicolors = true

-- Configure how new splits should be opened
vim.opt.splitright = true

-- Disable mouse
-- No need and to be used to vim bindings
vim.opt.mouse = ""

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 5

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.showmatch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false


-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.wildmenu = true
vim.opt.wrap = false
