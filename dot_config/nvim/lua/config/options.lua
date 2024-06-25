vim.opt.mouse = "a"
vim.opt.confirm = true
vim.opt.cursorline = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.showcmd = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = false
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.clipboard = ""
vim.opt.encoding = "utf-8"
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.splitright = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.signcolumn = "no"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.wildmenu = true
vim.opt.wrap = false

-- guicursor options preference
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}
