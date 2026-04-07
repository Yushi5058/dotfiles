return {
	"nvim-pack/nvim-spectre",
	dependencies = "nvim-lua/plenary.nvim",
	keys = {
		{
			"<leader>s",
			function()
				require("spectre").toggle()
			end,
			desc = "Spectre",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search Word",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual()
			end,
			mode = "v",
			desc = "Search Word",
		},
		{
			"<leader>sp",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Search File",
		},
	},
}
