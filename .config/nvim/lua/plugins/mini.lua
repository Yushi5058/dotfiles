return {
	"echasnovski/mini.nvim",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		require("mini.completion").setup({
			mappings = {
				scroll_down = "<C-d",
				scroll_up = "<C-u",
			},
		})
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
