-- Space as leader — suppress default space action
vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })

-- All mappings registered through which-key so they appear in the popup.
-- Deferred to VeryLazy so which-key is loaded first.
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		local wk = require("which-key")
		wk.add({
			-- ── Groups ──────────────────────────────────────────────────────
			{ "<leader>f", group = "find" },
			{ "<leader>s", group = "snacks" },

			-- ── Clipboard ───────────────────────────────────────────────────
			-- Explicit system clipboard; default clipboard="" keeps registers clean
			{ "<leader>y", '"+y', desc = "Yank → clipboard",  mode = { "n", "v" } },
			{ "<leader>p", '"+p', desc = "Paste ← clipboard", mode = { "n", "v" } },
			{ "<leader>d", '"_d', desc = "Delete → void",     mode = { "n", "v" } },

			-- ── Splits ──────────────────────────────────────────────────────
			-- sv/sh: mnemonic split-vertical / split-horizontal
			{ "sv", "<cmd>vsplit<cr>", desc = "Split vertical" },
			{ "sh", "<cmd>split<cr>",  desc = "Split horizontal" },

			-- ── Window navigation ────────────────────────────────────────────
			{ "<C-h>", "<C-w>h", desc = "Window ←" },
			{ "<C-j>", "<C-w>j", desc = "Window ↓" },
			{ "<C-k>", "<C-w>k", desc = "Window ↑" },
			{ "<C-l>", "<C-w>l", desc = "Window →" },

			-- ── Window resize ────────────────────────────────────────────────
			{ "<C-Left>",  "10<C-w><", desc = "Resize ←" },
			{ "<C-Right>", "10<C-w>>", desc = "Resize →" },
			{ "<C-Up>",    "10<C-w>+", desc = "Resize ↑" },
			{ "<C-Down>",  "10<C-w>-", desc = "Resize ↓" },

			-- ── Search ──────────────────────────────────────────────────────
			-- jk: AZERTY-friendly escape (j and k are adjacent on AZERTY)
			{ "jk", "<cmd>nohlsearch<cr>", desc = "Clear highlights", mode = "n" },
			{ "jk", "<Esc>",               desc = "Escape",           mode = { "i", "v" } },

			-- Keep search direction consistent regardless of / or ?
			{ "n", "'Nn'[v:searchforward]", desc = "Next match", expr = true, mode = { "n", "x", "o" } },
			{ "N", "'nN'[v:searchforward]", desc = "Prev match", expr = true, mode = { "n", "x", "o" } },

			-- ── Visual block movement ────────────────────────────────────────
			{ "J", ":m '>+1<CR>gv=gv", desc = "Move block ↓", mode = "v" },
			{ "K", ":m '<-2<CR>gv=gv", desc = "Move block ↑", mode = "v" },

			-- ── Wrapped-line movement ────────────────────────────────────────
			-- Moves by display line when no count given (useful with wrap=false too)
			{ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up",   mode = "n" },
			{ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = "n" },
			-- nvim 0.12 built-in node selection (visual mode): an/in/]n/[n
		})
	end,
})
