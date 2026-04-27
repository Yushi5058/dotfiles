local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Space is leader
map({ "n", "v" }, "<space>", "<nop>")

-- Move blocks (Visual)
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Smooth vertical movement
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Search remains centered
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev result" })

-- Fast escape and clear highlights
map("n", "jk", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map({ "i", "v" }, "jk", "<Esc>", { desc = "Escape" })

-- System clipboard (y/p)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

-- Splits
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "sh", "<cmd>split<cr>", { desc = "Split horizontal" })

-- Split navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize
map("n", "<C-Left>", "10<C-w><")
map("n", "<C-Right>", "10<C-w>>")
map("n", "<C-Up>", "10<C-w>+")
map("n", "<C-Down>", "10<C-w>-")

-- Treesitter textobjects (native since nvim 0.9+)
map("o", "af", "@function.outer", { desc = "Around function" })
map("o", "if", "@function.inner", { desc = "Inner function" })
map("o", "ac", "@class.outer", { desc = "Around class" })
map("o", "ic", "@class.inner", { desc = "Inner class" })
map("v", "af", "@function.outer", { desc = "Select around function" })
map("v", "if", "@function.inner", { desc = "Select inner function" })
map("v", "ac", "@class.outer", { desc = "Select around class" })
map("v", "ic", "@class.inner", { desc = "Select inner class" })
