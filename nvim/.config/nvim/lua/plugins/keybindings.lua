return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			-- Declare groups that span multiple plugin files
			wk.add({
				{ "<leader>b", group = "database" },
				{ "<leader>S", group = "spectre/search" },
			})
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			picker = { enabled = true },
		},
		keys = {
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
		},
	},
}
