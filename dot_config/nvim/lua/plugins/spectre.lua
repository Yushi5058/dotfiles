return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>s", "<cmd>lua require('spectre').toggle()<cr>", mode = { "n" }, desc = "Spectre toggle" },
		{
			"<leader>sw",
			"<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
			mode = { "n", "v" },
			desc = "Spectre visual",
		},
		{
			"<leader>sp",
			"<cmd>lua require('spectre').open_file_search({select_word=true})<cr>",
			mode = { "n" },
			desc = "Spectre search",
		},
	},
	config = function()
		require("spectre").setup()
	end,
}
