-- Set space as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- helper function
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- disable space in normal mode for leader key
map({ "n", "v" }, "<space>", "<nop>")

-- Move line up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")


-- dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- lsp maps
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>k", vim.lsp.buf.signature_help)
map("n", "<leader>gd", vim.lsp.buf.definition)
map("n", "<leader>gr", vim.lsp.buf.references)
map("n", "<leader>ca", vim.lsp.buf.code_action)

-- Sane behavior of searching
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- escape search highlight / insert mode
map("n", "jk", "<cmd>nohlsearch<cr>")
map({ "i", "v" }, "jk", "<Esc>")

-- Yank to the clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', { silent = true })
map({ 'n', 'v' }, '<leader>Y', '"+Y', { silent = true })

-- Paste from the clipboard
map({ 'n', 'v' }, '<leader>p', '"+p', { silent = true })
map({ 'n', 'v' }, '<leader>P', '"+P', { silent = true })

-- Delete line to the void register
map({ 'n', 'v' }, '<leader>d', '"_d', { silent = true })

-- Keymaps for neovim splits
map("n", "sv", "<cmd>vsplit<cr>")
map("n", "sh", "<cmd>split<cr>")

-- navigate between splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")
-- resize splits
map("n", "<A-h>", "10<C-w><", { noremap = true, silent = true })
map("n", "<A-l>", "10<C-w>>", { noremap = true, silent = true })
map("n", "<A-j>", "10<C-w>+", { noremap = true, silent = true })
map("n", "<A-k>", "10<C-w>-", { noremap = true, silent = true })
-- netrw explorer
map("n", "<leader>n", "<cmd>Ex<cr>")
