vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Set clipboard provider to system clipboard
local clipboard = vim.fn.getreg('+')
clipboard = clipboard .. ',unnamedplus'
clipboard = clipboard .. ',unnamed'
clipboard = clipboard .. ',unnamed,unnamedplus'
clipboard = clipboard .. ',wl-copy'

vim.fn.setreg('+', clipboard)

-- Sort files and directories in ascending order
vim.g.netrw_sort_sequence = '[\\/],\\.,\\+,\\,,h,n,s,[^\\/]+,$'

