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
			"<cmd>lua require('telescope.builtin').find_files, {}",
			mode = { "n" },
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			"<cmd>lua require('telescope.builtin').live_grep, {}",
			mode = { "n" },
			desc = "Telescope live grep",
		},
		{
			"<leader>fh",
			"<cmd>lua require('telescope.builtin').help_tags, {}",
			mode = { "n" },
			desc = "Telescope help tags",
		},
	},
}
