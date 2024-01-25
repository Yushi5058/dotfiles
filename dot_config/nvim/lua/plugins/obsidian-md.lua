return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		keys = {
			{ "<c-o>", "<cmd>ObsidianOpen<cr>" },
			{ "<c-n>", "<cmd>ObsidianNew<cr>" },
			{ "<leader>fo", "<cmd>ObsidianSearch<cr>" },
			{ "<leader>fs", "<cmd>ObsidianQuickSwitch<cr>" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
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
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			--	vim.fn.jobstart({ "open", url }) -- Mac OS
			vim.fn.jobstart({ "xdg-open", url }) -- linux
		end,

		finder = "telescope.nvim",
	},

	{
		"ellisonleao/glow.nvim",
		config = function()
			require("glow").setup()
			vim.keymap.set("n", "<leader>md", "<cmd>Glow<cr>")
		end,
	},
}
