return {
	"nvim-pack/nvim-spectre",
	dependencies = "nvim-lua/plenary.nvim",
	keys = {
		-- <leader>S (capital) avoids collision with <leader>s snacks group
		{ "<leader>S",  function() require("spectre").toggle() end,                              desc = "Spectre toggle" },
		{ "<leader>Sw", function() require("spectre").open_visual({ select_word = true }) end,   desc = "Search word" },
		{ "<leader>Sw", function() require("spectre").open_visual() end,                         desc = "Search selection", mode = "v" },
		{ "<leader>Sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search in file" },
	},
}
