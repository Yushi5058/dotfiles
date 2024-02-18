return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	keys = {
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			mode = { "n" },
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			"<cmd>Telescope live_grep<cr>",
			mode = { "n" },
			desc = "Telescope live grep",
		},
		{
			"<leader>fh",
			"<cmd>Telescope help_tags<cr>",
			mode = { "n" },
			desc = "Telescope help tags",
		},
	},
}
