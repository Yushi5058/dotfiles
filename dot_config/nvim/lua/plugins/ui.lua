return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.cursorword").setup()
			require("mini.indentscope").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.animate").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "catppuccin",
					component_separators = "|",
					section_separators = "",
				},
			})
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
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		config = function()
			vim.keymap.set("n", "<leader>xq", function()
				require("trouble").toggle("quickfix")
			end)
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		-- amongst your other plugins
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = function()
				require("toggleterm").setup()
				vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>")
			end,
		},
	},
}
