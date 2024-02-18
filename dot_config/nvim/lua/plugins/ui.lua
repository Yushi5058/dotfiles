return {
	{
		"echasnovski/mini.nvim",
		version = false,
		keys = {
			{ "n", "<leader>n", "<cmd>lua MiniFiles.open()<cr>" },
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
			{ "n", "<leader>xx", "<cmd>lua require('trouble').toggle()<cr>" },
			{ "n", "<leader>xw", "<cmd>lua require('trouble').toggle('workspace_diagnostics')" },
			{ "n", "<leader>xd", "<cmd>lua require('trouble').toggle('document_diagnostics')" },
			{ "n", "<leader>xq", "<cmd>lua require('trouble').toggle('quickfix')" },
		},
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		"gbprod/yanky.nvim",
		opts = {},
		keys = {
			{ { "n", "x" }, "p", "<Plug>(YankyPutAfter)" },
			{ { "n", "x" }, "P", "<Plug>(YankyPutBefore)" },
			{ { "n", "x" }, "gp", "<Plug>(YankyGPutAfter)" },
			{ { "n", "x" }, "gP", "<Plug>(YankyGPutBefore)" },
			{ { "n", "x" }, "y", "<Plug>(YankyYank)" },
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
}
