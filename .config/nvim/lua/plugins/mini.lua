return {
	"echasnovski/mini.nvim",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		require("mini.completion").setup({
			lsp_completion = {
				source_func = "completefunc",
				auto_setup = false,
			},
			mappings = {
				scroll_down = "<C-d",
				scroll_up = "<C-u",
			},
		})
		-- 3. CUSTOM KEY MAPPINGS
		local map = vim.keymap.set
		local opts = { expr = true, replace_keycodes = true }

		-- CTRL+j: Move Down (Next Item)
		map("i", "<C-j>", function()
			return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
		end, opts)

		-- CTRL+k: Move Up (Previous Item)
		map("i", "<C-k>", function()
			return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
		end, opts)

		-- CTRL+y: Accept (Yes)
		-- This is native, but we ensure it works if the menu is open.
		map("i", "<C-y>", function()
			return vim.fn.pumvisible() == 1 and "<C-y>" or "<C-y>"
		end, opts)

		-- CR (Enter): STOP it from accepting completion
		-- If menu is open: Close it (<C-e>) and insert Newline (<CR>)
		-- If menu is closed: Just insert Newline
		map("i", "<CR>", function()
			if vim.fn.pumvisible() == 1 then
				return vim.api.nvim_replace_termcodes("<C-e><CR>", true, true, true)
			else
				return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
			end
		end, { expr = true })
		-- snippets
		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = {
				-- Load custom file with global snippets first
				-- gen_loader.from_file("~/.config/nvim/snippets/global.json"),

				-- Load snippets based on current language by reading files from
				-- "snippets/" subdirectories from 'runtimepath' directories.
				gen_loader.from_lang(),
			},
		})

		-- waiting for mini.snippets
		require("mini.pick").setup({
			mappings = {
				move_down = "<C-j>",
				move_up = "<C-k>",
			},
		})
		require("mini.extra").setup()
		-- using mini.extra for lsp and diagnostic pickers
		local map = vim.keymap.set

		map("n", "<leader>ff", "<cmd>Pick files<cr>")
		map("n", "<leader>fg", "<cmd>Pick grep_live<cr>")
		map("n", "<leader>fd", "<cmd>Pick diagnostic<cr>")
		map("n", "<leader>fh", "<cmd>Pick help<cr>")
		require("mini.statusline").setup({
			use_icons = vim.g.have_nerd_font,
			section_location = "%2l:%-2v",
		})
		require("mini.surround").setup()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.notify").setup()
		-- use mini.notify as default notifier
		vim.notify = require("mini.notify").make_notify()

		require("mini.files").setup()
		map("n", "<leader>n", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>")
		require("mini.indentscope").setup()
		require("mini.icons").setup()
		require("mini.pairs").setup()
		require("mini.cmdline").setup()
	end,
}
