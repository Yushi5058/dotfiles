return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<C-o>", "<cmd>ObsidianOpen<cr>" },
			{ "<C-n>", "<cmd>ObsidianNew<cr>" },
			{ "<C-s>", "<cmd>ObsidianQuickSwitch<cr>" },
		},
		opts = {
			dir = "~/Obsidian Vault/",
			completion = {
				nvim_cmp = true,
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)
		end,
	},
	{
		"ellisonleao/glow.nvim",
		keys = { "n", "<leader>g", "<cmd>Glow<cr>" },
		config = function()
			require("glow").setup()
		end,
	},
}
