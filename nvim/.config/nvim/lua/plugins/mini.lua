return {
	"nvim-mini/mini.nvim",
	dependencies = { "rafamadriz/friendly-snippets" },
	keys = {
		-- Picker (f for Find)
		{ "<leader>ff", "<cmd>Pick files<cr>", desc = "Files" },
		{ "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Grep" },
		{ "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
		{ "<leader>fh", "<cmd>Pick help<cr>", desc = "Help" },

		-- File Explorer
		{
			"<leader>e",
			function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0))
			end,
			desc = "Explorer",
		},
	},
	config = function()
		-- Completion
		require("mini.completion").setup({
			mappings = {
				scroll_down = "<C-d>",
				scroll_up = "<C-u>",
			},
		})

		-- Snippets
		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = { gen_loader.from_lang() },
		})

		-- Picker navigation
		require("mini.pick").setup({
			mappings = {
				move_down = "<C-j>",
				move_up = "<C-k>",
			},
		})

		-- Core Modules
		require("mini.extra").setup()
		require("mini.surround").setup()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.icons").setup()
		require("mini.pairs").setup()
		require("mini.indentscope").setup()
		require("mini.statusline").setup({
			use_icons = vim.g.have_nerd_font,
			section_location = "%2l:%-2v",
		})

		-- Notification setup
		require("mini.notify").setup()
		vim.notify = require("mini.notify").make_notify()

		-- System modules
		require("mini.files").setup()
		require("mini.cmdline").setup()
		require("mini.diff").setup()
		require("mini.git").setup()
	end,
}
