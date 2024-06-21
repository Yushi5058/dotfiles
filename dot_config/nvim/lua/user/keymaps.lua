local keymap = vim.keymap
-- disable space in normal mode for leader key
keymap.set({ "n", "v" }, "<space>", "<nop>")

-- Move line up/down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")
keymap.set("n", "<leader>m", "<cmd>Mason<cr>")

-- dealing with word wrap
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- lsp keymaps
keymap.set("n", "K", vim.lsp.buf.hover)
keymap.set("n", "<leader>k", vim.lsp.buf.signature_help)
keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
keymap.set("n", "<leader>gd", vim.lsp.buf.definition)
keymap.set("n", "<leader>gr", vim.lsp.buf.references)
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- escape search highlight / insert mode
keymap.set("n", "jk", "<cmd>nohlsearch<cr>")
keymap.set({ "i", "v" }, "jk", "<Esc>")

-- Yank one word to the clipboard
keymap.set("n", "<leader>yw", '"+yiw', { noremap = true, silent = true })
keymap.set("v", "<leader>yw", '"+y', { noremap = true, silent = true })

-- Yank entire line to the clipboard
keymap.set("n", "<leader>Y", '"+yy', { noremap = true, silent = true })
keymap.set("v", "<leader>Y", '"+y', { noremap = true, silent = true })

-- Paste from the clipboard
keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true })
keymap.set("n", "<leader>P", '"+P', { noremap = true, silent = true })
keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true })
keymap.set("v", "<leader>P", '"+P', { noremap = true, silent = true })

-- Replace selection with clipboard contents
keymap.set("v", "<leader>r", '"_d"+P', { noremap = true, silent = true })

-- Copy file path to clipboard
keymap.set("n", "<leader>cf", ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })

-- Delete line to the void register
keymap.set("n", "<leader>dd", '"_dd', { noremap = true, silent = true })

-- Keymaps for neovim splits
keymap.set("n", "sv", "<cmd>vsplit<cr>")
keymap.set("n", "sh", "<cmd>split<cr>")

-- navigate between splits
keymap.set("n", "<C-h", "<C-w>h")
keymap.set("n", "<C-l", "<C-w>l")
keymap.set("n", "<C-k", "<C-w>k")
keymap.set("n", "<C-j", "<C-w>j")
-- resize splits
vim.keymap.set("n", "<A-h>", "10<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "10<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "10<C-w>+", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "10<C-w>-", { noremap = true, silent = true })
