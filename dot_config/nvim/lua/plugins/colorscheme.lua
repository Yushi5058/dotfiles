return {
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "main",
				dim_inactive_windows = true,
			})

			vim.cmd("colorscheme rose-pine")
		end
	},

	-- Lua
	{
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	}
