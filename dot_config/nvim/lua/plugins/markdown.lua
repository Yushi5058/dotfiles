return {

	{
		"ellisonleao/glow.nvim",
		keys = {
			{ "<leader>g", "<cmd>Glow<cr>", mode = { "n" }, desc = "Markdown preview" },
		},
		config = function()
			require("glow").setup()
		end,
	},
}
