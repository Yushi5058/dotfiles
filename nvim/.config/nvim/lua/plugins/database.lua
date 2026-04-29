return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		require("dbee").install()
	end,
	keys = {
		{ "<leader>bt", function() require("dbee").toggle() end, desc = "DBee: Toggle UI" },
		{ "<leader>be", function() require("dbee").execute() end, desc = "DBee: Execute Query" },
		{ "<leader>bs", function() require("dbee").sidebar_toggle() end, desc = "DBee: Toggle Sidebar" },
		{ "<leader>ba", function() require("dbee").execute() end, desc = "DBee: Action (Execute)" },
		{ "<leader>bq", function() require("dbee").close() end, desc = "DBee: Quit/Close" },
	},
	config = function()
		require("dbee").setup()
	end,
}
