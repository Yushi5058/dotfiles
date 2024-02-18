local keymap = vim.keymap

vim.g.mapleader = " "
-- Escape visual / insert mode
keymap.set({ "i", "v" }, "jk", "<Esc>")

-- disable space in normal mode for leader key
keymap.set({ "n", "v" }, "<space>", "<nop>")

-- save, quit, save & quit files with leader key
keymap.set("n", "<leader>w", "<cmd>w<cr>")
keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Move line up/down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")
keymap.set("n", "<leader>m", "<cmd>Mason<cr>")

-- dealing with word wrap
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- escape search highlight
keymap.set("n", "jk", "<cmd>noh<cr>")

-- split windows
keymap.set("n", "ss", "<cmd>vsplit<cr>")
-- keymap.set("n", "sh", "<cmd>split<cr>") for horizontal split

-- navigate between splits
keymap.set("n", "<c-h", "<cmd>wincmd h<cr>")
keymap.set("n", "<c-l", "<cmd>wincmd l<cr>")
