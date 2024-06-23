
-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Disable mouse
vim.opt.mouse = ""

-- Set habamax colorscheme
vim.cmd [[colorscheme habamax]]

-- Line numbers as default
-- Relative line numbers for jumping
vim.opt.nu = true
vim.opt.relativenumber = true

-- Display settings
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.showcmd = true
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.incsearch = true

-- More QOL options
vim.opt.clipboard = ""
vim.opt.encoding = "utf-8"

-- disable cursorline
vim.opt.cursorline = false

-- Set highlight on search
vim.opt.hlsearch = true

vim.opt.termguicolors = true

-- Configure how new splits should be opened
vim.opt.splitright = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.showmatch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"


-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.wildmenu = true
vim.opt.wrap = false

-- guicursor options preference
vim.opt.guicursor = {
  "n-v-c:block",                                  -- Normal, visual, command-line: block cursor
  "i-ci-ve:ver25",                                -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  "r-cr:hor20",                                   -- Replace, command-line replace: horizontal bar cursor with 20% height
  "o:hor50",                                      -- Operator-pending: horizontal bar cursor with 50% height
  "a:blinkwait700-blinkoff400-blinkon250",        -- All modes: blinking settings
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}

-- netrw settings
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = 'cp -r'
