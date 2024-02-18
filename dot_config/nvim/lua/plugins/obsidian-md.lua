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
			{ "<C-o>", "<cmd>ObsidianOpen<cr>", mode = { "n" }, desc = "Open Obsidian" },
			{ "<C-n>", "<cmd>ObsidianNew<cr>", mode = { "n" }, desc = "New Obsidian" },
			{ "<C-s>", "<cmd>ObsidianQuickSwitch<cr>", mode = { "n" }, desc = "Obsidian Quick Switch" },
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
		keys = {
			{ "<leader>g", "<cmd>Glow<cr>", mode = { "n" }, desc = "Markdown preview" },
		},
		config = function()
			require("glow").setup()
		end,
	},
}
