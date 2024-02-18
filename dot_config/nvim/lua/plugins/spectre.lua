return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "n", "<leader>s", "<cmd>lua require('spectre').toggle()<cr>" },
		{ { "n", "v" }, "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>" },
		{ "n", "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>" },
	},
	config = function()
		require("spectre").setup()
	end,
}
