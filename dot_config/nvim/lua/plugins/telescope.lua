return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	-- or                              , branch = '0.1.x',
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
		{ "n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files, {}" },
		{ "n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep, {}" },
		{ "n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags, {}" },
	},
}
