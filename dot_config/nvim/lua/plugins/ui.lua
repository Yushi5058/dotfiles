return {
	{
		"echasnovski/mini.nvim",
		version = false,
		lazy = false,
		config = function()
			require("mini.files").setup()
			require("mini.cursorword").setup()
			require("mini.indentscope").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			-- NOTE:
			-- add = 'sa', -- Add surrounding in Normal and Visual modes
			--  delete = 'sd', -- Delete surrounding
			--  find = 'sf', -- Find surrounding (to the right)
			--  find_left = 'sF', -- Find surrounding (to the left)
			--  highlight = 'sh', -- Highlight surrounding
			--  replace = 'sr', -- Replace surrounding
			require("mini.animate").setup()
			require("mini.comment").setup()
			-- NOTE:
			-- on visual mode :
			-- gc to comment
			-- gcc to comment current line
			require("mini.statusline").setup()
			require("mini.starter").setup()
			require("mini.notify").setup()

			-- keymap for mini.files
			vim.keymap.set("n", "<leader>n", ":lua MiniFiles.open()<cr>")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"folke/neodev.nvim",
		opts = {},
		config = function()
			require("neodev").setup()
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
		config = function()
			require("dressing").setup()
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>lua require('trouble').toggle()<cr>", mode = { "n" }, desc = "Trouble toggle" },
			{
				"<leader>xw",
				"<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>",
				mode = { "n" },
				desc = "Trouble Workspace Diagnostics",
			},
			{
				"<leader>xd",
				"<cmd>lua require('trouble').toggle('document_diagnostics')<cr>",
				mode = { "n" },
				desc = "Trouble Document Diagnostics",
			},
			{
				"<leader>xq",
				"<cmd>lua require('trouble').toggle('quickfix')<cr>",
				mode = { "n" },
				desc = "Trouble Quickfix",
			},
		},
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", mode = { "n" }, desc = "Undotree Toggle" },
		},
	},
	{
		"gbprod/yanky.nvim",
		opts = {},
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
		},
		config = function()
			require("yanky").setup({
				ring = {
					history_length = 100,
					storage = "shada",
					sync_with_numbered_registers = true,
					cancel_event = "update",
					ignore_registers = { "_" },
					update_register_on_cycle = false,
				},
				system_clipboard = {
					sync_with_ring = true,
				},
			})
		end,
	},
	{ "tpope/vim-sleuth" },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
		end,
	},
	{
		"mrjones2014/legendary.nvim",
		priority = 10000,
		lazy = false,
		config = function()
			require("legendary").setup({
				extensions = {
					lazy_nvim = true,
				},
			})

			vim.keymap.set("n", "<leader>wk", ":Legendary<cr>")
		end,
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
}
