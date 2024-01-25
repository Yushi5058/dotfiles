return {

	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({

			use_default_keymaps = false,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
			},
			float = {
				-- Padding around the floating window
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
		})

		vim.keymap.set("n", "<leader>pv", function()
			require("oil").toggle_float()
		end)
	end,
}
