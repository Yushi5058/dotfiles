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
		keys = {
			{ "<leader>oo", "<cmd>ObsidianOpen<cr>" },
			{ "<leader>on", "<cmd>ObsidianNew<cr>" },
			{ "<leader>oT", "<cmd>ObsidianTemplate<cr>" },
			{ "<leader>ot", "<cmd>ObsidianToday<cr>" },
			{ "<leader>oy", "<cmd>ObsidianYesterday<cr>" },
			{ "<leader>ol", "<cmd>ObsidianLink<cr>" },
			{ "<leader>oL", "<cmd>ObsidianLinkNew<cr>" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>" },
			{ "<leader>os", "<cmd>ObsidianSearch<cr>" },
			{ "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>" },
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
		config = function()
			require("glow").setup()
			vim.keymap.set("n", "<c-g", "<cmd>Glow<cr>")
		end,
	},
}
