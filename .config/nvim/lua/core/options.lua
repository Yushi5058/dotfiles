vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.title = true

vim.opt.number = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.wrap = false

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

vim.opt.shell="fish"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.opt.hlsearch = true

vim.opt.termguicolors = true

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.opt.scrolloff = 10
vim.opt.laststatus = 2

-- disable mouse
vim.opt.mouse = ""

