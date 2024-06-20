return {
	{
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"folke/trouble.nvim",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		opts = {}, -- for default options, refer to the configuration section for custom setup.
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", mode = { "n" }, desc = "Undotree Toggle" },
		},
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
		keys = {
			{ "<leader>ff", mode = { "n" }, "<cmd>Telescope find_files<cr>" },
			{ "<leader>fg", mode = { "n" }, "<cmd>Telescope live_grep<cr>" },
			{ "<leader>fh", mode = { "n" }, "<cmd>Telescope help_tags<cr>" },
			{ "<leader>fc", mode = { "n" }, "<cmd>TodoTelescope<cr>" },
		},
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{ "<leader>n", mode = { "n" }, "<cmd>lua require('oil').toggle_float()<cr>" },
		},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{ "<leader>z", mode = { "n" }, "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
		},
	},
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
		config = function()
			require("neocord").setup()
		end,
	},
	{
		"ellisonleao/glow.nvim",
		keys = {
			{ "<leader>gl", "<cmd>Glow<cr>", mode = { "n" }, desc = "Markdown preview" },
		},
	},
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>s", mode = { "n" }, "<cmd>lua require('spectre').toggle()<cr>" },
			{ "<leader>sw", mode = { "n" }, "<cmd>lua require('spectre').open_visual({select_word=true})<cr>" },
			{ "<leader>sw", mode = { "v" }, "<cmd>lua require('spectre').open_visual()<cr>" },
			{ "<leader>sp", mode = { "n" }, "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>" },
		},
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		keys = {
			{ "<leader>a", mode = { "n" }, "<cmd>lua require('grapple').toggle<cr>" },
			{ "<c-e>", mode = { "n" }, "<cmd>lua require('grapple').toggle_tags<cr>" },
			{ "<leader>&", mode = { "n" }, "<cmd>Grapple select index=1<cr>" },
			{ "<leader>é", mode = { "n" }, "<cmd>Grapple select index=2<cr>" },
			{ '<leader>"', mode = { "n" }, "<cmd>Grapple select index=3<cr>" },
		},
	},
	{
		"mrjones2014/legendary.nvim",
		priority = 10000,
		lazy = false,
		-- sqlite is only needed if you want to use frecency sorting
		-- dependencies = { 'kkharji/sqlite.lua' }
		opts = {
			extensions = {
				lazy_nvim = true,
			},
		},
	},
}
