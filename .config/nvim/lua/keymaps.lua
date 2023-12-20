local keymap = vim.keymap

-- Netrw file explorer
keymap.set("n", "<leader>pv", "<cmd>Ex<cr>")


-- Escape visual / insert mode
keymap.set({"i","v"}, "jk", "<Esc>")

-- Move line up/down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")


-- Split window
keymap.set("n", "ss", ":split<Return>")
keymap.set("n", "sv", ":vsplit<Return>")

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")


-- Disable highlight search
keymap.set('n', '<leader>h', ':nohlsearch<CR>')






