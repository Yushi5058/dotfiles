return {
	{
		"echasnovski/mini.nvim",
		version = false,
		lazy = false,
		keys = {
			{ "<leader>n", "<cmd>lua MiniFiles.open()<cr>", mode = { "n" }, desc = "File explorer" },
		},
		config = function()
			require("mini.cursorword").setup()
			require("mini.indentscope").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.animate").setup()
			require("mini.comment").setup()
			require("mini.statusline").setup()
			require("mini.starter").setup()
			require("mini.notify").setup()
			require("mini.files").setup()
			require("mini.completion").setup() -- complementary to nvim-cmp for now
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
	{
		"folke/drop.nvim",
		event = "VimEnter",
		config = function()
			require("drop").setup()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{ "tpope/vim-sleuth" },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
