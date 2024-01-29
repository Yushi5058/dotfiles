return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"preservim/vim-markdown",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Obsidian Vault/",
				},
			},
		},
		config = function()
			require("obsidian").setup()
			vim.keymap.set("n", "<c-n>", "<cmd>ObsidianNew<cr>")
			vim.keymap.set("n", "<c-o", "<cmd>ObsidianQuickSwitch<cr>")
		end,
	},
	{
		"ellisonleao/glow.nvim",
		config = function()
			require("glow").setup()
			vim.keymap.set("n", "<c-g", "<cmd>Glow<cr>")
		end,
	},
}
