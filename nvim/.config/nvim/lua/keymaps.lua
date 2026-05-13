vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })

local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "find" },
	{ "<leader>s", group = "snacks" },

	{ "<leader>y", '"+y', desc = "Yank → clipboard",  mode = { "n", "v" } },
	{ "<leader>p", '"+p', desc = "Paste ← clipboard", mode = { "n", "v" } },
	{ "<leader>d", '"_d', desc = "Delete → void",     mode = { "n", "v" } },

	{ "sv", "<cmd>vsplit<cr>", desc = "Split vertical" },
	{ "sh", "<cmd>split<cr>",  desc = "Split horizontal" },

	{ "<C-h>", "<C-w>h", desc = "Window ←" },
	{ "<C-j>", "<C-w>j", desc = "Window ↓" },
	{ "<C-k>", "<C-w>k", desc = "Window ↑" },
	{ "<C-l>", "<C-w>l", desc = "Window →" },

	{ "<C-Left>",  "10<C-w><", desc = "Resize ←" },
	{ "<C-Right>", "10<C-w>>", desc = "Resize →" },
	{ "<C-Up>",    "10<C-w>+", desc = "Resize ↑" },
	{ "<C-Down>",  "10<C-w>-", desc = "Resize ↓" },

	{ "jk", "<cmd>nohlsearch<cr>", desc = "Clear highlights", mode = "n" },
	{ "jk", "<Esc>",               desc = "Escape",           mode = { "i", "v" } },

	{ "n", "'Nn'[v:searchforward]", desc = "Next match", expr = true, mode = { "n", "x", "o" } },
	{ "N", "'nN'[v:searchforward]", desc = "Prev match", expr = true, mode = { "n", "x", "o" } },

	{ "J", ":m '>+1<CR>gv=gv", desc = "Move block ↓", mode = "v" },
	{ "K", ":m '<-2<CR>gv=gv", desc = "Move block ↑", mode = "v" },

	{ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up",   mode = "n" },
	{ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = "n" },
})