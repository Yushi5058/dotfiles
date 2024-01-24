return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
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
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		opts = {
			dir = "~/Documents/Obsidian",
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
			vim.keymap.set("n", "<c-m>", "<cmd>Glow<cr>")
		end,
	},
}
